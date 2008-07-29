#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/callback.h>

static void initialize_ocaml(void) __attribute__ ((constructor));

typedef struct {
  int length;
  char * chain;
} bytechain;

typedef struct {
  int position; 
  bytechain * match;
} result;


result * new_struct(const value * res) {

  result * result;
  bytechain * chain;
  char * array;

  value position = Field(*res,0);
  value match = Field(*res,1);

  int pos = Int_val(position);

  int length = Wosize_val(match);
  array = malloc(length*sizeof(char));

  int i;
  for (i = 0; i < length; i++) {
    array[i] = Int_val(Field(match,i));
  }

  chain = malloc(sizeof(bytechain));
  chain->length = length;
  chain->chain = array;  

  result = malloc(sizeof(result));
  result->position = pos;
  result->match = chain;

  return result;
}


void delete_struct(result * res) {
  free(res->match->chain);
  free(res->match);
  free(res);

}

const result Not_found = {-1, NULL};

int result_equals(const result * r1, const result * r2) {
  return r1->position == r2->position;
} 

void initialize_ocaml()
{
  char *empty[2];
  empty[0] = "";
  empty[1] = NULL;

  caml_startup(empty);
}

void init(char * file, char * research)
{
  static value * init = NULL;
  if (init == NULL)
    init = caml_named_value("init");
  caml_callback2(*init, caml_copy_string(file), caml_copy_string(research));
}

void reset()
{
  static value * reset = NULL;
  if (reset == NULL)
    reset = caml_named_value("reset");
  caml_callback(*reset, Val_int(0));
}

result * ocamlsearch()
{
  static value * ocamlsearch = NULL;
  value res;

  if (ocamlsearch == NULL)
    ocamlsearch = caml_named_value("ocamlsearchr");
  result tmp;  
  result * result;  
  res = callback_exn(*ocamlsearch, Val_int(0));
  if (Is_exception_result(res)) 
    {
      tmp = Not_found;
      result = &tmp;
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
