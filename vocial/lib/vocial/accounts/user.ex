defmodule Vocial.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Vocial.Accounts.User
  alias Vocial.Votes.Poll
  alias Vocial.Votes.Image

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:active, :boolean, default: true)
    field(:encrypted_password, :string)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)

    has_many(:polls, Poll)
    has_many(:images, Image)

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :active, :password, :password_confirmation])
    |> validate_confirmation(:password, message: "does not match password")
    |> encrypt_password()
    |> validate_required([:username, :email, :active, :encrypted_password])
    |> unique_constraint(:username)
    |> validate_format(:email, ~r/@/)
    |> validate_not_fake([:email, :username])
  end

  defp encrypt_password(changeset) do
    with password when not is_nil(password) <- get_change(changeset, :password) do
      put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
    else
      _ -> changeset
    end
  end

  defp validate_not_fake(changeset, [key | keys]) do
    value = get_change(changeset, key)
    if is_binary(value) and String.match?(value, ~r/fake/) do
      changeset
      |> add_error(key, "cannot be fake")
      |> validate_not_fake(keys)
    else
      changeset
      |> validate_not_fake(keys)
    end
  end

  defp validate_not_fake(changeset, []) do
    changeset
  end
end
