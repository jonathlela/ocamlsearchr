module RelativeSearch =
struct

  exception Results_not_found

  type todo = {
    start: int;
    nexts: int list;
    res: int list;
  }
      
  let empty_todo = {
    start = -1;
    nexts = [];
    res = [];
  }

  type config = {
    previous_byte: int;
    to_do_list: todo list;
  }
      
  let start_config = {
    previous_byte = -1;
    to_do_list = [];
  }
    
  type t = {
    config: config ref;
    position: int ref;
    input_channel: in_channel ref;
    file: string ref;
    research: string ref;
    chain: int list ref;
  }

  let empty = {
    config = ref start_config;
    position = ref 0;
    input_channel = ref stdin;
    file = ref "";
    research = ref "";
    chain = ref [];
  }

  let get_pos t = !(t.position)

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
	| [] -> failwith "Should not happen"
	| head::[] -> List.rev res
	| head::tail -> loop (((List.hd tail) - head)::res) tail 
    in
      loop [] chain
      
  let init afile aresearch =
    let pos = ref 0 in
    let ic = ref (open_in_bin afile) in
    let file = ref afile in
    let research = ref aresearch in
    let chain = ref (differential_chain (research_to_chain aresearch)) in
    let config = ref start_config in
      {position=pos;input_channel=ic;file=file;research=research;chain=chain;config=config}
      (*let ()= Printf.printf "%s :: %s\n%!" file research in*)
      (*let () = Printf.printf "to_chain: %s\n%!" (List.fold_left (fun acc i -> Printf.sprintf "%s %i" acc i) "" (research_to_chain research)) in
	let () = Printf.printf "to_diff_chain: %s\n%!" (List.fold_left (fun acc i -> Printf.sprintf "%s %i" acc i) "" (differential_chain (research_to_chain research))) in*)

  let reset t =
    let () = t.position := 0 in
    let () = seek_in !(t.input_channel) 0 in
      ()
      
  let close t =
    close_in !(t.input_channel)
   
  let search_byte_with_todos (todos : todo list) (diff : int) (current_byte : int) =
    (*let () = Printf.printf "%s :%i\n%!" (List.fold_left (fun acc (i,is) -> Printf.sprintf "%s (%i, %s)" acc i (List.fold_left (fun acc i -> Printf.sprintf "%s %i" acc i) "" is)) "" todos) diff in*)
    List.fold_left
      (
	fun (final,new_todos) todo -> 
	  match todo with
	    |  {start=i;nexts=[];res=res} -> failwith "Should not happen"
	    |  {start=i;nexts=value::[];res=res} -> 
		 if value = diff then
		   {start=i;nexts=[];res=current_byte::res},new_todos
		 else
		   final,new_todos
	    | {start=i;nexts=value::tail;res=res} -> 
		if value = diff then
		  final,{start=i;nexts=tail;res=current_byte::res}::new_todos
		else
		  final,new_todos
      )
      (empty_todo,[]) todos 
      
  let rec search_byte_chain_in_channel t =
    let new_byte =
      try
	input_byte !(t.input_channel)
      with
	  End_of_file -> -1
    in
    let () = t.position := (pos_in !(t.input_channel)) -1 in
      if new_byte > -1 then
	if !(t.config).previous_byte = -1 then
	  let () = t.config := {previous_byte=new_byte; to_do_list=[]} in
	    search_byte_chain_in_channel t
	else
	  let new_todo = {start=(!(t.position)-1);nexts=(!(t.chain));res=[]} in
	  let new_res,todos = search_byte_with_todos (new_todo::!(t.config).to_do_list) (new_byte - !(t.config).previous_byte) new_byte in
	  let  () = t.config := {previous_byte=new_byte; to_do_list=todos} in
	    if new_res = empty_todo then
	      search_byte_chain_in_channel t
	    else
	      (new_res.start,(Array.of_list (List.rev new_res.res)))
      else
	raise Results_not_found

  let search t = search_byte_chain_in_channel t

end
