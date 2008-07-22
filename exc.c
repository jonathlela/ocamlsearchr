#include <stdio.h>
#include "ocamlsearchr.h"

int main(int argc, char ** argv)
{
  struct result result;
  initialize_ocaml(argv);
  /* Do some computation */
  init("Neugier.smc","sword");
  result = ocamlsearch();
  printf("ocamlsearch(Neugier.smc,sword) =\n%i A=%i\n",result.position,result.difference);
  result = ocamlsearch();
  printf("ocamlsearch(Neugier.smc,sword) =\n%i A=%i\n",result.position,result.difference);
  return 0;
}
