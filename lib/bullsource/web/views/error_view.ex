defmodule Bullsource.Web.ErrorView do
  use Bullsource.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  #usually when we have multiple different errors
  def render("error.json", %{changeset_error: changeset}) do
    IO.puts "error changeset+++++++ in view"
    IO.inspect changeset
    %{
      errors: changeset_errors(changeset.errors)
    }
  end

  #when we know exactly the one thing that went wrong
  def render("error.json", %{message: message}) do
    %{
      errors: %{message: message}
    }
  end

  #creates a map of the errors with each field generated from the changeset errors.
  def changeset_errors(errors) do
    {:error, errors
    |> Enum.map(fn {field, {reason,detail}} ->
         str = Enum.reduce detail, reason, fn {k, v}, acc ->
                 String.replace(acc, "%{#{k}}", to_string(v)) #inject the value into error string
               end
         {field, str}
#         {field, reason}
      end)
    |> Map.new}

  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
