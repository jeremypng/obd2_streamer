defmodule Obd2Streamer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    mqtt_server = Application.fetch_env!(:obd2_streamer, :mqtt_server)
    serial_port = Application.fetch_env!(:obd2_streamer, :serial_port)
    Logger.info("env => mqtt_server=#{mqtt_server}, serial_port=#{serial_port}")

    mqtt_opts = [
      {:client_id, "obd2"},
      {:server, {Tortoise.Transport.Tcp, host: mqtt_server, port: 1883}},
      {:subscriptions, [
        {"obd2/command_requests",2}
        # {"obd2/updates/timed",0},
        # {"obd2/updates/threshold",1}
      ]},
      {:handler, {OBD2.MQTT.Handler, []}}
    ]
    children = [
      # Starts a worker by calling: Obd2Streamer.Worker.start_link(arg)
      # {Obd2Streamer.Worker, arg}
      {Serial.Server,serial_port},
      {Tortoise.Connection,mqtt_opts}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Obd2Streamer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
