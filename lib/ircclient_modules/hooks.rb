module Hooks
  
  @@hooks ||= {}
  
  def reserve_hook_id
    @hooks_registered ||= []
    @hook_count ||= 0
    
    name = "#{self.class.to_s}_#{@hook_count}"
    @hook_count += 1
    @hooks_registered << name
    
    name
  end
  
  def add_hook(key, name = reserve_hook_id, &block)
    if @@hooks.has_key? key
      @@hooks[key].merge({name.to_sym => block})
    else
      @@hooks[key] = {name.to_sym => block}
    end
  end
  
  def run_hook(key, data = {})
    @@hooks[key].clone.each_value {|block| data.empty? ? block.call : block.call(data) } if @@hooks.has_key? key
  end
  
  def trigger(event, data = {})
    run_hook event, data
  end
  
  def remove_hook(key, name)
    @@hooks[key].delete(name.to_sym)
  end
  
  def show_me_the_hooks
    @@hooks.inspect
  end
  
end
