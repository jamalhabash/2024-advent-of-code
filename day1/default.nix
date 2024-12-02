with import <nixpkgs> { };
let
  input = lib.strings.splitString "\n" (lib.fileContents ./input);

  parser =
    element: line:
    let
      numbers = lib.splitString " " line;
    in
    lib.toInt (lib.elemAt numbers element);

in

rec {
  parsed_left = map (parser 0) input;
  parsed_right = map (parser 3) input;
  sorted_parsed_left = lib.lists.sort (a: b: a<b) parsed_left;
  sorted_parsed_right = lib.lists.sort (a: b: a>b) parsed_right;
}
