defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  def new(conn, params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def index(conn, _params) do
    topics = Repo.all(Topic)

    conn
    |> render("index.html", topics: topics)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Topic created successfully")
        |> redirect(to: topic_path(conn, :index))
      {:error, err_changeset} ->
        render conn, "new.html", changeset: err_changeset
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Repo.get Topic, id
    changeset = Topic.changeset(topic)

    conn
    |> render("edit.html", [changeset: changeset, topic: topic])
  end

  def update(conn, %{"id" => id}) do
    IO.inspect "UPDATING... #{id}"
  end
end
