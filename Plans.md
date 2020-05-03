# Main:

1. [x] Determine system type (command, pocket, turtle, advanced?)
2. [ ] ~~Ensure resources.txt is up-to-date.~~
3. [ ] Determine what 'packages' are available to system type
4. [ ] Allow user to choose package(s) to run
  4. [ ] Auto-determine best package(s) but allow package(s) to be changed?
5. [ ] Install said package(s) or auto-update them (disableable by user).
6. [ ] Run packages

***resources.txt renamed to resources.lua***
hey it was renamed *and* moved this time. neat

# Packages:
## Any:
* [ ] Util:
  * [ ] Base methods:
    * [ ] `closestString(<table, string>, [maxOffBy=?, minDifference=?)`
      * [ ] Takes a table of strings and a string, returns the closest match (if possible)
      * [ ] If `maxOffBy` specified, the closest match must be within `maxOffBy` offset.
      * [ ] If `minDifference` specified, the closest match must be closer than `minDifference` than any other string.

* [ ] Performance:
  * [ ] Base methods:
    * [ ] `run(<function>)`
      * [ ] `pcall`s a function
      * [ ] Returns bool isError, string errorMessage, number timeRan

* [ ] Package:
  * [ ] Base methods:
    * [ ] `update(<package>, [force=false])`
      * [ ] Checks for updates for a single package, asks user to confirm if there is.
      * [ ] If `force`, update without confirmation.
    * [ ] `updateAll(<package>, [force=false])`
      * [ ] Checks for updates for all packages, asks user to confirm if there is.
      * [ ] If `force`, update without confirmation.
    * [x] `get([package])`
      * [x] Get information about a package (or all packages)
    * [x] `getDependencies(<package>)`
      * [x] Get dependencies (recursively) about a package.
    * [x] `install(<package>)`
      * [x] Installs a package, and any dependencies.
    * [x] `uninstall(<package>)`
      * [x] Uninstalls a package.
    * [x] `load(<package>)`
      * [x] Returns a loaded package (much like require)

* [ ] Core:
  * [ ] Base methods:
    * [ ] `getModules()`
      * [ ] Downloads the `module.lua` file.
    * [ ] `reinstall()`
      * [ ] Stop all modules
      * [ ] Remove all modules and `module.lua`
      * [ ] Redownload `main.lua`
      * [ ] Reboot with just `main.lua`
    * [ ] `md5(<string>)`
      * [ ] Calculate md5 hash of a string.


### Any Inventory:
* [ ] Base methods:
* [ ] `find(<item id, damage, count>, [from=nil], [passTo=nil])`
  * [ ] Finds an item by it's item id and damage.
  * [ ] Optionally pass argument `from` to only search in that inventory.
  * [ ] Optionally pass argument `passTo` to pass items found to that inventory.
  * [ ] overload `find(<item name, count>, [from=nil], [passTo=nil])`
    * [ ] Uses the cache to determine item id and damage from item name.

* [ ] Caching
  * [ ] methods:
    * [ ] `getName(<item id, damage>)`
      * [ ] Returns the name of an item from it's item id and damage.
    * [ ] `getInfo(<item name>)`
      * [ ] Returns the item id and damage of an item from it's name.
    * [ ] `registerItem(<item id, damage, item name>)`
      * [ ] Registers an item into the cache.
      * [ ] If the item already exists, edit the current value.
    * [ ] `removeItem(<item id, damage>)`
      * [ ] Removes an item from the cache.
    * [ ] `clear()`
      * [ ] Removes everything from the cache.
      * [ ] Only used for debug?

### T:E
* [ ] Data collection program
  * [ ] T:E Energy Cell
    * [ ] Data collector which collects current level, max level, difference since last check, time since last check, time to 0 or full (seconds).
  * [ ] + Modem
    * [ ] Transmit information from data collector
  * [ ] + Advanced? Monitor
    * [ ] Display information from data collector

### Chat Recorder
* [ ] Base methods:
  * [ ] `parseString(<string>)`
    * [ ] Parses each argument
    * [ ] Parses each flag
    * [ ] Returns table of args and flags
  * [ ] `listen()`
    * [ ] If configured, listen solely for a certain player via `chat_capture` events
    * [ ] Else, listen for anything via `chat_message` events.
    * [ ] Returns the string message received, and the player who said it.
  * [ ] `tell(<string>)`
    * [ ] If bound, tell the player something
    * [ ] Error if no bind
  * [ ] `say(<string>)`
    * [ ] If bound, say something
    * [ ] Error if no bind
* [ ] Event listeners:
  * [ ] `"chat_message"`
    * [ ] in function `listen`
  * [ ] `"chat_capture"`
    * [ ] in function `listen`
* [ ] Event Generators:
  * [ ] `"chat_parsed"`
    * [ ] parse a chat_message or chat_capture events

* [ ] Chat Bot program
  * [ ] Commands:
    * [ ] `help [command]` command which gets information about a command and tells the player.
    * [ ] `run <lua code>` command which runs lua code (maybe sandboxed?) and tells result to player.
    * [ ] `math <problem>` command which determines the result of a math problem (should be fun to make).
    * [ ] `register <keycode>` command to register yourself as the owner of the chat recorder (used once).
    * [ ] `pattern <pattern>` command to set the match pattern (default `"^;"`).
    * [ ] `config <key, val>` command (`settings.set(key, val)`).
    * [ ] `loaded` command to list loaded modules.
    * [ ] `load <name>` command to load a module.
    * [ ] `unload <name>` command to unload a module.
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
* [ ] Base methods:
  * [ ] `getEntities()`
    * [ ] Senses
    * [ ] `enemy` flag
    * [ ] `distance`
  * [ ] `addHostile(<entity name>)`
    * [ ] adds a hostile to list.
  * [ ] `removeHostile(<entity name>)`
    * [ ] removes hostile from list.
* [ ] Event generators:
  * [ ] `"entity_scan", <number:entities>`
    * [ ] Every time the scanner scans, generate event

### Laser Beam
* [ ] Base methods:
  * [ ] `aimAt(<vector3>)` which takes a block offset and returns the direction needed to aim
  * [ ] `fireAt(<vector3>)` which takes a block offset and calculates the aim, then fires.
* [ ] + Entity Sensor
  * [ ] Turret
    * [ ] Toggleable in UI
      * [ ] Player toggleable
      * [ ] Enemy toggleable
      * [ ] Master switch
    * [ ] Max Range setting
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
* [ ] Event generators:
  * [ ] `"laser_fired", <vector3:offset>`
    * [ ] Every time the laser fires, generate event.

## Neural:


## Pocket:


## Command:


## Turtle:


## Advanced:


## Pocket Advanced:


## Turtle Advanced:
