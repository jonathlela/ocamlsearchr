open Relative_search

let _ = Callback.register_exception "Results not found" RelativeSearch.Results_not_found

let _ = Callback.register_exception "No such search" (Invalid_argument "index out of bound")

let _ = Callback.register "pos" Search_manager.pos 

let _ = Callback.register "init" Search_manager.init

let _ = Callback.register "close" Search_manager.close

let _ = Callback.register "reset" Search_manager.reset

let _ = Callback.register "ocamlsearchr" Search_manager.search

let _ = Callback.register "to_array" Array.of_list
