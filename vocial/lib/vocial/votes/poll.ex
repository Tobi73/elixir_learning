defmodule Vocial.Votes.Poll do
    use Ecto.Schema
    import Ecto.Changeset
    alias Vocial.Votes.Poll
    alias Vocial.Votes.Option
    alias Vocial.Accounts.User
    alias Vocial.Votes.Image
    alias Vocial.Votes.VoteRecord

    schema "polls" do
        field :title, :string
        has_many :options, Option
        belongs_to :user, User
        has_one :image, Image
        has_many :vote_records, VoteRecord
        timestamps()
    end

    def changeset(%Poll{} = poll, attrs) do
        poll
        |> cast(attrs, [:title, :user_id])
        |> validate_required([:title, :user_id])
    end
end