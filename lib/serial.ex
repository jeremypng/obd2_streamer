defmodule Serial do

  @server Serial.Server

  ####
  #Contains external API

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
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

  def command(command) do # pass atom from OBD2.Parameters
    GenServer.call(__MODULE__, {:command, command})
  end

  def get_parameter(param) do # pass atom from OBD2.Parameters
    GenServer.call(__MODULE__, {:get_parameter, param})
  end

  #param=param_atom, settings= :enabled/:disabled, tvalue = ms between updates (min 50ms)
  def set_timed_update_mode(param, settings, tvalue) do
    GenServer.call(__MODULE__, {:set_update_mode, :timed, param, settings, tvalue})
  end

  @doc """
    param=param_atom from OBD2.Parameters
    settings::map =>
    %{
      :thresh_upd => :enabled/:disabled,
      :trigger_high_low => :high/:low,
      :control_pin_1 => :true/:false,
      :control_pin_9 => :true/:false,
      :upd_messages => :enabled/:disabled
    }
    tvalue = integer threshold value

  """
  def set_threshold_update_mode(param, settings, tvalue) do
    GenServer.call(__MODULE__, {:set_update_mode, :threshold, param, settings, tvalue})
  end

end
