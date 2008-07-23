#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/callback.h>

struct result {
  int position; 
  int * match;
};


struct result new_struct(const value * res) {

  struct result result;

  value position = Field(*res,0);
  value match = Field(*res,1);

  int pos = Int_val(position);

  int * array;
  int length = Wosize_val(match);
  array = malloc(length*sizeof(int));

  int i;
  for (i = 0; i < length; i++) {
    array[i] = Int_val(Field(match,i));
  }

  result.position = pos;
  result.match = array;

  return result;
}


void delete_struct(struct result * res) {
  free(res->match);
}

const struct result Not_found = {-1, NULL};

int result_equals(const struct result * r1, const struct result * r2) {
  return r1->position == r2->position;
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
      result = new_struct(&res);
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
