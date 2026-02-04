local mq = require('mq')
local actors = require('actors')

-- Basic remote command execution
local function execCommand(command)
    mq.cmd(command)
end

-- message handler for remote commands
local cmdActor = actors.register('rexec', function (message)
    if message.content.id == 'direct' or (message.content.id == 'global' and mq.TLO.Me.Name() ~= message.content.sender) then
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

local function sendCommand(includeSelf, target, ...)
    local targets = {
        zone = true,
        group = true,
        raid = true,
        global = true
    }
    local cmd = concat(...)
    if includeSelf then
        execCommand(cmd)
    end
    if not targets[target] then
        cmdActor:send({character=target, mailbox='rexec'}, {sender = mq.TLO.Me.Name(), id = 'direct', command = cmd})
    else
        cmdActor:send({mailbox='rexec'}, {sender = mq.TLO.Me.Name(), id = target, command = cmd, zone = mq.TLO.Zone.ShortName()})
    end
end

local sendGlobalCommand = function (...)
    sendCommand(false, 'global', ...)
end

local sendSelftAndGlobalCommand = function (...)
    sendCommand(true, 'global', ...)
end

local sendDirectCommand = function (target, ...)
    sendCommand(false, target, ...)
end

local sendZoneCommand = function (...)
    sendCommand(false, 'zone', ...)
end

local sendSelfAndZoneCommand = function (...)
    sendCommand(true, 'zone', ...)
end

local sendGroupCommand = function (...)
    sendCommand(false, 'group', ...)
end

local sendSelfAndGroupCommand = function (...)
    sendCommand(true, 'group', ...)
end

local sendRaidCommand = function (...)
    sendCommand(false, 'raid', ...)
end

local sendSelfAndRaidCommand = function (...)
    sendCommand(true, 'raid', ...)
end

local runscript = true
mq.bind('/anquit', function () runscript = false end)
mq.bind('/anexecute', sendDirectCommand)
mq.bind('/anaexecute', sendGlobalCommand)
mq.bind('/anaaexecute', sendSelftAndGlobalCommand)
mq.bind('/anzaexecute', sendSelfAndZoneCommand)
mq.bind('/anzexecute', sendZoneCommand)
mq.bind('/angaexecute', sendSelfAndGroupCommand)
mq.bind('/angexecute', sendGroupCommand)
mq.bind('/anraexecute', sendSelfAndRaidCommand)
mq.bind('/anrexecute', sendRaidCommand)

while runscript do
    mq.delay(100)
end
