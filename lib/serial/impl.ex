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
  end

  def get_parameter(pid, param) do
    %{id: <<param_id>>} = OBD2.Parameters.get_param_by_atom(param)
    cs = 37 + param_id
    # IO.inspect(param_id,label: "get_param_param_id")
    # IO.inspect(cs,label: "get_param_cs")
    Circuits.UART.write(pid,<<0x01,0x01,0x22,0x01,param_id,cs>>)
  end

  def set_update_mode(pid, :timed, param, setting, tvalue) do
    %{id: <<param_id>>} = OBD2.Parameters.get_param_by_atom(param)
    setting_bin = case setting do
      :disabled -> 0
      :enabled -> 1
    end
    tvalue_obd2 = div(tvalue, 50)
    # tvalue_obd2 = tvalue / 50
    tvalue_bin = :binary.encode_unsigned(tvalue_obd2)
    tvalue_final = case byte_size(:binary.encode_unsigned(tvalue_obd2)) do
      1 -> <<0>> <> tvalue_bin
      2 -> tvalue_bin
    end
    tvalue_list = :binary.bin_to_list(tvalue_final)
    <<tval_1,tval_2>> = tvalue_final
    cs = 54 + param_id + setting_bin + Enum.sum(tvalue_list)
    Circuits.UART.write(pid,<<0x01,0x01,0x30,0x04,param_id,setting_bin,tval_1,tval_2,cs>>)
  end

  def set_update_mode(pid, :threshold, param, setting, tvalue) do
    %{id: <<param_id>>, scale: param_scale} = OBD2.Parameters.get_param_by_atom(param)
    %{thresh_upd: thresh_upd, trigger_high_low: trigger_high_low, control_pin_1: control_pin_1, control_pin_9: control_pin_9, upd_messages: upd_messages} = setting
    thresh_upd_val = case thresh_upd do
      :enabled -> 1
      :disabled -> 0
    end
    trigger_high_low_val = case trigger_high_low do
      :high -> 0
      :low -> 2
    end
    control_pin_1_val = case control_pin_1 do
      :true -> 4
      :false -> 0
    end
    control_pin_9_val = case control_pin_9 do
      :true -> 8
      :false -> 0
    end
    upd_messages_val = case upd_messages do
      :enabled -> 0
      :disabled -> 16
    end
    setting_val = thresh_upd_val + trigger_high_low_val + control_pin_1_val + control_pin_9_val + upd_messages_val
    tvalue_encoded = encode_tvalue(param_scale, tvalue)
    tvalue_final = case byte_size(:binary.encode_unsigned(tvalue_encoded)) do
      1 -> <<0>> <> tvalue_encoded
      2 -> tvalue_encoded
    end
    tvalue_list = :binary.bin_to_list(<<tvalue_encoded>>)
    cs = 55 + param_id + setting_val + Enum.sum(tvalue_list)
    IO.inspect(<<0x01,0x01,0x31,0x04,param_id,setting_val,tvalue_final,cs>>, label: "set_thresh_update_raw")
    Circuits.UART.write(pid,<<0x01,0x01,0x31,0x04,param_id,setting_val,tvalue_final,cs>>)
  end

  def encode_tvalue(:decode_f_temp, tvalue) do
    OBD2.Parameters.encode_f_temp(tvalue)
  end

  def encode_tvalue(scale, tvalue) do
    Kernel.trunc(tvalue/scale)

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
      <<0x01,0x01,0xA0,data_length,parameters::binary-size(data_length),_cs>> -> %{supported_parameters: decode_parameter_list(parameters)}
      <<0x01,0x01,0xA2,data_length,parameter_data::binary-size(data_length),_cs>> -> decode_parameter_values(:get_param, parameter_data, [])
      <<0x01,0x01,0xB0,0x04,param_id::binary-size(1),setting::binary-size(1),tvalue::binary-size(2),_cs>> -> decode_update_mode(param_id,setting,tvalue)
      <<0x01,0x01,0xC0,data_length,parameter_data::binary-size(data_length),_cs>> -> decode_parameter_values(:timed_update, parameter_data, [])
      <<0x01,0x01,0xC1,data_length,parameter_data::binary-size(data_length),_cs>> -> decode_parameter_values(:threshold_update, parameter_data, [])
      <<msg::binary>> -> msg #unknown message
    end
    response
  end

  def decode_parameter_list(parameters) do
    param_atoms = []
    param_byte_array = :binary.bin_to_list(parameters)
    conditions = Enum.map(OBD2.Parameters.table(), fn %{id: v} -> v end)
    for param = byte <- param_byte_array, Enum.member?(conditions, <<byte>>), do: param_atoms ++ [OBD2.Parameters.get_param_by_id(<<param>>)]
    # for param = _byte <- param_byte_array, param, do: param_atoms ++ [OBD2.Parameters.get_param_by_id(param)]
  end

  def decode_parameter_values(update_type, <<param_id::binary-size(1), rest::binary>>, values) do
    %{atom: param_atom, name: param_name, units: param_units, size_bytes: size_bytes, value_type: param_type, scale: scale} = hd(OBD2.Parameters.get_param_by_id(param_id))
    <<value_bin::binary-size(size_bytes), rem_rest::binary>> = rest
    param_val_map = process_parameter_value(param_type, scale, value_bin)

    value_map = %{
      :atom => param_atom,
      :name => param_name,
      :units => param_units,
      :value => param_val_map,
      :update_type => update_type
    }
    decode_parameter_values(rem_rest, values ++ value_map)
  end

  def decode_parameter_values(<<>>, results) do
    results
  end

  def process_parameter_value(:val_int, :decode_f_temp, val_bin) do
    val_int = :binary.decode_unsigned(val_bin)
    value = OBD2.Parameters.decode_f_temp(val_int)
    %{
      :val_type => :int,
      :val => value
    }
  end

  def process_parameter_value(:val_int, scale, val_bin) do
    # IO.inspect(scale,label: "proc_param_val:scale")
    # IO.inspect(val_bin,label: "proc_param_val:val_bin")
    # IO.inspect(size_bytes,label: "proc_param_val:size_bytes")
    val_int = :binary.decode_unsigned(val_bin)
    # IO.inspect(val_int,label: "proc_param_val:val_int")
    value = val_int * scale
    %{
      :val_type => :int,
      :val => value
    }
  end

  def process_parameter_value(:val_bin, :decode_tpm_monitoring_status, val_bin) do
    value = OBD2.Parameters.decode_tpm_monitoring_status(val_bin)
    %{
      :val_type=> :map,
      :value=> value
    }
  end

  def process_parameter_value(:val_bin, :decode_tire_pressures, val_bin) do
    value = OBD2.Parameters.decode_tire_pressures(val_bin)
    %{
      :val_type=> :map,
      :value=> value
    }
  end

  def decode_update_mode(param_id,setting,tvalue) do
    %{atom: param_atom, name: param_name} = hd(OBD2.Parameters.get_param_by_id(param_id))
    %{
      :atom => param_atom,
      :name => param_name,
      :setting => case setting do
        <<0>> -> :disabled
        <<1>> -> :enabled
      end,
      :tvalue => :binary.decode_unsigned(tvalue) * 50,
      :units => "ms"
    }
  end

end
