defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  plug :check_topic_owner when action in [:edit, :delete, :update]

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
    changeset =
      conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

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

  def update(conn, %{"id" => id, "topic" => topic}) do
    old_topic = Repo.get(Topic, id)
    changeset =
      old_topic
      |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "The topic was successfully updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, err_changeset} ->
        render conn, "edit.html", changeset: err_changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Topic, id)
    |> Repo.delete!

    conn
    |> put_flash(:info, "Topic deleted")
    |> redirect(to: topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do

    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: topic_path(conn, :index))
      |> halt
    end
  end
end
