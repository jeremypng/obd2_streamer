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
        :scale => 1/64 - 40
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
      }
    ]
  end

  def get_param_by_id(id) do
    for param = %{id: src_id} <- table(), src_id == id, do: param
  end

  def get_param_by_atom(atom) do
    for param = %{atom: src_atom} <- table(), src_atom == atom, do: param
  end
end
