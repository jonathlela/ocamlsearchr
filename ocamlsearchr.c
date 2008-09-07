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
  int iterator;

  value position = Field(*res,0);
  value match = Field(*res,1);

  int pos = Int_val(position);

  int length = Wosize_val(match);

  array = malloc(length*sizeof(char));
  for (iterator=0; iterator < length; iterator++) {
    array[iterator] = Int_val(Field(match,iterator));
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

int init(char * file, char * research)
{
  static value * init = NULL;
  value res;

  if (init == NULL)
    init = caml_named_value("init");
  res = caml_callback2(*init, caml_copy_string(file), caml_copy_string(research));
  return Int_val(res);
}

void reset(int search)
{
  static value * reset = NULL;
  if (reset == NULL)
    reset = caml_named_value("reset");
  caml_callback(*reset, Val_int(search));
}

result * ocamlsearch(int search)
{
  static value * ocamlsearch = NULL;
  value res;
  result * result;  

  if (ocamlsearch == NULL)
    ocamlsearch = caml_named_value("ocamlsearchr"); 
  res = callback_exn(*ocamlsearch, Val_int(search));
  if (Is_exception_result(res)) 
    {
      result = malloc(sizeof(result));
      result->position  = Not_found.position;
      result->match  = Not_found.match;
      printf("Not_found: %i\n",result->position);
    }
  else
    {
      result = new_struct(&res);
    }
  return result;
}


int get_position(int search)
{
  static value * pos = NULL;
  if (pos == NULL)
    pos = caml_named_value("pos");
  return Int_val(caml_callback(*pos, Val_int(search)));
}
