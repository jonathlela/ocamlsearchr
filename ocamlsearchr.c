#include <stdio.h>
#include <string.h>
#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/callback.h>

void initialize_ocaml(char ** argv)
{
  caml_startup(argv);
}

char * ocamlsearch(char * file, char * research)
{
  static value * init = NULL;
  static value * ocamlsearch = NULL;
  if (init == NULL)
    init = caml_named_value("init");
  if (ocamlsearch == NULL)
    ocamlsearch = caml_named_value("ocamlsearchr");
  caml_callback2(*init, caml_copy_string(file), caml_copy_string(research));
  return strdup(String_val(caml_callback2(*ocamlsearch, Val_int(0))));
}
