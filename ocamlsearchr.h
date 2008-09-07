typedef struct {
  int length;
  char * chain;
} bytechain;

typedef struct {
  int position; 
  bytechain * match;
} result;

void delete_struct(result * res);

extern const result Not_found;

int result_equals(const result * r1, const result * r2);

int init(char * file, char * research);

int get_position(int search);

result * ocamlsearch(int search);
