local mq = require('mq')
local actors = require('actors')

-- Basic remote command execution
local function execCommand(command)
    mq.cmd(command)
end

-- message handler for remote commands
local cmdActor = actors.register('rexec', function (message)
    if message.content.id == 'direct' then
        printf("Recieved direct command from %s", message.content.sender)
        execCommand(message.content.command)
    elseif message.content.id == 'zone' and mq.TLO.Zone.ShortName() == message.content.zone then
        execCommand(message.content.command)
    elseif message.content.id == 'group' and mq.TLO.Group.Member(message.content.sender).Index() then
        execCommand(message.content.command)
    elseif message.content.id == 'raid' and mq.TLO.Raid.Member(message.content.sender).Name() ~= nil then
        execCommand(message.content.command)
    end
end)

local function concat(...)
    local input = {...}
    local parts = {}

    -- If a single table was passed, use its elements instead
    if #input == 1 and type(input[1]) == 'table' then
        input = input[1]
    end

    for _, v in ipairs(input) do
        if type(v) == 'table' then
            -- Flatten simple array-like tables
            for _, w in ipairs(v) do
                table.insert(parts, tostring(w))
            end
        else
            table.insert(parts, tostring(v))
        end
    end

    return table.concat(parts, ' ')
end

local sendDirectCommand = function (target, ...)
    cmdActor:send({character=target, mailbox='rexec'}, {sender = mq.TLO.Me.Name(), id = 'direct', command = concat(...)})
end

local sendZoneCommand = function (...)
    cmdActor:send({mailbox='rexec'}, {sender = mq.TLO.Me.Name(), id = 'zone', command = concat(...), zone = mq.TLO.Zone.ShortName()})
end

local sendGroupCommand = function (...)
    cmdActor:send({mailbox='rexec'}, {sender = mq.TLO.Me.Name(), id = 'group', command = concat(...)})
end

local sendRaidCommand = function (...)
    cmdActor:send({mailbox='rexec'}, {sender = mq.TLO.Me.Name(), id = 'raid', command = concat(...)})
end

local sendSelfAndZoneCommand = function (...)
    execCommand(concat(...))
    sendZoneCommand(...)
end

local sendSelfAndGroupCommand = function (...)
    execCommand(concat(...))
    sendGroupCommand(...)
end

local sendSelfAndRaidCommand = function (...)
    execCommand(concat(...))
    sendRaidCommand(...)
end

local runscript = true
mq.bind('/anquit', function () runscript = false end)
mq.bind('/anexecute', sendDirectCommand)
mq.bind('/anzaexecute', sendSelfAndZoneCommand)
mq.bind('/anzexecute', sendZoneCommand)
mq.bind('/angaexecute', sendSelfAndGroupCommand)
mq.bind('/angexecute', sendGroupCommand)
mq.bind('/anraexecute', sendSelfAndRaidCommand)
mq.bind('/anrexecute', sendRaidCommand)

while runscript do
    mq.delay(1000)
end
