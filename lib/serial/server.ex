defmodule Serial.Server do

  use GenServer
  alias Serial.Impl

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

end
