defmodule Bullsource.GraphQL.UserResolver do
  alias Bullsource.{Repo, Accounts, Session, Accounts.User, }

  def list(_args,_context) do
    {:ok, Repo.all(User)}
  end

#########SESSIONS############
# authenticated. returns the User to the client if they're signed in to access public features.
  def resolve_user(_args, %{context: %{current_user: current_user}}) do
    {:ok, Accounts.find(current_user.id)}
  end

# unauthenticated. returns nil to the client for users who are not signed in, but want to access public features.
  def resolve_user(_args, _context), do: {:ok, nil}

  def login(args, _context) do
    with {:ok, user}  <- Accounts.authenticate(args),
         {:ok, token} <- create_token(user)
    do
      {:ok, %{token: token}}
    else
       #error will be either registration changeset or token error
       {:error, error } -> {:error, error_handler(error)}
    end
  end

# a user wants to register - send back the token
  def register(args, _info) do
    with {:ok, user} <- Accounts.create_user(args),
         {:ok, token} <- create_token(user)
    do
      {:ok, %{token: token}}
    else
      #error will be either registration changeset or token error
      {:error, error } -> {:error, error_handler(error)}
    end
  end

#######SESSIONS###########
# passwords match, create a token:
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