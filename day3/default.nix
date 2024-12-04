with import <nixpkgs> { };
let
  input = lib.strings.splitString "\n" (lib.fileContents ./input);
  parser =
    line:
    let
      # numbers = builtins.match "/mul\([1-9]{1,3},[1-9]{1,3}\)/" line;
      # numbers = builtins.match "mul" line;
      # numbers = builtins.match "/.*mul\([1-9]{1,3},[1-9]{1,3}\)*./" line;
      # numbers = builtins.match "mul" line;
      numbers = x: builtins.match "[0-9]{1,3},[0-9]{1,3}" x;
      parsed_line = lib.splitString "mul(" line;
      parsed_line2 = lib.forEach parsed_line (x: lib.splitString ")" x);
      parsed_line3 = lib.forEach parsed_line2 (x: lib.elemAt x 0);
      parsed_line4 = lib.forEach parsed_line3 (x: if ((numbers x) != null) then x else 0);
      parsed_line5 = lib.remove 0 parsed_line4;
      parsed_line6 = lib.forEach parsed_line5 (x: lib.forEach (lib.splitString "," x) (y: lib.toInt y));
      parsed_line7 = lib.forEach parsed_line6 (x: lib.foldl (a: b: a * b) 1 x);
      parsed_line8 = lib.foldl (a: b: a + b) 0 parsed_line7;
    in
    parsed_line8;

  parsed_input = map parser input;
  result = lib.foldl (a: b: a + b) 0 parsed_input;
in
{
  inherit parsed_input;
  inherit result;
}
