local mq = require('mq')

_G.mqActorNetCommands = _G.mqActorNetCommands or {}
local Registry = _G.mqActorNetCommands

-- Unbind everything (safe to call multiple times)
function Registry.clear()
  for cmd, _ in pairs(Registry) do
    if type(cmd) == 'string' then
      mq.unbind(cmd)
      Registry[cmd] = nil
    end
  end
end

-- Register a command safely
function Registry.bind(cmd, fn)
  mq.unbind(cmd)
  mq.bind(cmd, fn)
  Registry[cmd] = fn
end

return Registry
