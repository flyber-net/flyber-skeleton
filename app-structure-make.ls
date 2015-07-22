const recursive = 
  require \recursive-readdir
const fs = 
  require \fs
const p =
  require \prelude-ls

const only-important-types = (path)->
  | path.match("c9") => no
  | path.match("node_modules") => no
  | path.match(\sass$) => yes
  | path.match(\jade$) => yes
  | path.match(\ls$) => yes
  | _ => no
  
  

recursive \., (err, files)->
  fs.write-file do 
    * \./.compiled/app-structure.json
    * files |> p.filter only-important-types |> JSON.stringify
    