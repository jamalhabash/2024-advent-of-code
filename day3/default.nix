with import <nixpkgs> { };
let

  #inputs
  input = lib.fileContents ./input;

  #regex
  number_pair_regex = "([0-9]{1,3},[0-9]{1,3})";
  mul_regex = "(mul[(][0-9]{1,3},[0-9]{1,3}[)])";
  do_regex = "(do[(][)])";
  dont_regex = "(don[']t[(][)])";
  do_dont_regex = do_regex + "|" + dont_regex;

  #split and match functions
  split_do_dont = x: builtins.split do_dont_regex x;
  split_mul = x: builtins.split mul_regex x;
  match_mul = x: builtins.match mul_regex x;
  match_do_dont = x: builtins.match do_dont_regex x;

  process_mul =
    x:
    let
      component_list = lib.flatten (builtins.split "([0-9]{1,3})" x);
      first_number = lib.toInt (lib.elemAt component_list 1);
      second_number = lib.toInt (lib.elemAt component_list 3);
      output = first_number * second_number;
    in
    output;

  list_with_extracted_mul_do_dont = lib.remove null (
    #last step, remove all the nulls and you're left with the muls, dos and donts
    lib.flatten (
      #flatten all the sublists that have been created
      lib.forEach (split_mul input) (
        #this for each is operating on a list with the muls already pulled out. This code block is to extract the dos and donts
        x:
        if (lib.isString x) then
          let
            split_list = split_do_dont x;
            extracted_do_dont = if builtins.length split_list > 1 then lib.elemAt split_list 1 else null;
          in
          extracted_do_dont
        else
          x
      )
    )
  );

  result_part_one = lib.foldl (a: b: if builtins.isInt b then a + b else a + 0) 0 (
    lib.forEach list_with_extracted_mul_do_dont (
      x: if (builtins.match mul_regex x != null) then process_mul x else x
    )
  );

  # if it's an integer, check if the current command is do and add to the sum, else return the previous result
  # if it's not an integer, replace the current command with this new one

  result_part_two =
    lib.foldl
      (
        a: b:
        if builtins.isInt b then
          if a.command == "do()" then
            {
              command = a.command;
              sum = a.sum + b;
            }
          else
            a
        else
          {
            command = b;
            sum = a.sum;
          }

      )
      {
        #initial conditions
        command = "do()";
        sum = 0;
      }
      (
        lib.forEach list_with_extracted_mul_do_dont (
          x: if (builtins.match mul_regex x != null) then process_mul x else x
        )
      );

in
{
  inherit result_part_one;
  inherit result_part_two;
}
