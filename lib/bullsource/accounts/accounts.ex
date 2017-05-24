defmodule Bullsource.Accounts do
#users interface functions
  import Ecto.Changeset
  alias Bullsource.Accounts.User
  alias Bullsource.Repo

  def find(%{id: id}, _context)do
    case Repo.get(User, id) do
      nil -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def authenticate(%{username: username,password: given_password}) do
  	user = Repo.get_by(User, username: username)
  	#should also check for email, either one will work?

  	check_password(user, given_password)
  end

  defp check_password(nil, _given_password) do
    {:error, %{message: "No user with this username was found!"}}
  end

  defp check_password(%{encrypted_password: encrypted_password} = user, given_password) do
    case Comeonin.Bcrypt.checkpw(given_password, encrypted_password) do
      true -> {:ok, user}
      _    -> {:error, %{message: "Incorrect password"}}
    end
  end


  def create_user(%{password: password} = params) do

    # Encrypt the password with Comeonin:
    encrypted_password = Comeonin.Bcrypt.hashpwsalt(password)

    register_changeset(params)
    |> put_change(:encrypted_password, encrypted_password)
    |> Repo.insert

  end

  #checks for valid inputs to new user fields before it adds to db.
  def register_changeset(params \\ %{}) do
    %User{}
    |> cast(params, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_format(:email, ~r/@/)
    |> validate_format(:username, ~r/^[a-zA-Z0-9]*$/)
    |> validate_length(:password, min: 4)
  end

end