class Plugin < IRCClient
  # TODO:
  #
  # Plugin should create an entry in a Plugin table which has a 'load plugin' field, and then inject hooks only if it should load
  # Plugin should be able to trigger its own load upon enabling said plugin field
  # Plugin should track its hooks programmatically, and be able to unload them from the hook registry
  # Plugin might provide an interface for declaring help commands
  # Plugin might provide an interface for routing and hooking up commands
end