let _ = Callback.register_exception "Results not found" Relative_search.Results_not_found

let _ = Callback.register "ocamlsearchr" Relative_search.main_function
