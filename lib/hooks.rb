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
  def add_hook(key, &block)
    if @hooks.has_key? key
      @hooks[key].push block
    else
      @hooks[key] = [block]
    end
  end
  
  def run_hook(key, data = {})
    if @hooks.has_key? key
      @hooks[key].clone.each do |block|
        if data.empty?
          block.call
        else
          block.call(data)
        end
      end
    end
  end
  
  def triggers(event, data = {})
    run_hook event, data
  end
  
end
