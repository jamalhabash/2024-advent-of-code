with import <nixpkgs> { };
let

  mul_regex = "(mul[(][0-9]{1,3},[0-9]{1,3}[)])";
  do_regex = "(do[(][)])";
  dont_regex = "(don[']t[(][)])";
  do_dont_regex = do_regex + "|" dont_regex;
  parse_do = x: builtins.split "(do[(][)])|(don[']t[(][)])" x;
  match_mul = x: builtins.match "(mul[(][0-9]{1,3},[0-9]{1,3}[)])" x;

  input = lib.fileContents ./input2;

  parser1 = x: builtins.split "(mul[(][0-9]{1,3},[0-9]{1,3}[)])" x;

  result = lib.forEach (parser1 input) (x: if (lib.isString x) then parse_do x else x);

  remove_strings = x: lib.forEach x (x: if (lib.isString x) then null else x);
  result2 = remove_strings result;
  remove = lib.forEach result2 (
    x: lib.forEach x (a: if (lib.isString a && (match_mul a) == null) then null else a)
  );
  remove2 = lib.remove null (lib.flatten remove);
  remove3 = lib.forEach remove2 (
    x: if (match_mul x) == null then x else builtins.split "([0-9]{1,3},[0-9]{1,3})" x
  );

in
# parser =
#   line:
#   let
#     # numbers = builtins.match "/mul\([1-9]{1,3},[1-9]{1,3}\)/" line;
#     # numbers = builtins.match "mul" line;
#     # numbers = builtins.match "/.*mul\([1-9]{1,3},[1-9]{1,3}\)*./" line;
#     # numbers = builtins.match "mul" line;
#     numbers = x: builtins.match "[0-9]{1,3},[0-9]{1,3}" x;
#     parsed_line = lib.splitString "mul(" line;
#     parsed_line2 = lib.forEach parsed_line (x: lib.splitString ")" x);
#     parsed_line3 = lib.forEach parsed_line2 (x: lib.elemAt x 0);
#     parsed_line4 = lib.forEach parsed_line3 (x: if ((numbers x) != null) then x else 0);
#     parsed_line5 = lib.remove 0 parsed_line4;
#     parsed_line6 = lib.forEach parsed_line5 (x: lib.forEach (lib.splitString "," x) (y: lib.toInt y));
#     parsed_line7 = lib.forEach parsed_line6 (x: lib.foldl (a: b: a * b) 1 x);
#     parsed_line8 = lib.foldl (a: b: a + b) 0 parsed_line7;
#   in
#   parsed_line8;
#
# parsed_input = map parser input;
# result = lib.foldl (a: b: a + b) 0 parsed_input;
{
  # inherit parsed_input;
  inherit remove3;
  #test = number "mul(3,4)";
  #test2 = number "5";
}
