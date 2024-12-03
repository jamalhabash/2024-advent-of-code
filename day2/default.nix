with import <nixpkgs> { };
let
  input = lib.strings.splitString "\n" (lib.fileContents ./input);

  parser =
    line:
    let
      numbers = lib.splitString " " line;
    in
    lib.forEach numbers (x: lib.toInt x);

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

  remove_one_element =
    list:
    let
      len = builtins.length list;
      indices = builtins.genList (x: x) len;
      removeAt =
        i: list:
        let
          before = lib.sublist 0 i list;
          after = lib.sublist (i + 1) (len - i - 1) list;
        in
        before ++ after;
    in
    [ list ] ++ map (i: removeAt i list) indices;

  any = list: if list == [ ] then false else (builtins.head list) || (any (builtins.tail list));

  lists_with_removed_elements = lib.forEach parsed_input (x: remove_one_element x);
  checked_lists = lib.forEach lists_with_removed_elements (
    x: lib.forEach x (x: isAscending x || isDescending x)
  );
  z = lib.forEach checked_lists (x: any x);
in
rec {
  inherit result;
  result2 = lib.lists.foldl (a: b: if b then a + 1 else a) 0 z;
}
