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
  int result;
  result = ocamlsearch();
  return INT2FIX(result);
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
