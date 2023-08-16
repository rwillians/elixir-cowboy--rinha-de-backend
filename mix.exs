defmodule Rinha.MixProject do
  use Mix.Project

  def project do
    [
      app: :rinha,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [debug_info: Mix.env() == :dev],
      build_embedded: Mix.env() not in [:dev, :test],
      start_permanent: Mix.env() not in [:dev, :test],
      aliases: aliases(),
      deps: deps()
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create --quiet", "ecto.migrate --quiet"]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Rinha.Application, []}
    ]
  end

  defp deps do
    [
      {:bigflake, "~> 0.5.0"},
      {:corsica, "~> 2.1.2"},
      {:ecto_sql, "~> 3.10.1"},
      {:etag_plug, "~> 1.0.0"},
      {:jason, "~> 1.4.1"},
      {:libcluster, "~> 3.3"},
      {:plug, "~> 1.14.2"},
      {:plug_cowboy, "~> 2.6.1"},
      {:postgrex, ">= 0.17.2"},
      {:tapex, github: "rwillians/tapex", ref: "46900d4", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
