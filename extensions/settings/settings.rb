class SettingsPlugin < Plugin

  def initialize
    add_hook(:command) {|m| route m[:target], m[:command] }
    add_hook(:startup) {||}
    super
  end

  ################################################################
  public
  ################################################################
  
  def route(target, command)
    # If we don't match the namespace and the possible command, terminate ASAP.
    return false unless /config (get|set|list)/i.match command

    if $1.downcase == 'list'
      list(target)
    end
    
    # Strip the first two words from the argument.
    command = command.split(' ').slice(2..-1).join(' ')

    if $1.downcase == 'get'
      get(target, command)
    else
      key, new_value = command.split(' ')
      set(target, key, new_value)
    end
  end

  ################################################################  
  private
  ################################################################
  
  def list(target)
    say target, "Valid config settings: #{Setting.all.collect(&:name).join(", ")}"
  end
  
  def get(target, name)
    setting = Setting.find_by_name(name)
    if setting.nil?
      no_such_key(target, name)
    else
      say target, "#{setting.name} => #{setting.value}"
    end
  end
  
  def set(target, key, new_value)
    setting = Setting.find_by_name(key)
    if setting.nil?
      no_such_key(target, key)
    else
      setting.update_attribute('value', new_value)
      say target, "Updated setting."
    end
  end
  
  def no_such_key(target, key)
    say target, "No such setting by that key(#{key})."
  end
  
end

plugin = SettingsPlugin.new