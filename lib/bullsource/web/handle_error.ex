defmodule Bullsource.Web.HandleError do
  @behaviour Absinthe.Middleware

# this will short circuit the query/mutation if no current_user is found.
  def call(resolution = %{errors: errors}, _config) do
    case errors do
      [] -> resolution

      %{message: message} -> {:error, %{message: message}}

      [%Ecto.Changeset{}] ->
       errors = Enum.map(resolution.errors, &changeset_errors(&1.errors))
       resolution
       |> Absinthe.Resolution.put_result({:error, %{message: "transaction declined", error_list: errors}})
    end
  end

#  def call(resolution, _config) do
#    IO.puts "########inspecting resolution########"
#    IO.inspect resolution
#    resolution
#  end

  defp changeset_errors(errors) do
    errors
    |> Enum.map(fn {field, {reason,detail}} ->
         str = Enum.reduce detail, reason, fn {k, v}, acc ->
                 String.replace(acc, "%{#{k}}", to_string(v)) #inject the value into error string
               end
         {field, str}
#         {field, reason}
      end)
    |> Map.new

  end

end