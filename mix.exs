defmodule ArgosWorkers.MixProject do
  use Mix.Project

  def project do
    [
      app: :argos_workers,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ArgosWorkers.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.6"},
      {:sweet_xml, "~> 0.6"},
      {:ecto_sql, "~> 3.0"},
      {:joken, "~> 2.2"},
      {:broadway_rabbitmq, "~> 0.6.1"},
      {:amqp, "~> 1.0"},
      {:postgrex, ">= 0.0.0"},
      {:redix, ">= 0.0.0"},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
