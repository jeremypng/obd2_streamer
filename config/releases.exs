import Config

mqtt_server: System.fetch_env!("OBD2_MQTT_SERVER")
serial_port: System.fetch_env!("OBD2_SERIAL_PORT")

config :obd2_streamer,
  mqtt_server: mqtt_server,
  serial_port: serial_port
