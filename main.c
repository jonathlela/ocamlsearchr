#include <stdio.h>
#include "ocamlsearch.h"

int main(int argc, char ** argv)
{
  char * result;
  initialize_ocaml(argv);
  /* Do some computation */
  result = ocamlsearch("Neugier.smc","sword");
  printf("ocamlsearch(Neugier.smc,sword) =\n%s\n",result);
  return 0;
}
