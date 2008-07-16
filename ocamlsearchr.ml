(*let file = Sys.argv.(1) in

let research =  Sys.argv.(2) in*)

exception Results_not_found

let _ = Callback.register_exception "Results not found" Results_not_found

let main_function file research =

let rec research_to_chain (i : int) (string : string) =
  if i > ((String.length string) - 1) then
    []
  else
    (int_of_char (string.[i])) :: (research_to_chain (i+1) string)
in

let int_chain = research_to_chain 0 research
in

let ic = open_in_bin file 
in

let length = in_channel_length ic in

let range_list (min : int) (max : int) =
  let rec loop l i j =
    if i > j then
      l
    else
      loop (i::l) (i+1) j
  in
    loop [] min max
in

let file_percents =
  List.rev
    (
      List.map
	(
	  fun i -> match i with
	      0 -> 0,0
	    | _ -> (length*i/100),i
	)
	(range_list 0 100)
    )
in
  
let differential_chain chain =
  let rec loop res c =
    match c with
	[] -> failwith "Should not happen"
      | head::[] -> res
      | head::tail -> loop (((List.hd tail)- head)::res) tail 
  in
    loop [] chain
in

let chain = List.rev (differential_chain int_chain) in


let search_byte_with_todos (todos : (int * int list) list) (diff : int) =
  List.fold_left
    (
      fun (final,new_todos) todo -> match todo with
	  i,[] -> i::final,new_todos
	| i,value::tail -> 
	    if value = diff then
	      final,(i,tail)::new_todos
	    else
	      final,new_todos
		
    )
    ([],[]) todos 
in
  
let rec search_byte_chain_in_channel (res : int list) (percent : (int * int) list) (previous_byte : int) (todos : (int * int list) list) (chain : int list) (channel : in_channel) =
  let new_byte =
    try
      input_byte channel
    with
	End_of_file -> -1
  in
    if new_byte > -1 then
      let current_pos =  (pos_in channel) -1 in
      let new_percent =
	match percent with
	    (head,i)::tail -> 
	      if head = current_pos then
		let () = Printf.printf ("%i\n%!") i in tail 
	      else percent
	  | _ -> percent
      in
	if previous_byte = -1 then
	  search_byte_chain_in_channel res new_percent new_byte todos chain channel
	else
	  let new_todo = (current_pos-1),chain 
	  in
	  let new_res,todos = search_byte_with_todos (new_todo::todos) (new_byte - previous_byte) in
	    search_byte_chain_in_channel (new_res@res) new_percent new_byte todos chain channel
    else
      res
in
  
let res = search_byte_chain_in_channel [] (List.rev file_percents) 0 [] chain ic

in
let n_steps_chars n channel diff =
  let rec loop string n channel diff =
    match n with
	0 -> string
      | _ -> 
	  try 
	    let current = input_byte channel in
	    let differencied_current = current + diff in
	      if differencied_current < 32 || differencied_current > 126 then
		loop (string^".") (n-1) channel diff
	      else
		loop (string^(Printf.sprintf "%c" (char_of_int differencied_current))) (n-1) channel diff
	  with
	    End_of_file -> string
  in
    loop "" n channel diff
in

let n_steps_hex n channel diff =
  let rec loop string n channel diff =
    match n with
	0 -> String.sub string 1 ((String.length string)-1)
      | _ -> 
	  try 
	    let current = input_byte channel in
	    let differencied_current = current + diff in
	      loop (string^" "^(Printf.sprintf "%02X" differencied_current)) (n-1) channel diff
	  with
	    End_of_file -> string
  in
    loop "" n channel diff
in
let results channel positions int_chain before after = 
  List.fold_left
    (
      fun str pos -> 
	seek_in channel (pos);
	let current = input_byte channel in
	let diff = (List.hd int_chain) - current in
	seek_in channel (pos-before-1);
	let str_pre1 = n_steps_hex before channel 0 in
	seek_in channel (pos-before);
	let str_pre2 = n_steps_chars before channel diff in
	seek_in channel (pos+1);
	let str_post1 = n_steps_hex after channel 0 in
	seek_in channel (pos+1);
	let str_post2 = n_steps_chars after channel diff in
	(Printf.sprintf "%08d" pos)^": "^str_pre1^" "^(Printf.sprintf "%02X" (current + diff))^" "^str_post1^" | "^str_pre2^(Printf.sprintf "%c" (char_of_int (current + diff)))^str_post2^", "^(Printf.sprintf "A=%02X" ((int_of_char 'A') + diff))^"\n"^str
    )
    "" positions
in
  
  if res = [] then
    (*Printf.printf "No results found\n%!"*)
    raise Results_not_found
  else
    (*Printf.printf "Results found:\n%!";*)
  seek_in ic 0;
  (*Printf.printf "%s%!" (results ic res int_chain 10 10);*)
  let return = results ic res int_chain 10 10 in
  close_in ic;
    return

let _ = Callback.register "ocamlsearch" main_function
