# SPIRI

The art of giving the illusion of intelligence.

**WARNING**: This class is still incomplete, specifically a state machine component is planned.

# Features

**Action Queue**: The action queue allows you to execute the npc actions without overlap, with different priorities and an abortion system.

Example: An NPC is chatting, after a few seconds but before he is done chatting he is interrupted by an enemy, he is programmed to attack enemies. The attack action has a higher priority compared to the chatting action therefor, the chatting action is aborted (if implemented) and the attack is executed without weird overlapping behaivor.

In this example the chatting action can be interrupted and is executed with the action queue feature, however, you could simply not use it, you could threat  the chatting action as just a normal function and not use this feature, it's up to you. You could also make an action uninterruptable but still use the action queue

# Usage

You can skip this steps by just looking at the "Examples" files.

1. Create a new class inheriting a sub-class (or even the main Spiri class itself). Define a constructor. 
2. 

