import Config

config :midi,
  ppqn: 96

import_config "#{config_env()}.exs"
