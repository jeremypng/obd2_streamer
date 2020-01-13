defmodule Obd2Streamer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    mqtt_opts = [
      {:client_id, "obd2"},
      {:server, {Tortoise.Transport.Tcp, host: '10.4.200.3', port: 1883}},
      {:subscriptions, [
        {"obd2/commands",2},
        {"obd2/updates/timed",0},
        {"obd2/updates/threshold",1}
      ]},
      {:handler, {Tortoise.Handler.Logger, []}}
    ]
    children = [
      # Starts a worker by calling: Obd2Streamer.Worker.start_link(arg)
      # {Obd2Streamer.Worker, arg}
      {Serial.Server,"cu.usbserial"},
      {Tortoise.Connection,mqtt_opts}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Obd2Streamer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
