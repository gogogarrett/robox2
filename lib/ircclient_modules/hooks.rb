module Hooks
  
  @@hooks ||= {}
  
  # TODO: Add remove_hook
  
  
  # add_hook: register a hook to run.
  # 
  # Params:
  #  key        => the event to add the hook to
  #  {block}    => the name of the function to run.
  def add_hook(key, &block)
    if @@hooks.has_key? key
      @@hooks[key].push block
    else
      @@hooks[key] = [block]
    end
  end
  
  def prepend_hook(key, &block)
    if @@hooks.has_key? key
      @@hooks[key].unshift bock
    else
      @@hooks[key] = [block]
    end
  end
  
  def run_hook(key, data = {})
    @@hooks[key].clone.each {|block| data.empty? ? block.call : block.call(data) } if @@hooks.has_key? key
  end
  
  def trigger(event, data = {})
    run_hook event, data
  end
  
end
