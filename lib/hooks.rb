module Hooks
  # TODO: Add prepend_hook
  # TODO: Add remove_hook
  # TODO: Make 'triggers' accept arguments to pass to its functions
  # TODO: Figure out a graceful way to add hooks when in pluginspace
  
  def add_hook(key, callback, *args)
    if @hooks.has_key? key
      @hooks[key].push [callback, *args]
    else
      @hooks[key] = [[callback, *args]]
    end
  end
  
  def run_hook(key)
    if @hooks.has_key? key
      @hooks[key].each do |arr|
        callback = arr.shift
        send(callback, *arr) if respond_to? callback
      end
    end
  end
  
  def triggers(event)
    run_hook event
  end
  
end