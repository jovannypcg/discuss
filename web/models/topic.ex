defmodule Discuss.Topic do
  use Discuss.web, :model

  schema "topics" do
    field :title, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validated_required([:title])
  end
end
