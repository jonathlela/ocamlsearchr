#include <stdio.h>
#include <string.h>
#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/callback.h>

void initialize_ocaml (char ** argv)
{
  caml_startup(argv);
}

char * ocamlsearch(char * file, char * research)
{
  static value * ocamlsearch = NULL;
  if (ocamlsearch == NULL)
    ocamlsearch = caml_named_value("ocamlsearch");
  return strdup(String_val(caml_callback2(*ocamlsearch, caml_copy_string(file), caml_copy_string(research))));
}
