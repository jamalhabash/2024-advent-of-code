with import <nixpkgs> { };
let
  input = lib.strings.splitString "\n" (lib.fileContents ./input);

  parser =
    element: line:
    let
      numbers = lib.splitString " " line;
    in
    lib.toInt (lib.elemAt numbers element);

  abs = x: if x < 0 then -x else x;

in

rec {
  parsed_left = map (parser 0) input;
  parsed_right = map (parser 3) input;
  sorted_parsed_left = lib.lists.sort (a: b: a < b) parsed_left;
  sorted_parsed_right = lib.lists.sort (a: b: a < b) parsed_right;
  distances_list = map abs (
    lib.lists.zipListsWith (a: b: a - b) sorted_parsed_left sorted_parsed_right
  );
  #  test = map abs new_list;
  result = lib.lists.foldl (a: b: a + b) 0 distances_list;
  similarity0 = lib.lists.forEach sorted_parsed_right (
    b: lib.lists.count (a: a == b) sorted_parsed_left
  );
  similarity1 = lib.lists.zipListsWith (a: b: a * b) sorted_parsed_right similarity0;
  result2 = lib.lists.foldl (a: b: a + b) 0 similarity1;
}
