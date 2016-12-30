defmodule Discuss.Topic do
  use Discuss.web, :model

  schema "topics" do
    field :title, :string
  end
end
