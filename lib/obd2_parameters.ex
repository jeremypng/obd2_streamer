defmodule OBD2.Parameters do
  def table do
    [
      %{
        :id => <<0x00>>,
        :atom => :vehicle_speed,
        :name => "Vehicle Speed",
        :size_bytes => 2,
        :units => "MPH",
        :scale => 1/410
      },
      %{
        :id => <<0x01>>,
        :atom => :engine_speed,
        :name => "Engine Speed",
        :size_bytes => 2,
        :units => "RPM",
        :scale => 1/4
      },
      %{
        :id => <<0x02>>,
        :atom => :throttle_position,
        :name => "Throttle Position",
        :size_bytes => 2,
        :units => "%",
        :scale => 1/655
      },
      %{
        :id => <<0x03>>,
        :atom => :odometer,
        :name => "Odometer",
        :size_bytes => 4,
        :units => "Miles",
        :scale => 1/1
      },
      %{
        :id => <<0x04>>,
        :atom => :fuel_level,
        :name => "Fuel Level",
        :size_bytes => 2,
        :units => "%",
        :scale => 1/655
      },
      %{
        :id => <<0x07>>,
        :atom => :engine_coolant_temp,
        :name => "Engine Coolant Temp",
        :size_bytes => 2,
        :units => "F",
        :scale => :decode_f_temp
      },
      %{
        :id => <<0x08>>,
        :atom => :ignition_status,
        :name => "Ignition Status",
        :size_bytes => 2,
        :units => "On/Off",
        :scale => 1/1,
        :values => [{1, "Off"},{0, "On"}]
      },
      %{
        :id => <<0x09>>,
        :atom => :mil_status,
        :name => "MIL Status",
        :size_bytes => 2,
        :units => "On/Off",
        :scale => 1/1,
        :values => [{1, "Off"},{0, "On"}]
      },
      %{
        :id => <<0x0C>>,
        :atom => :fuel_rate,
        :name => "Fuel Rate",
        :size_bytes => 2,
        :units => "GPH",
        :scale => 1/2185
      },
      %{
        :id => <<0x0D>>,
        :atom => :battery_voltage,
        :name => "Battery Voltage",
        :size_bytes => 2,
        :units => "Volts",
        :scale => 1/3641
      },
      %{
        :id => <<0x0E>>,
        :atom => :pto_status,
        :name => "PTO Status",
        :size_bytes => 2,
        :units => "On/Off",
        :scale => 1/1,
        :values => [{1, "Off"},{0, "On"}]
      },
      %{
        :id => <<0x0F>>,
        :atom => :seatbelt_fastened,
        :name => "Seatbelt Fastened",
        :size_bytes => 2,
        :units => "Yes/No",
        :scale => 1/1,
        :values => [{1, "Unfastened"},{0, "Fastened"}]
      },
      %{
        :id => <<0x10>>,
        :atom => :misfire_monitor,
        :name => "Misfire Monitor",
        :size_bytes => 2,
        :units => "Status",
        :scale => 1/1,
        :values => [{1, "Monitor Complete"},{0, "Monitor Not Complete"}]
      },
      %{
        :id => <<0x11>>,
        :atom => :fuel_system_monitor,
        :name => "Fuel System Monitor",
        :size_bytes => 2,
        :units => "Status",
        :scale => 1/1,
        :values => [{1, "Monitor Complete"},{0, "Monitor Not Complete"}]
      },
      %{
        :id => <<0x12>>,
        :atom => :comprehensive_component_monitor,
        :name => "Comprehensive Component Monitor",
        :size_bytes => 2,
        :units => "Status",
        :scale => 1/1,
        :values => [{1, "Monitor Complete"},{0, "Monitor Not Complete"}]
      },
      %{
        :id => <<0x13>>,
        :atom => :catalyst_monitor,
        :name => "Catalyst Monitor",
        :size_bytes => 2,
        :units => "Status",
        :scale => 1/1,
        :values => [{1, "Monitor Complete"},{0, "Monitor Not Complete"}]
      },
      %{
        :id => <<0x14>>,
        :atom => :heated_catalyst_monitor,
        :name => "Heated Catalyst Monitor",
        :size_bytes => 2,
        :units => "Status",
        :scale => 1/1,
        :values => [{1, "Monitor Complete"},{0, "Monitor Not Complete"}]
      },
      %{
        :id => <<0x15>>,
        :atom => :evaporative_system_monitor,
        :name => "Evaporative System Monitor",
        :size_bytes => 2,
        :units => "Status",
        :scale => 1/1,
        :values => [{1, "Monitor Complete"},{0, "Monitor Not Complete"}]
      },
      %{
        :id => <<0x16>>,
        :atom => :secondary_air_system_monitor,
        :name => "Secondary Air System Monitor",
        :size_bytes => 2,
        :units => "Status",
        :scale => 1/1,
        :values => [{1, "Monitor Complete"},{0, "Monitor Not Complete"}]
      },
      %{
        :id => <<0x17>>,
        :atom => :ac_system_refrigerant_monitor,
        :name => "A/C System Refrigerant Monitor",
        :size_bytes => 2,
        :units => "Status",
        :scale => 1/1,
        :values => [{1, "Monitor Complete"},{0, "Monitor Not Complete"}]
      },
      %{
        :id => <<0x18>>,
        :atom => :oxygen_sensor_monitor,
        :name => "Oxygen Sensor Monitor",
        :size_bytes => 2,
        :units => "Status",
        :scale => 1/1,
        :values => [{1, "Monitor Complete"},{0, "Monitor Not Complete"}]
      },
      %{
        :id => <<0x19>>,
        :atom => :oxygen_sensor_heater_monitor,
        :name => "Oxygen Sensor Heater Monitor",
        :size_bytes => 2,
        :units => "Status",
        :scale => 1/1,
        :values => [{1, "Monitor Complete"},{0, "Monitor Not Complete"}]
      },
      %{
        :id => <<0x1A>>,
        :atom => :egr_system_monitor,
        :name => "EGR System Monitor",
        :size_bytes => 2,
        :units => "Status",
        :scale => 1/1,
        :values => [{1, "Monitor Complete"},{0, "Monitor Not Complete"}]
      },
      %{
        :id => <<0x1B>>,
        :atom => :brake_switch_status,
        :name => "Brake Switch Status",
        :size_bytes => 2,
        :units => "Pressed/Not Pressed",
        :scale => 1/1,
        :values => [{1, "Brake Switch Off"},{0, "Brake Switch On"}]
      },
      %{
        :id => <<0x1C>>,
        :atom => :ambient_air_temp,
        :name => "Ambient Air Temperature",
        :size_bytes => 2,
        :units => "F",
        :scale => :decode_f_temp
      },
      %{
        :id => <<0x22>>,
        :atom => :trip_odometer,
        :name => "Trip Odometer",
        :size_bytes => 4,
        :units => "Miles",
        :scale => 1/10
      },
      %{
        :id => <<0x23>>,
        :atom => :trip_fuel_consumption,
        :name => "Trip Fuel Consumption",
        :size_bytes => 4,
        :units => "Gallons",
        :scale => 1/128
      },
      %{
        :id => <<0x24>>,
        :atom => :distance_since_dtc_cleared,
        :name => "Distance since DTC cleared",
        :size_bytes => 4,
        :units => "Miles",
        :scale => 1/1
      },
      %{
        :id => <<0x25>>,
        :atom => :transmission_fluid_temp,
        :name => "Transmission Fluid Temperature",
        :size_bytes => 2,
        :units => "F",
        :scale => :decode_f_temp
      },
      %{
        :id => <<0x26>>,
        :atom => :oil_life_remaining,
        :name => "Oil Life Remaining",
        :size_bytes => 2,
        :units => "%",
        :scale => 1/500
      },
      %{
        :id => <<0x27>>,
        :atom => :tpm_monitoring_status,
        :name => "Tire Pressure Monitoring Status",
        :size_bytes => 8,
        :units => "Normal/Abnormal",
        :scale => :decode_tpm_monitoring_status
      },
      %{
        :id => <<0x28>>,
        :atom => :tire_pressures,
        :name => "Tire Pressures",
        :size_bytes => 6,
        :units => "PSI",
        :scale => :decode_tire_pressures
      },
      %{
        :id => <<0x2A>>,
        :atom => :barometric_pressure,
        :name => "Barometric Pressure",
        :size_bytes => 2,
        :units => "PSI",
        :scale => :decode_f_temp
      },
      %{
        :id => <<0x2B>>,
        :atom => :engine_run_time,
        :name => "Engine Run Time",
        :size_bytes => 4,
        :units => "Seconds",
        :scale => 1/1
      },
      %{
        :id => <<0x2C>>,
        :atom => :mpg,
        :name => "Miles per Gallon",
        :size_bytes => 2,
        :units => "MPG",
        :scale => 1/1
      }
    ]
  end

  def decode_tire_pressures(front_left, front_right, rear_left_outer, rear_left_inner, rear_right_outer, rear_right_inner) do
    %{
      :front_left => !!front_left,
      :front_right => !!front_right,
      :rear_left_outer => !!rear_left_outer,
      :rear_left_inner => !!rear_left_inner,
      :rear_right_outer => !!rear_right_outer,
      :rear_right_inner => !!rear_right_inner
    }
  end

  def decode_tpm_monitoring_status(<<tpm_status, specific_tire_problem_known, front_left, front_right, rear_left_outer, rear_left_inner, rear_right_outer, rear_right_inner>>) do
    case tpm_status do
      1 -> %{:tpm_status => :normal}
      0 -> %{
          :tpm_status => :abnormal,
          :specific_tire_problem_known => !!specific_tire_problem_known,
          :front_left_problem => !!front_left,
          :front_right_problem => !!front_right,
          :rear_left_outer_problem => !!rear_left_outer,
          :rear_left_inner_problem => !!rear_left_inner,
          :rear_right_outer_problem => !!rear_right_outer,
          :rear_right_inner_problem => !!rear_right_inner
        }
    end
  end

  def decode_f_temp(temp_raw) do
    temp_raw/64 - 40
  end

  def get_param_by_id(id) do
    result = for param = %{id: src_id} <- table(), src_id == id, do: param
    case Enum.count(result) do
      0 -> nil
      1 -> result
    end
  end

  def get_param_by_atom(atom) do
    for param = %{atom: src_atom} <- table(), src_atom == atom, do: param
  end
end
