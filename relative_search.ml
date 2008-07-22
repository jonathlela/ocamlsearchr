exception Results_not_found

type config = {
  previous_byte: int;
  to_do_list: (int * int list) list;
}

let pos = ref 0
let ic = ref stdin
let file = ref ""
let research = ref ""
let chain = ref []
let config = ref {previous_byte=0; to_do_list=[]}

let get_pos () = !pos

let rec research_to_chain string =
  let rec loop i string list =
      if i > ((String.length string) - 1) then
	List.rev list
      else
	loop (i+1) string ((int_of_char (string.[i]))::list)
  in loop 0 string []
       
let differential_chain chain =
  let rec loop res chain =
    match chain with
	[] -> failwith "Should not happen"
      | head::[] -> List.rev res
      | head::tail -> loop (((List.hd tail) - head)::res) tail 
  in
    loop [] chain
      
let init afile aresearch = 
  let () = pos := 0 in
  let () = ic := open_in_bin afile in
  let () = file := afile in
  (*let ()= Printf.printf "%s :: %s\n%!" file research in*)
  let () = research := aresearch in
  let () = chain := differential_chain (research_to_chain aresearch) in
  (*let () = Printf.printf "to_chain: %s\n%!" (List.fold_left (fun acc i -> Printf.sprintf "%s %i" acc i) "" (research_to_chain research)) in
  let () = Printf.printf "to_diff_chain: %s\n%!" (List.fold_left (fun acc i -> Printf.sprintf "%s %i" acc i) "" (differential_chain (research_to_chain research))) in*)
      ()
   
let search_byte_with_todos (todos : (int * int list) list) (diff : int) =
  (*let () = Printf.printf "%s :%i\n%!" (List.fold_left (fun acc (i,is) -> Printf.sprintf "%s (%i, %s)" acc i (List.fold_left (fun acc i -> Printf.sprintf "%s %i" acc i) "" is)) "" todos) diff in*)
  List.fold_left
    (
      fun (final,new_todos) todo -> match todo with
	  i,[] -> (i,diff),new_todos
	| i,value::tail -> 
	    if value = diff then
	      final,(i,tail)::new_todos
	    else
	      final,new_todos
		
    )
    ((-1,-1),[]) todos 
    
let rec search_byte_chain_in_channel (aconfig: config) (chain : int list) (channel : in_channel) =
  let new_byte =
    try
      input_byte channel
    with
	End_of_file -> -1
    in
  let () = pos := (pos_in channel) -1 in
    if new_byte > -1 then
      if aconfig.previous_byte = -1 then
	let () = config := {previous_byte=new_byte; to_do_list=[]} in
	  search_byte_chain_in_channel !config chain channel
      else
	let new_todo = (!pos-1),chain in
	let new_res,todos = search_byte_with_todos (new_todo::aconfig.to_do_list) (new_byte - aconfig.previous_byte) in
	let  () = config := {previous_byte=new_byte; to_do_list=todos} in
	  if new_res = (-1,-1) then
	    search_byte_chain_in_channel !config chain channel
	  else
	    let () = match new_res with x,y -> Printf.printf "%i %i\n%!" x y in 
	    new_res
    else
      raise Results_not_found

let search () = search_byte_chain_in_channel !config !chain !ic
