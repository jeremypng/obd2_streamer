defmodule Serial.Server do

  require Logger

  use GenServer
  alias Serial.Impl

  ####
  # API for Supervisor only
  def start_link(port) do
    GenServer.start_link(Serial.Server, port, name: Serial)
  end

  ####
  # Contains Server

  def init(port) do
    {:ok, uart_pid} = Impl.init(port)
    # %{pid: uart_pid} = send(self(), :init)
    {:ok, %{:port => port, :uart_pid => uart_pid}}
  end

  def handle_call({:raw_command, cmd}, _from, state) do
    %{uart_pid: uart_pid} = state
    reply = Impl.raw_command(uart_pid, cmd)
    {:reply, reply, state}
  end

  def handle_call(:get_vin, _from, state) do
    %{uart_pid: uart_pid} = state
    reply = Impl.get_vin(uart_pid)
    {:reply, reply, state}
  end

  def handle_call(:redetect_vehicle, _from, state) do
    %{uart_pid: uart_pid} = state
    reply = Impl.redetect_vehicle(uart_pid)
    {:reply, reply, state}
  end

  def handle_call({:command, cmd}, _from, state) do
    %{uart_pid: uart_pid} = state
    reply = Impl.command(uart_pid, cmd)
    {:reply, reply, state}
  end

  def handle_call({:get_parameter, param}, _from, state) do
    %{uart_pid: uart_pid} = state
    reply = Impl.get_parameter(uart_pid, param)
    {:reply, reply, state}
  end

  def handle_call({:set_param_update_mode, update_type, param, settings, tvalue}, _from, state) do
    %{uart_pid: uart_pid} = state
    reply = Impl.set_update_mode(uart_pid, update_type, param, settings, tvalue)
    {:reply, reply, state}
  end

  #Error Response
  def handle_info({:circuits_uart, _port, <<1, 2, 255, error::binary-size(1), 0, _cs::binary-size(1)>>}, state) do
    errorMsg = Impl.decode_error(error)
    #send to MQTT command channel when ready
    Logger.info("ErrorMsg: #{errorMsg}")
    Tortoise.publish("obd2", "obd2/commands", errorMsg)
    #IO.inspect(state, label: "ErrorState")
    {:noreply, state}
  end

  #Generic Response
  def handle_info({:circuits_uart, _port, message}, state) do
    Logger.info("InfoMsg: #{message}")
    #IO.inspect(state, label: "InfoState")
    message_reply = Impl.decode_info_generic(message)
    Logger.info("Info Response: #{message_reply}")
    %{msg_map: message_map, category: _category, mqtt_topic: topic} = (message_reply)
    Tortoise.publish("obd2", topic, Jason.encode!(message_map))
    {:noreply, state}
  end

end
