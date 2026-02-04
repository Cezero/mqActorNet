# mqActorNet

Builds NetBots / DanNet style functionality in LUA on top of MacroQuest Actors

## Commands

```text
/anquit - Quits the script
```

### Remote Execution Commands
```text
/anexecute CharacterName /command - Executes '/command' on a specific character
```

### Global Execution Commands
Will execute on all characters on the Actor network (see https://docs.macroquest.org/main/features/actors/#configuration)
```text
/anaexecute /command
/anaaexecute /command - Includes character sending the command
```

### Zone Execution Commands
```text
/anzexecute /command
/anzaexecute /command - Includes character sending the command
```

### Group Execution Commands
```text
/angexecute /command
/angaexecute /command - Includes character sending the command
```

### Raid Execution Commands
```text
/anrexecute /command
/anraexecute /command - Includes character sending the command
```

## LUA API
You can also use this from other lua scripts:
```lua
local rexec = require('mqActorNet.rexec')
rexec.sendDirectCommand(characterName, command) -- Executes a command on a specific character
rexec.sendGlobalCommand(command) -- Executes a command on all characters on the Actor network
rexec.sendSelfAndGlobalCommand(command) -- Executes a command on all characters on the Actor network and the character sending the command
rexec.sendZoneCommand(command) -- Executes a command on all characters in the zone on the Actor network
rexec.sendSelfAndZoneCommand(command) -- Executes a command on all characters in the zone on the Actor network and the character sending the command
rexec.sendGroupCommand(command) -- Executes a command on all characters in the group on the Actor network
rexec.sendSelfAndGroupCommand(command) -- Executes a command on all characters in the group on the Actor network and the character sending the command
rexec.sendRaidCommand(command) -- Executes a command on all characters in the raid on the Actor network
rexec.sendSelfAndRaidCommand(command) -- Executes a command on all characters in the raid on the Actor network and the character sending the command
```