defmodule Serial.Impl do

  ####
  # Contains logic implementation

  def init(port) do
    {:ok, pid} = Circuits.UART.start_link()
    Circuits.UART.open(pid, port, framing: Framer, speed: 115200, active: true)
    #IO.inspect(Circuits.UART.signals(pid))
    {:ok, pid}
  end

  def raw_command(pid, command) do
    Circuits.UART.write(pid, command)
  end

  def command(pid, command) do
    case command do
      :get_supported_parameters -> Circuits.UART.write(pid, <<0x01,0x01,0x20,0x00,0x22>>)
    end
    Circuits.UART.write(pid, command)
  end

  def get_vin(pid) do
    Circuits.UART.write(pid, <<0x01,0x01,0x25,0x01,0x00,0x28>>)
  end

  def redetect_vehicle(pid) do
    Circuits.UART.write(pid, <<0x01,0x01,0x24,0x00,0x26>>)
  end

  def decode_error(error) do
    errorMsg = case error do
      <<0x00>> -> "Incorrect Checksum"
      <<0x01>> -> "Invalid Command"
      <<0x02>> -> "Invalid Start of Frame"
      <<0x03>> -> "Command Parameters out of Range"
      <<0x04>> -> "Incorrect Number of bytes in the Message"
      <<0x05>> -> "Obsolete"
      <<0x06>> -> "Too Many Control Bytes (Out of Range)"
      <<0x07>> -> "Too Many Data Bytes (Out of Range)"
      <<0x0B>> -> "System manager image invalid. Update required"
      <<0x0C>> -> "FPGA image invalid. Update required"
      <<0x0D>> -> "Database image invalid. Update required"
      <<0x0E>> -> "Command parameter not supported (may be sent in Standby mode to several commands which are handled properly in regular operating mode)"
      <<0x0F>> -> "Critical system error (reboot required)"
    end
    errorMsg
  end

  def decode_info_generic(message) do
    response = case message do
      #VIN response
      <<0x01,0x01,0xA5,0x12,0x00,vin::binary-size(17),_cs>> -> %{vin: vin}
      <<0x01,0x01,0xA4,0x00,0xA6>> -> %{redetect_vehicle: :in_progress}
      <<0x01,0x01,0x80,0x00,0x82>> -> %{redetect_vehicle: :complete}
      <<0x01,0x01,0x81,0x00,0x83>> -> %{error: :vehicle_not_detected}
      <<0x01,0x01,0xD0,0x00,0xD2>> -> %{error: :ignition_off}
      <<0x01,0x01,0xA3,0x02,ignition_state,aux_obd2,_cs>> -> %{ignition_state: ignition_state, aux_obd2: aux_obd2}
      <<0x01,0x01,0xA0,data_length,parameters::binary-size(data_length),_cs>> -> %{supported_parameters: decode_parameters(parameters)}
    end
    response
  end

  def decode_parameters(parameters) do
    param_atoms = []
    param_byte_array = :binary.bin_to_list(parameters)
    for param = _byte <- param_byte_array, param, do: param_atoms ++ [OBD2.Parameters.get_param_by_id(param)]
    param_atoms
  end




end
