#include <stdio.h>
#include <stdlib.h>
#include "ocamlsearchr.h"

int main(int argc, char ** argv)
{
  int search;
  result * result;
  bytechain * match;

  /* Do some computation */
  search = init("Neugier.smc","sword");
  while (1) {
      result = ocamlsearch(search);
      if (result_equals(result,&Not_found)) {
	printf("Results not found!\n");
	break;
      }
      else {
	int i;
	int position = result->position;
	match = result->match;

	char * res = match->chain;
	for(i=0; i < match->length; i++) {
	  printf("@|%X|\n",res[i]);
	}
	printf("ocamlsearch(Neugier.smc,sword) =\n%i A=%i\n",position,position);
      }
      delete_struct(result);
  }
  return 0;
}
