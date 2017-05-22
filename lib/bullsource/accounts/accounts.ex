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