#include <stdio.h>
#include <string.h>
#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/callback.h>

typedef enum { FALSE, TRUE } boolean;

struct result {
  int position; 
  int difference;
};

const struct result Not_found = {-1,-1};

int result_equals(const struct result * r1, const struct result * r2) {
  return r1->position == r2->position && r1->difference == r2->difference;
} 

void initialize_ocaml(char ** argv)
{
  caml_startup(argv);
}

void init(char * file, char * research)
{
  static value * init = NULL;
  if (init == NULL)
    init = caml_named_value("init");
  caml_callback2(*init, caml_copy_string(file), caml_copy_string(research));
}

struct result ocamlsearch()
{
  static value * ocamlsearch = NULL;
  value res;
  if (ocamlsearch == NULL)
    ocamlsearch = caml_named_value("ocamlsearchr");
  struct result result;
  res = callback_exn(*ocamlsearch, Val_int(0));
  if (Is_exception_result(res)) 
    {
      result = Not_found;
    }
  else
    {
      result.position = Int_val(Field(res,0));
      result.difference = Int_val(Field(res,1));
    }
  return result;
}


int get_position()
{
  static value * pos = NULL;
  if (pos == NULL)
    pos = caml_named_value("pos");
  return Int_val(caml_callback(*pos, Val_int(0)));
}
