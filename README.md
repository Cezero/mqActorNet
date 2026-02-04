# mqActorNet

Builds NetBots / DanNet style functionality in LUA on top of MacroQuest Actors

## Commands

```text
/anquit - Quits the script

# Remote Execution Commands
/anexecute CharacterName /command - Executes '/command' on a specific character

# Global Execution Commands
# Will execute on all characters on the Actor network (see https://docs.macroquest.org/main/features/actors/#configuration)
/anaexecute /command
/anaaexecute /command - Includes character sending the command

# Zone Execution Commands
/anzexecute /command
/anzaexecute /command - Includes character sending the command

# Group Execution Commands
/angexecute /command
/angaexecute /command - Includes character sending the command

# Raid Execution Commands
/anrexecute /command
/anraexecute /command - Includes character sending the command
```
