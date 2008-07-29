typedef struct {
  int length;
  char * chain;
} bytechain;

typedef struct {
  int position; 
  bytechain * match;
} result;

void delete_struct(result * res);

const result Not_found;

int result_equals(const result * r1, const result * r2);

void initialize_ocaml(char ** argv);

void initialize(char * file, char * research);

int get_position();

result * ocamlsearch();
