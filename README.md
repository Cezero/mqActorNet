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
