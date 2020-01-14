defmodule Obd2Streamer.MixProject do
  use Mix.Project

  def project do
    [
      app: :obd2_streamer,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        obd2_streamer: [
          version: "0.1.0",
          applications: [obd2_streamer: :permanent]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      env: [mqtt_server: "10.4.200.4",serial_port: "cu.usbserial"],
      mod: {Obd2Streamer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_uart, "~> 1.3"},
      {:tortoise, "~> 0.9"},
      {:jason, "~> 1.1"},
      {:observer_cli, "~> 1.5"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
