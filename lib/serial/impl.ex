defmodule Serial.Impl do

  ####
  # Contains logic implementation

  def init(port) do
    {:ok, pid} = Circuits.UART.start_link()
    Circuits.UART.open(pid, port, speed: 115200, active: false)
    {:ok, pid}
  end

  def raw_command(pid, command) do
    # %{uart_pid: pid} = state
    # %{cmd: command} = state
    Circuits.UART.write(pid, command)
    Circuits.UART.read(pid,2000)
  end
end
