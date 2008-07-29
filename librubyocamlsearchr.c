#include "ocamlsearchr.h"
#include "ruby.h"

VALUE cOcamlSearchR;

static VALUE t_init(VALUE self, VALUE file, VALUE word)
{
  init(STR2CSTR(file),STR2CSTR(word));
  return self;
}

static VALUE t_reset()
{
  reset();
}

static VALUE t_search(VALUE self)
{
  result * result;
  VALUE res;
  VALUE bytes;
  int position;
  bytechain * match;
  char * chain;

  res = rb_ary_new();
  bytes = rb_ary_new();

  result = ocamlsearch();
  if (result_equals(result, &Not_found))
    rb_raise(rb_eException, "Results not found");
 
  position = result->position;
  match = result->match;
  chain = match->chain;

  int i;
  for(i=0; i < match->length; i++) {
    rb_ary_push(bytes, INT2FIX(chain[i]));
  }

  delete_struct(result);

  rb_ary_push(res, INT2FIX(position));
  rb_ary_push(res, bytes);
  
  return res;
}

static VALUE t_pos(VALUE self)
{
  int pos;
  pos = get_position();
  return INT2FIX(pos);
}

void Init_librubyocamlsearchr() {
  cOcamlSearchR = rb_define_class("OcamlSearchR", rb_cObject);
  rb_define_method(cOcamlSearchR, "initialize", t_init, 2);
  rb_define_method(cOcamlSearchR, "reset", t_reset, 0);
  rb_define_method(cOcamlSearchR, "pos", t_pos, 0);
  rb_define_method(cOcamlSearchR, "search", t_search, 0);
}
