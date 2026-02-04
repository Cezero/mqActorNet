local registry = require('mqActorNet.command_registry')
local charinfo = require('mqActorNet.charinfo')

registry.clear()

package.loaded['mqActorNet.commands'] = nil
require('mqActorNet.commands')

local mq = require('mq')
local state = require('mqActorNet.state')

while state.runscript do
    charinfo.publish()
    mq.delay(100)
end

charinfo.remove()
registry.clear()
