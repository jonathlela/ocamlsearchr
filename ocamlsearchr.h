struct result {
  int position; 
  int * match;
};

const struct result Not_found;

int result_equals(const struct result * r1, const struct result * r2);

void initialize_ocaml(char ** argv);

void initialize(char * file, char * research);

int get_position();

struct result ocamlsearch();
