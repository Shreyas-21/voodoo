module Pre = Block.Pre
include Ast

type doc = Ast.block list

let parse_inline defs s = Parser.inline defs (Parser.P.of_string s)

let parse_inlines (md, defs) =
  let defs =
    let f (def : link_def) = { def with label = Parser.normalize def.label } in
    List.map f defs
  in
  List.map (Mapper.map (parse_inline defs)) md

let of_channel ic = parse_inlines (Pre.of_channel ic)

let of_string s = parse_inlines (Pre.of_string s)

let to_sexp ast = Format.asprintf "@[%a@]@." Sexp.print (Sexp.create ast)
