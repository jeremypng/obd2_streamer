defmodule Serial.Server do

  use GenServer
  alias Serial.Impl

  ####
  # API for Supervisor only
  def start_link([port, %{name: name}]) do
    GenServer.start_link(Serial.Server, port, name)
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

  #Error Response
  def handle_info({:circuits_uart, _port, <<1, 2, 255, error::binary-size(1), 0, _cs::binary-size(1)>>}, state) do
    errorMsg = Impl.decode_error(error)
    #send to MQTT command channel when ready
    IO.inspect(errorMsg)
    IO.inspect(state)
    {:noreply, state}
  end

  #Generic Response
  def handle_info(message, state) do
    IO.inspect(message)
    IO.inspect(state)
    {:noreply, state}
  end

end
