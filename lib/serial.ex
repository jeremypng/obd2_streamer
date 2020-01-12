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
    GenServer.call(__MODULE__, :get_vin)
  end

  def redetect_vehicle do
    GenServer.call(__MODULE__, :redetect_vehicle)
  end

  def command(command) do
    GenServer.call(__MODULE__, {:command, command})
  end

  def get_parameter(param) do
    GenServer.call(__MODULE__, {:get_parameter, param})
  end

  #param=param_atom, settings= :enabled/:disables, tvalue = ms between updates (min 50ms)
  def set_update_mode(param, settings, tvalue) do
    GenServer.call(__MODULE__, {:set_update_mode, param, settings, tvalue})
  end

end
