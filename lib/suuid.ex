defmodule SUUID do
  @moduledoc """
  Sortable UUID.
  """

  use Ecto.Type

  import Bigflake, only: [mint: 0]
  import String, only: [pad_leading: 3]

  @typedoc """
  String representation of a sortable UUID.
  """
  @type t :: <<_::256>>

  @doc """
  Generates a new sortable UUID.
  """
  @spec generate() :: t
  def generate do
    {:ok, id} = mint()

    to_string(id)
    |> pad_leading(32, "0")
  end

  @doc false
  @impl Ecto.Type
  def type, do: :string

  @doc false
  @impl Ecto.Type
  def cast(<<_::256>> = value), do: {:ok, value}
  def cast(_), do: :error

  @doc false
  @impl Ecto.Type
  def dump(<<_::256>> = value), do: {:ok, value}
  def dump(_), do: :error

  @doc false
  @impl Ecto.Type
  def load(<<_::256>> = value), do: {:ok, value}
  def load(_), do: :error

  @doc false
  @impl Ecto.Type
  defdelegate autogenerate, to: __MODULE__, as: :generate
end