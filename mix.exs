defmodule Midi.MixProject do
  use Mix.Project

  def project do
    [
      app: :midi,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      application: [:portmidi],
      extra_applications: [:logger],
      mod: {Midi.Application, []},
      env: [ppqn: 96]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      {:ex_ncurses, "~> 0.3"},
      {:portmidi, "~> 5.0"},
      {:uuid, "~> 1.1"}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
