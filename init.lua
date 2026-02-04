local registry = require('mqActorNet.command_registry')

registry.clear()

package.loaded['mqActorNet.commands'] = nil
require('mqActorNet.commands')

local mq = require('mq')
local state = require('mqActorNet.state')

while state.runscript do
    mq.delay(100)
end

registry.clear()
