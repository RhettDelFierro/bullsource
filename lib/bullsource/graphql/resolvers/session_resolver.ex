defmodule Bullsource.GraphQL.SessionResolver do
  alias Bullsource.{Repo, Accounts.User}

# authenticated. returns the User to the client if they're signed in to access public features.
  def resolve_user(_args, %{context: %{current_user: curent_user}}) do
    {:ok, User.find(current_user.id)}
  end

# unauthenticated. returns nil to the client for users who are not signed in, but want to access public features.
  def resolve_user(_args, _context), do: {:ok, nil}

# a user wants to register
  def create(args, _info) do
    user = Repo.get_by(User, email: args[:email])

    case authenticate(user, args[:password]) do # password is the password field the user has entered into graphql.
      true -> create_token(user)
      _ -> {:error, "User could not be authenticated"}
    end
  end

# verify the password the user has entered matches with the encrypted password stored on the db:
  defp authenticate(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
    end
  end

# passwords match, create a token:
  defp create_token(user) do
    case Guardian.encode_and_sign(user, :token) do
      nil -> {:error, "An error occured creating the token"}
      {:ok, token, full_claims} -> {ok, %{token: token}}
    end
  end

end