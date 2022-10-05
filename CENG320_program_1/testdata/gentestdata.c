#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <bigint.h>

// create NTESTS regression tests
#define NTESTS 50000
// create tests with up to MAXLEN decimal digits for A and B
#define MAXLEN 510

char filename[]="regression_tests.dat";

void bigint_dump(bigint b);


/* Function to generate a random string of digits with 50% chance of
   starting with a minus sign */
void randomintstr(char *s,int maxdigits)
{
  int i=0;
  // create a random string of n digits where n is between 1 and
  // maxdigits-1, possibly preceded by a minus sign.
  int n = (random()%(maxdigits-1))+1;
  if(random() & 1)
      s[i++]='-';
  n--;  
  s[i++] = (random()%9)+'1'; /* first digit cannot be zero */
  while(i<n)  // create the remaining digits
    s[i++] = (random()%10)+'0';
  s[i]=0; // add ASCII null
}

/* Open file and generate NTESTS data sets. Each data set consists of
   a, b, a+b, a-b, a*b, sqrt(abs(a)), either a/b or b/a, depending
   on whether a or b has the highest absolute value, -a, and the result 
   of bigint_cmp(a,b)  */
int main()
{
  static char s1[MAXLEN+2];  // add 2 to account for '-' sign and ASCII null
  static char s2[MAXLEN+2];
  bigint a;
  bigint b;
  bigint c;
  bigint aabs;
  bigint babs;
  int i,tmp;
  FILE *outf;
  bigint zero = bigint_from_int(0);

  srandom(time(NULL));
    
  printf("Generating file\n");
  if((outf = fopen(filename,"w"))==NULL)
    {
      perror("Unable to open file");
      exit(1);
    }

  for(i=0;i<NTESTS;i++)
    {
      if(!((i+1)%1000))
	printf("%10d/%d\n",i+1,NTESTS);

      randomintstr(s1,MAXLEN);
      randomintstr(s2,MAXLEN);

      a = bigint_from_str(s1);
      b = bigint_from_str(s2);
      bigint_write_binary(outf,a);
      bigint_write_binary(outf,b);

      c = bigint_add(a,b);
      bigint_write_binary(outf,c);
      bigint_free(c);
      
      c = bigint_sub(a,b);
      bigint_write_binary(outf,c);
      bigint_free(c);
      
      c = bigint_mul(a,b);
      bigint_write_binary(outf,c);
      bigint_free(c);
      
      aabs = bigint_abs(a);
      babs = bigint_abs(b);

      c = bigint_sqrt(aabs);
      bigint_write_binary(outf,c);
      bigint_free(c);
      
      if(bigint_gt(aabs,babs))
	c = bigint_div(a,b);
      else
	c = bigint_div(b,a);
      bigint_write_binary(outf,c);
      bigint_free(c);

      c = bigint_negate(a);
      bigint_write_binary(outf,c);
      bigint_free(c);

      tmp = bigint_cmp(a,b);
      fwrite(&tmp,sizeof(int),1,outf);

      bigint_free(a);
      bigint_free(b);
    }
  fclose(outf);
  return 0;
}
