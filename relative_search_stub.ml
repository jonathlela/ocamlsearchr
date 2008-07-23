let _ = Callback.register_exception "Results not found" Relative_search.Results_not_found

let _ = Callback.register "pos" Relative_search.get_pos

let _ = Callback.register "init" Relative_search.init

let _ = Callback.register "ocamlsearchr" Relative_search.search

let _ = Callback.register "to_array" Array.of_list
