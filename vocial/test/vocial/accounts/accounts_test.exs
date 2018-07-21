defmodule Vocial.AccountsTest do
    use Vocial.DataCase

    alias Vocial.Accounts

    describe "users" do
        @valid_attrs %{username: "username", email: "email", active: true, encrypted_password: "password"}

        def user_fixture(attrs \\ %{}) do
            with create_attrs <- Map.merge(attrs, @valid_attrs),
                 {:ok, user} <- Accounts.create_user(create_attrs)
                 do
                     user
                 end
        end

        test "list_users/0 returns all users" do
            user = user_fixture()
            assert Accounts.list_users() == [user]
        end

        test "get_user/1 returns user by id" do
            user = user_fixture()
            assert Accounts.get_user(user.id) == user
        end

        test "new_user/0 returns a blank changeset" do
            changeset = Accounts.new_user()
            assert changeset.__struct__ == Ecto.Changeset
        end

        test "create_user/2 creates the user in the db and returns it" do
            before = Accounts.list_users()
            user = user_fixture()
            updated = Accounts.list_users()
            assert !Enum.any?(before, fn u -> user == u end)
            assert Enum.any?(updated, fn u -> user == u end)
        end
    end
    
end