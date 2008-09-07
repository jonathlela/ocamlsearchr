open Relative_search

let searchs = ref (Array.make 0 RelativeSearch.empty)

let pos search =
  RelativeSearch.get_pos !searchs.(search)

let init file research =
  let new_search = RelativeSearch.init file research in
  let nb_searchs = Array.length !searchs in
  let () = searchs := Array.append !searchs [|new_search|] in
    nb_searchs

let close search =
  RelativeSearch.close !searchs.(search)
    
let reset search =
  RelativeSearch.reset !searchs.(search)

let search search =
  RelativeSearch.search !searchs.(search)
