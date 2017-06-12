defmodule Bullsource.Helpers.Converters do

    def str_to_atom_keys(map) do

      for {key, val} <- map, into: %{} do
        # refactor to be a separate function with a guard clause?
        cond do
          is_atom(key) -> #for keys that are already atoms

            cond do
              is_map(val)  -> {key, str_to_atom_keys(val)} #recursion
              is_list(val) -> Enum.map(val,&(str_to_atom_keys(&1)))
              true -> {key, val}
            end

          true -> #for keys that are not atoms

            cond do
              is_map(val) -> {String.to_atom(key), str_to_atom_keys(val)}
#              is_list(val) ->{String.to_atom(key), Enum.map(val,&(str_to_atom_keys(&1)))}
              true -> {String.to_atom(key), val}
            end

        end
      end
    end

#    def str_to_atom_keys(map) do
#
#      for %{key => val} <- map, into: %{} do
#        # refactor to be a separate function with a guard clause?
#        cond do
#          is_atom(key) -> #for keys that are already atoms
#
#            cond do
#              is_map(val) -> {key, str_to_atom_keys(val)} #recursion
#              true -> {key, val}
#            end
#
#          true -> #for keys that are not atoms
#
#            cond do
#              is_map(val) -> {String.to_atom(key), str_to_atom_keys(val)}
#              true -> {String.to_atom(key), val}
#            end
#
#        end
#      end
#    end
#
#
  def atom_to_str_keys(map) do

    for {key, val} <- map, into: %{} do
      cond do
        is_binary(key) -> #for keys that are already strings

          cond do
            is_map(val) -> {key, atom_to_str_keys(val)}
            true -> {key, val}
          end

        true -> #for keys that are not strings

          cond do
            is_map(val) -> {Atom.to_string(key), atom_to_str_keys(val)}
            true -> {Atom.to_string(key), val}
          end

      end
    end
  end


end