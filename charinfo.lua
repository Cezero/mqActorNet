local actors = require('actors')
local mq = require('mq')
local state = require('mqActorNet.state')

_G.mqActorNetCharinfo = _G.mqActorNetCharinfo or {}
local Charinfo = _G.mqActorNetCharinfo

-- message handler for character info
local cmdActor = actors.register('charinfo', function (message)
    if message.content.id == 'publish' then
        state.Peers[message.content.sender] = message.content
        printf('[charinfo] Added peer: %s', message.content.sender)
    elseif message.content.id == 'remove' then
        state.Peers[message.content.sender] = nil
        printf('[charinfo] Removed peer: %s', message.content.sender)
    end
end)

function Charinfo.publish()
    local cinfo = {
        id = 'publish',
        sender = mq.TLO.Me.Name(),
        Level = mq.TLO.Me.Level(),
        Class = mq.TLO.Me.Class.ShortName(),
        PctHPs = mq.TLO.Me.PctHPs(),
        TargetID = mq.TLO.Target.ID(),
        CurrentZone = mq.TLO.Zone.ShortName()
    }
    cmdActor:send({mailbox='charinfo'}, cinfo)
end

function Charinfo.remove()
    cmdActor:send({mailbox='charinfo'}, {id = 'remove', sender = mq.TLO.Me.Name()})
end

function Charinfo.GetInfo(name)
    return state.Peers[name]
end

function Charinfo.GetPeers()
    local keys = {}
    for k in pairs(state.Peers) do
        keys[#keys + 1] = k
    end
    table.sort(keys)
    return table.concat(keys, ', ')
end

function Charinfo.GetPeerCnt()
    local n = 0
    for _ in pairs(state.Peers) do
        n = n + 1
    end
    printf('[charinfo] GetPeerCnt returning: %d', n)
    return n
end

return Charinfo
