#include "ocamlsearchr.h"
#include "ruby.h"

VALUE cOcamlSearchR;

static VALUE t_init(VALUE self, VALUE file, VALUE word)
{
  char *vide[2];

  vide[0] = "bof";
  vide[1] = NULL;
  initialize_ocaml(vide);
  init(STR2CSTR(file),STR2CSTR(word));
  return self;

}

static VALUE t_search(VALUE self)
{
  struct result result;
  VALUE res;

  result = ocamlsearch();
  if (result_equals(&result, &Not_found))
    rb_raise(rb_eException, "Results not found");
  res = rb_ary_new();
  rb_ary_push(res, INT2FIX(result.position));
  rb_ary_push(res, INT2FIX(result.difference));
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
  rb_define_method(cOcamlSearchR, "pos", t_pos, 0);
  rb_define_method(cOcamlSearchR, "search", t_search, 0);
}
