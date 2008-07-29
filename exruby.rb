require "librubyocamlsearchr"
searcher = OcamlSearchR.new("/home/jonathlela/ocamlsearchr/Neugier.smc","sword")
while true do
  begin
    res = searcher.search()
    p res
  rescue Exception => exc
    p exc
    break
  end
end
