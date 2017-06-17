defmodule Bullsource.GraphQL.UserResolver do
  alias Bullsource.{Repo, Accounts, Session, Accounts.User}
  import Bullsource.Accounts, only: [authenticate: 1, create_user: 1, find: 1]

  def list(_args,_context), do: {:ok, Repo.all(User)} #change this to the accounts interface rather than calling repo.



  def get_current_user(_args, %{context: %{current_user: current_user}}), do: find(%{id: current_user.id})
  def get_current_user(_args, _context), do: {:ok, nil}


  def login_user(args, _context), do: generate_session(&authenticate/1,args)

  def register(args, _context),   do: generate_session(&create_user/1,args)


  defp generate_session(func, args) do
    with {:ok, user}  <- func.(args),
         {:ok, token} <- create_token(user)
    do
      {:ok, %{token: token,user: user}}
    else
       #error will be either registration changeset or token error
       {:error, error } -> {:error, error_handler(error)}
    end
  end

  defp create_token(user) do
    case Guardian.encode_and_sign(user, :token) do
      nil -> {:error, %{token_error: "An error occured creating the token"}}
      {:ok, token, full_claims} -> {:ok, token}
    end
  end



  defp error_handler(%{token_error: error_message} = token_error), do: %{message: error_message}
  defp error_handler(%{message: error_message} = token_error),     do: %{message: error_message}
  defp error_handler(changeset_error), do: changeset_error

end