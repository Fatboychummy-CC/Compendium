# Main:

1. [ ] Determine system type (command, pocket, turtle, advanced?)
2. [ ] Determine what 'packages' are available to system type
3. [ ] Allow user to choose package(s) to run
  3. [ ] Auto-determine best package(s) but allow package(s) to be changed?
4. [ ] Install said package(s) or auto-update them (disableable by user).
5. [ ] Run packages

# Packages:
## Any:
* [ ] Dependency checking

### Any Inventory:
* [ ] Caching
  * [ ] Registration of inventories to be monitored
    * [ ] Registration of items within said inventories
  * [ ] Edit Registration
  * [ ] Remove Registration

### T:E data collection
* [ ] T:E Energy Cell
  * [ ] Data collector which collects current level, max level, difference since last check, time since last check, time to 0 or full (seconds).
* [ ] + Modem
  * [ ] Transmit information from data collector
* [ ] + Advanced? Monitor
  * [ ] Display information from data collector

### Chat Recorder
* [ ] Chat Recorder
  * [ ] Basic chat functionality
  * [ ] Commands:
    * [ ] Argument parsing
    * [ ] Flag parsing
    * [ ] `help [command]` command which gets information about a command and tells the player.
    * [ ] `run <lua code>` command which runs lua code (maybe sandboxed?) and tells result to player.
    * [ ] `math <problem>` command which determines the result of a math problem (should be fun to make).
    * [ ] `register <keycode>` command to register yourself as the owner of the chat recorder (used once).
    * [ ] `pattern <pattern>` command to set the match pattern (default `"^;"`).
    * [ ] `config <key, val>` command (`settings.set(key, val)`)
* [ ] + Introspection Module (bound)
  * [ ] Automatic registration of owner.
  * [ ] Commands:
    * [ ] `find <item name>, [inv/count], [count]` to find if an item (or a certain amount of items) is in an inventory
      * [ ] `-g` to transfer found items to self.
    * [ ] `transfer <item name, count, to>, [from]` to transfer items between self/enderchest/armor slots.
      * [ ] If `from` is specified, only search inventory `from`, else search all available.
    * [ ] `get <inv>` to get contents of inventory.
      * [ ] `-g` to transfer all items to self.
* [ ] + Other Inventory
  * [ ] Commands:
    * [ ] `transfer <item name, count, from, to>` to transfer items between inventories.

### Entity Sensor
* [ ] Get all entities
  * [ ] Determine if player, hostile, or unknown
  * [ ] Calculate distance between self and entity
* [ ] Add or remove entities from hostiles list

### Laser Beam
* [ ] fireAt method which takes a block offset and calculates whatever is needed, then fires.
* [ ] + Entity Sensor
  * [ ] Turret
    * [ ] Toggleable in UI
      * [ ] Player toggleable
      * [ ] Enemy toggleable
      * [ ] Master switch
    * [ ] Possibly maybe determine if the shot will shoot itself
* [ ] + Entity Sensor & Chat bot
  * [ ] Turret Status
    * [ ] total shots fired
    * [ ] master on/off
    * [ ] players on/off
    * [ ] enemy on/off
  * [ ] Toggle Turret
    * [ ] `turret toggle` command
    * [ ] `turret set <on/off>` command
  * [ ] Toggle firing at players
    * [ ] `turret toggle players` command
  * [ ] Toggle firing at hostiles (whitelist)
    * [ ] `turret toggle hostiles` command
  * [ ] Call fire at entity
    * [ ] `turret fireat <entity name>` command
  * [ ] Register a hostile
    * [ ] `turret registerhostile <entity name>` command
  * [ ] Remove a hostile
    * [ ] `turret removehostile <entity name>` command


## Neural:


## Pocket:


## Command:


## Turtle:


## Advanced:


## Pocket Advanced:


## Turtle Advanced:
