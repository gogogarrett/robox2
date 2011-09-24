## Robox ##

Robox is a minimalistic IRC framework for quickly developing utility bots. It's database-based, and uses a hook system to provide extensibility.

To install:

    rake install

To run:
    
    ruby robox.rb
    
### Plugins ###

Plugins should be created inside the `extensions` folder, in a folder of their own name. Ruby will automatically load any Ruby file inside that folder, so if you only want your plugin accessible from one file, make sure to create a subfolder to store your non-entrypoint code.

In short:

    / extensions
    ---- / my_extension
    --------- / my_extension.rb (which requires the module from my_extension_module.rb)
    --------- / my_extension_requires
    ------------- / my_extension_module.rb
    
Robox implements hooks that are called upon events. This, plus the ability to access all the native commands of Robox inside your plugin, gives you a great deal of power with minimal fuss. 

Here's how a hook works: if Robox receives a certain stimulus from the server it's connected to, it will check to see if that event has any commands associated to it, and, if so, will run those events. 

Here's how you declare a hook:

    plugin = MyPlugin.new
    plugin.add_hook(:startup) { plugin.join "#chat" }
    
When Robox receives the signal that it's time to start up, it will join channel #chat -- maybe before or after it does other things, depending on whether other plugins or core processes have registered hooks.

As another example, let's look at a hook that adds a greeting when Robox detects a join to a channel it's sitting in. Instead of declaring the hook after the plugin class declaration, we'll declare it in the initialize method, so we only have to instantiate the class (this is useful if we have to create more than one hook, because we don't have to say `plugin.join` or prefix any of the methods available to the plugin with the instance).

Here's what a more complete example looks like:

    class MyGreetingPlugin < IRCClient
      
      def initialize
        add_hook(:join) {|m| greet_person( m[:user], m[:channel] ) }
      end
      
      def greet_person(user, channel)
        say channel, "Hello, #{user}!"
      end
      
    end
    
    plugin = MyGreetingPlugin.new

As you can see here, when we are inside the plugin, we have access to methods such as `add_hook` and `say` without having to refer to the instance of the plugin.

Further, many hooks pass the methods assigned to them a hash (`m` in this example). Inside this hash are a number of named parameters that contain data that Robox has gleaned from the event. In the case of a user joining a channel, Robox knows which user joined which channel, and so it makes that information available to your hooks.

Here's a list of the names of the hooks that can be triggered, and the 'm' data they make available to your method.

    # Triggered once Robox has performed a basic handshake with the server.
    trigger :connect
    
    # Triggers when Robox joins a channel.
    trigger :self_join, {:channel}
    
    # Triggers when Robox receives any text information -- very low level; not recommended.
    # There are probably other hooks that better match what you're looking for.
    trigger :response, {:message}
    
    # Triggers when Robox receives a private message. 
    # Target in this case can be a user or a channel.
    trigger :privmsg, {:target, :message}
    
    # Triggers when Robox receives a command (a message beginning with '!').
    # Target in this case can be a user or channel, and command has the '!' removed.
    trigger :command, {:target, :command}
    
    # Triggers when Robox receives a notice. Not currently enabled.
    trigger :notice, {:message}
    
    # Triggered when Robox is generally ready to start running commands.
    trigger :startup
    
    # Triggered when Robox receives a RAW number from the server.
    trigger :raw, {:numeric}
    
    # Triggered when Robox sees a user join a channel.
    trigger :join, {:user, :channel}
    
    # Triggered when Robox sees someone get kicked or is kicked from a channel.
    # Abuser refers to the person who issued the kick
    # User is the recipient of the kick
    # Message is the optional message supplied by the abuser.
    trigger :kick, {:channel, :abuser, :user, :message}
    
    # Triggered when Robox sees someone change their nick.
    trigger :nick_change, {:old_nick, :new_nick}
    
    # Triggered when Robox sees someone change a topic.
    trigger :topic_change, {:channel, :topic}
    
    # Triggered when Robox sees someone part a channel.
    trigger :part, {:user, :channel}
    
    # Triggered when Robox sees someone change the mode on a channel.
    trigger :mode_change, {:channel, :modestring}
    
    # Triggered when Robox sees someone quit the server.
    trigger :quit, {:user}
