exception Results_not_found

let pos = ref 0
let ic = ref stdin
let chain = ref []

let get_pos () = !pos

let init file research = 
  let () = pos := 0 in
  let () = ic := open_in_bin file in
  let rec research_to_chain string =
    let rec loop i string list =
      if i > ((String.length string) - 1) then
	list
      else
	loop (i+1) string ((int_of_char (string.[i]))::list)
    in loop 0 string []
  in    
  let differential_chain chain =
    let rec loop res chain =
      match chain with
	  [] -> failwith "Should not happen"
	| head::[] -> List.rev res
	| head::tail -> loop (((List.hd tail) - head)::res) tail 
    in
      loop [] chain
  in
    chain := differential_chain (research_to_chain research)
      

let main_function () =
    
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
  
  let rec search_byte_chain_in_channel (res : int list) (previous_byte : int) (todos : (int * int list) list) (chain : int list) (channel : in_channel) =
    let new_byte =
      try
	input_byte channel
      with
	  End_of_file -> -1
    in
      if new_byte > -1 then
	let current_pos =  (pos_in channel) -1 in
	  if previous_byte = -1 then
	    search_byte_chain_in_channel res new_byte todos chain channel
	  else
	    let new_todo = (current_pos-1),chain 
	    in
	    let new_res,todos = search_byte_with_todos (new_todo::todos) (new_byte - previous_byte) in
	      search_byte_chain_in_channel (new_res@res) new_byte todos chain channel
      else
	res
  in
    
  let res = search_byte_chain_in_channel [] 0 [] !chain !ic 
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
  seek_in !ic 0;
  (*Printf.printf "%s%!" (results ic res int_chain 10 10);*)
  let return = results !ic res !chain 10 10 in
  close_in !ic;
    return
