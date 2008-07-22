require "librubyocamlsearchr"
searcher = OcamlSearchR.new("Neugier.smc","sword")
res = searcher.search()
p res
res = searcher.search()
p res
