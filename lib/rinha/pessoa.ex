defmodule Rinha.Pessoa do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query
  import Ex.Ecto.Changeset

  @typedoc false
  @type t :: %Rinha.Pessoa{
          id: Ecto.UUID.t(),
          nome: String.t(),
          apelido: String.t(),
          data_nascimento: Date.t(),
          stack: [String.t(), ...] | nil
        }

  @primary_key false
  @derive {Jason.Encoder, only: [:id, :nome, :apelido, :data_nascimento, :stack]}
  schema "pessoas" do
    field :id, Ecto.UUID, autogenerate: true, primary_key: true
    field :nome, :string
    field :apelido, :string
    field :data_nascimento, :date
    field :stack, {:array, :string}
  end

  @required_error_msg "campo obrigatório"
  @dup_nick_error_msg "já existe uma pessoa com esse apelido"
  @alphabet_error_msg "apenas letras e espaços são permitidos"
  @min_char_error_msg "deve conter no mínimo %{count} caracteres"
  @max_char_error_msg "deve conter no máximo %{count} caracteres"

  @doc """
  Returna um `Ecto.Changeset` com as alterações feitas em um model
  `Rinha.Pessoa`.
  """
  @spec changeset(t(), map) :: Ecto.Changeset.t()

  def changeset(pessoa, params \\ %{}) do
    pessoa
    |> cast(params, [:nome, :apelido, :data_nascimento, :stack])
    |> validate_required([:nome, :apelido, :data_nascimento], message: @required_error_msg)
    |> validate_length(:nome, min: 3, message: @min_char_error_msg)
    |> validate_length(:nome, max: 75, message: @max_char_error_msg)
    |> validate_format(:nome, ~r/^[a-zA-Z\s]+$/, message: @alphabet_error_msg)
    |> validate_length(:apelido, max: 32, message: @max_char_error_msg)
    |> unique_constraint(:apelido, message: @dup_nick_error_msg)
    |> validate_each(:stack, validate_length(max: 10, message: @max_char_error_msg))
  end

  @doc """
  Query builder para o model `Rinha.Pessoa`.
  """
  @spec query([{atom, term}, ...]) :: Ecto.Queryable.t()
  def query([_ | _] = filters), do: query(__MODULE__, filters)

  defp query(query, []), do: query
  defp query(query, [{:id, id} | tail]), do: where(query, [p], p.id == ^id) |> query(tail)
end