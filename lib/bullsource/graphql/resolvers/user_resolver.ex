defmodule Bullsource.GraphQL.UserResolver do
  alias Bullsource.{Repo, Accounts.User, Accounts}

#########SESSIONS############
# authenticated. returns the User to the client if they're signed in to access public features.
  def resolve_user(_args, %{context: %{current_user: current_user}}) do
    {:ok, Accounts.find(current_user.id)}
  end

# unauthenticated. returns nil to the client for users who are not signed in, but want to access public features.
  def resolve_user(_args, _context), do: {:ok, nil}


# a user wants to register - send back the token
  def register(args, _info) do
    with {:ok, user} <- Accounts.create_user(args),
         {:ok, token, full_claims} <- create_token(user)
    do
      {:ok, token.token}
    else
      #error will be either registration changeset or token error
      {:error, %{token_error: error_message } = token_error} ->
        {:error, %{message: error_message}}
      {:error, changeset_error} ->
        {:error, changeset_error}
    end
  end


#######SESSIONS###########
# passwords match, create a token:
  defp create_token(user) do
    case Guardian.encode_and_sign(user, :token) do
      nil -> {:error, %{token_error: "An error occured creating the token"}}
      {:ok, token, full_claims} -> {:ok, %{token: token}}
    end
  end

end