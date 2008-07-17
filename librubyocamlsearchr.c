#include "ocamlsearchr.h"
#include "ruby.h"

VALUE cOcamlSearchR;

static VALUE t_init(VALUE self)
{
  char *vide[2];

  vide[0] = "bof";
  vide[1] = NULL;
  initialize_ocaml(vide);
  return self;
}


static VALUE t_search(VALUE self, VALUE file, VALUE word)
{
  char * result;
  result = ocamlsearch(STR2CSTR(file),STR2CSTR(word));
  return rb_str_new2(result);
}

void Init_librubyocamlsearchr() {
  cOcamlSearchR = rb_define_class("OcamlSearchR", rb_cObject);
  rb_define_method(cOcamlSearchR, "initialize", t_init, 0);
  rb_define_method(cOcamlSearchR, "search", t_search, 2);
}
