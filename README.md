
# Spiri 

    __  ____            _          _  __
   / / / ___|   _ __   (_)  _ __  (_) \ \
  | |  \___ \  | '_ \  | | | '__| | |  | |
 < <    ___) | | |_) | | | | |    | |   > >
  | |  |____/  | .__/  |_| |_|    |_|  | |
   \_\         |_|                    /_/

Made specifically for https://github.com/Vespr0/Gamma.

# Features

### Action Queue
**The action queue allows you to execute the npc actions without overlap, with different priorities and an abortion system.**

*Example: An NPC is chatting, after a few seconds but before he is done chatting he is interrupted by an enemy, he is programmed to attack enemies. The attack action has a higher priority compared to the chatting action therefor, the chatting action is aborted (if implemented) and the attack is executed without weird overlapping behaivor.*
*In this example the chatting action can be interrupted and is executed with the action queue feature, however, you could simply not use it, you could threat  the chatting action as just a normal function and not use this feature, it's up to you. You could also make an action uninterruptable but still use the action queue*

### Cooler
**This is a simple cooldown module.**

### Flags
**Simple true or false conditions.**

### Emotion
**Experimental and perhaps too specific for most applications.**

### Events
**Easy to reference events .**

### Debugger
**Use the NPC rig to display messages above it's head for debugging.**

# Usage

Look at the "Examples" files while reading these steps.

1. Create a new class inheriting a sub-class (or even the main Spiri class itself). Define a constructor with `body` and `config` parameters. 
2. Define a main function with the `self.events.get("tick")` loops you need or for better performance just use the one. 
3. Define actions with the action queue, specifying a `actionKey`, `actionPriority` and whether or not it is `uninterruptible`. Implement `start` and optionally the `finish` and `abort` events which are fired respectivly when the action started, finished and was aborted.
4. To bring your npc to life create a new instance of your class with the `body` and the optional `config` table.
