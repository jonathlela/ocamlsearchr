#include <stdio.h>
#include "ocamlsearchr.h"

int main(int argc, char ** argv)
{
  char * result;
  initialize_ocaml(argv);
  /* Do some computation */
  result = ocamlsearch("Neugier.smc","sword");
  printf("ocamlsearch(Neugier.smc,sword) =\n%s",result);
  return 0;
}
