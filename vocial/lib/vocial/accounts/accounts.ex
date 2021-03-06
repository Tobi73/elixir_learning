defmodule Vocial.Accounts do
    import Ecto.Query, warn: false

    alias Vocial.Repo
    alias Vocial.Accounts.User

    def list_users() do
        Repo.all(User)
    end

    def new_user, do: User.changeset(%User{}, %{})

    def create_user(attrs \\ %{}) do
        %User{}
        |> User.changeset(attrs)
        |> Repo.insert()
    end

    def get_user(id) do
        Repo.get(User, id)
    end

    def get_user_by_username(username) do
        Repo.get_by(User, username: username)
    end
end