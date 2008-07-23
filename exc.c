#include <stdio.h>
#include <stdlib.h>
#include "ocamlsearchr.h"

int main(int argc, char ** argv)
{
  struct result result;
  initialize_ocaml(argv);
  /* Do some computation */
  init("Neugier.smc","sword");
  while (1) {
      result = ocamlsearch();
      if (result_equals(&result,&Not_found))
	break;
      else {
	int i;
	int position = result.position;
	int * res = result.match;
	for(; *res != 0; ++res) {
	  printf("@|%X|\n",*res);
	}
	printf("ocamlsearch(Neugier.smc,sword) =\n%i A=%i\n",result.position);
	delete_struct(&result);
      }
  }
  return 0;
}
