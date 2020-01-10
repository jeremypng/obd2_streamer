defmodule Serial do

  @server Serial.Server

  ####
  #Contains external API

  def start_link(port) do
    GenServer.start_link(@server, port, name: __MODULE__)
  end

  def send_raw(command) do
    GenServer.call(__MODULE__, {:raw_command, command})
  end

  def get_vin do
    GenServer.call(__MODULE__, {:get_vin})
  end

end
