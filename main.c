#include <stdio.h>
#include "ocamlsearch.h"

int main(int argc, char ** argv)
{
  char * result;
  initialize(argv);
  /* Do some computation */
  result = ocamlsearch("Neugier.smc","sword");
  printf("ocamlsearch(Neugier.smc,sword) = %s\n",result);
  return 0;
}
