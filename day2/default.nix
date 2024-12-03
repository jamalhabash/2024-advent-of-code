with import <nixpkgs> { };
let
  input = lib.strings.splitString "\n" (lib.fileContents ./input);

  parser =
    line:
    let
      numbers = lib.splitString " " line;
    in
    lib.forEach numbers (x: lib.toInt x);

  # goesUp = list: lib.foldl (a: b: a < b) (builtins.head list) (builtins.tail list);
  # goesUp = list: lib.foldl (a: b: a && (b < b)) true (builtins.tail list);
  # goesUp = list: lib.foldl' (a: b: a && b > a) true (builtins.tail list);

  parsed_input = map parser input;

  checkAscendingPair = a: b: a <= b && (b - a <= 3 && b - a >= 1);
  checkDescendingPair = a: b: a >= b && (a - b <= 3 && a - b >= 1);

  isAscending =
    list:
    if builtins.length list <= 1 then
      true
    else
      let
        first = builtins.head list;
        second = builtins.head (builtins.tail list);
        rest = builtins.tail list;
      in
      if (checkAscendingPair first second) then isAscending rest else false;

  isDescending =
    list:
    if builtins.length list <= 1 then
      true
    else
      let
        first = builtins.head list;
        second = builtins.head (builtins.tail list);
        rest = builtins.tail list;
      in
      if (checkDescendingPair first second) then isDescending rest else false;

  step1 = lib.forEach parsed_input (x: isAscending x || isDescending x);

  result = lib.lists.foldl (a: b: if b then a + 1 else a) 0 step1;

in
rec {
  inherit result;
}
