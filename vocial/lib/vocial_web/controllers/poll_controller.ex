defmodule VocialWeb.PollController do
    use VocialWeb, :controller
    alias Vocial.Votes
    plug VocialWeb.VerifyUserSession when action in [:new, :create]

    require IEx

    def index(conn, _params) do

        polls = Votes.list_polls()

        render(conn, "index.html", polls: polls)
    end

    def new(conn, _params) do
        poll = Votes.new_poll()
        render(conn, "new.html", poll: poll)
    end

    def create(conn, %{"poll" => poll_options, "options" => options, "image_data" => image_data}) do
        split_options = String.split(options, ",")
        with user when not is_nil(user) <- get_session(conn, :user),
            poll_options <- Map.put(poll_options, "user_id", user.id),
            {:ok, _poll} <- Votes.create_poll_with_options(poll_options, split_options, image_data) do
            conn
            |> put_flash(:info, "Poll created successfully")
            |> redirect(to: poll_path(conn, :index))
        else
            {:error, poll} ->
                conn
                |> put_flash(:error, "Error creating poll")
                |> redirect(to: poll_path(conn, :new))
        end
    end

    def create(conn, %{"poll" => _poll_options, "options" => options} = params) do
        create(conn, Map.put(params, "image_data", nil))
    end

    def vote(conn, %{"id" => id}) do
        voter_ip = conn.remote_ip
        |> Tuple.to_list()
        |> Enum.join(".")
        with {:ok, option} <- Votes.vote_on_option(id, voter_ip) do
            conn
            |> put_flash(:info, "Placed a vote for #{option.title}")
            |> redirect(to: poll_path(conn, :index))
        else
            _ ->
            conn
            |> put_flash(:error, "Could not vote!")
            |> redirect(to: poll_path(conn, :index))
        end
    end

    def show(conn, %{"id" => id}) do
        with poll <- Votes.get_poll(id) do
            render(conn, "show.html", %{poll: poll})
        end
    end


end