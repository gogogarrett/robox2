module Hooks
  # TODO: Add prepend_hook
  # TODO: Add remove_hook
  # TODO: Figure out a graceful way to add hooks when in pluginspace
  
  
  # add_hook: register a hook to run.
  # 
  # Params:
  #  key        => the event to add the hook to
  #  callback   => the name of the function to call
  #  *args      => any number of symbols representing the name of the value to request, i.e. :message
  def add_hook(key, callback, *args)
    if @hooks.has_key? key
      @hooks[key].push [callback, *args]
    else
      @hooks[key] = [[callback, *args]]
    end
  end
  
  def run_hook(key, data = {})
    if @hooks.has_key? key
      @hooks[key].each do |array|
        arr = array.clone
        callback = arr.shift
        vals_for_callback = data.select{|k, v| arr.include? k }
        arr = arr.map{|val| vals_for_callback[val] }
        # Need to take {:my_data => 1, :my_arg => 'spot'} and pass it only those values it requests
        send(callback, *arr) if respond_to? callback
      end
    end
  end
  
  def triggers(event, data = {})
    run_hook event, data
  end
  
end
