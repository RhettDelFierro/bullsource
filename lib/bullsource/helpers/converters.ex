defmodule Bullsource.Helpers.Converters do

  def str_to_atom_keys(map) do

    for {key, val} <- map, into: %{} do
      cond do
        is_atom(key) -> #for keys that are already atoms
          cond do
            is_map(val)  -> {key, str_to_atom_keys(val)} #recursion
            is_list(val) -> list_converter_str_to_atom(val)
            true -> {key, val}
          end

        true -> #for keys that are not atoms

          cond do
            is_map(val) -> {String.to_atom(key), str_to_atom_keys(val)}
            is_list(val) ->{String.to_atom(key), list_converter_str_to_atom(val)}
            true -> {String.to_atom(key), val}
          end

      end
    end
  end

  @doc """
      Edits atom names:

      ## EXAMPLE:
          iex(1)> map1 = %{blaa: %{blaa: "blah"}}
          %{blaa: %{blaa: "blah"}}
          iex(2)> map2 = Bullsource.Helpers.Converters.change_map_keys(map1,"blaa","blah")
          %{blah: %{blah: "blah"}}
  """
  def change_map_keys(map,substring,replace) do
    for {key, val} <- map, into: %{} do
      cond do
        is_map(val) ->
          {Atom.to_string(key) |> String.replace(substring,replace) |> String.to_atom(),
            change_map_keys(val, substring, replace)}
        is_list(val) ->
          {Atom.to_string(key) |> String.replace(substring,replace) |> String.to_atom(),
            list_converter_replace_key_names(val, substring, replace)}
        true ->
          {Atom.to_string(key) |> String.replace(substring, replace) |> String.to_atom(), val}
      end
    end
  end

  def map_keys_to_lowercase(map) do
    for {key, val} <- map, into: %{} do
      cond do
        is_map(val) ->
          {Atom.to_string(key) |> String.downcase |> String.to_atom(),
            map_keys_to_lowercase(val)}
        is_list(val) ->
          {Atom.to_string(key) |> String.downcase |> String.to_atom(),
            list_converter_lowercase(val)}
        true ->
          {Atom.to_string(key) |> String.downcase |> String.to_atom(), val}
      end
    end
  end

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


  #changes atoms
  defp list_converter_str_to_atom(list) do
    Enum.map(list, fn v ->
      if is_map(v) do
        str_to_atom_keys(v)
      else
        v
      end
    end)
  end

  defp list_converter_replace_key_names(list,substring,replace) do
    Enum.map(list, fn v ->
      if is_map(v) do
        change_map_keys(v, substring, replace)
      else
        v
      end
    end)

  end

  defp list_converter_lowercase(list) do
    Enum.map(list, fn v ->
      if is_map(v) do
        map_keys_to_lowercase(v)
      else
        v
      end
    end)

  end


end