#include <stdio.h>
#include <string.h>
#include <caml/mlvalues.h>
#include <caml/callback.h>
#include <caml/memory.h>

void initialize_ocaml (char ** argv);

char * ocamlsearch(char * file, char * research);
