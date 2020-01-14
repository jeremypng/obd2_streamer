import Config

mqtt_server = System.get_env("OBD2_MQTT_SERVER","10.4.200.4")
serial_port = System.get_env("OBD2_SERIAL_PORT","cu.usbserial")

config :obd2_streamer,
  mqtt_server: mqtt_server,
  serial_port: serial_port
