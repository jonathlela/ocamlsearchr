struct result {
  int position; 
  int difference;
};

void initialize_ocaml(char ** argv);

void initialize(char * file, char * research);

int get_position();

struct result ocamlsearch();
