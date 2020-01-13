defmodule OBD2.MQTT.Handler do
  @moduledoc false

  require Logger

  use Tortoise.Handler

  defstruct []
  alias __MODULE__, as: State

  def init(_opts) do
    Logger.info("Initializing handler")
    {:ok, %State{}}
  end

  def connection(:up, state) do
    Logger.info("Connection has been established")
    {:ok, state}
  end

  def connection(:down, state) do
    Logger.warn("Connection has been dropped")
    {:ok, state}
  end

  def connection(:terminating, state) do
    Logger.warn("Connection is terminating")
    {:ok, state}
  end

  def subscription(:up, topic, state) do
    Logger.info("Subscribed to #{topic}")
    {:ok, state}
  end

  def subscription({:warn, [requested: req, accepted: qos]}, topic, state) do
    Logger.warn("Subscribed to #{topic}; requested #{req} but got accepted with QoS #{qos}")
    {:ok, state}
  end

  def subscription({:error, reason}, topic, state) do
    Logger.error("Error subscribing to #{topic}; #{inspect(reason)}")
    {:ok, state}
  end

  def subscription(:down, topic, state) do
    Logger.info("Unsubscribed from #{topic}")
    {:ok, state}
  end

  @defaults %{:param => nil}

  def handle_message(["obd2", "command_requests"], publish, state) do
    IO.inspect("command_request")
    Logger.info("#obd2/command_requests #{inspect(publish)}")
    publish_map = Jason.decode!(publish,[{:keys, :atoms}])
    %{command: cmd, param: param} = merge_defaults(publish_map)
    case cmd do
      "redetect_vehicle" -> Serial.redetect_vehicle
      "get_vin" -> Serial.get_vin
      "get_supported_parameters" -> Serial.command(:get_supported_parameters)
      "get_parameter" -> Serial.get_parameter(String.to_atom(param))
    end
    {:ok, state}
  end

  def handle_message(topic, publish, state) do
    IO.inspect(topic,label: "topic" <> <<0>>)
    IO.inspect("generic_handler")
    Logger.info("#{Enum.join(topic, "/")} #{inspect(publish)}")
    {:ok, state}
  end

  def terminate(reason, _state) do
    Logger.warn("Client has been terminated with reason: #{inspect(reason)}")
    :ok
  end

  defp merge_defaults(map) do
    Map.merge(@defaults, map)
  end
end
