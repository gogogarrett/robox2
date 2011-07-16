module Hooks
  
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
        self.send(callback, *arr) if respond_to? callback
      end
    end
  end
  
  def triggers(event)
    run_hook event
  end
  
end