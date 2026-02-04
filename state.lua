_G.mqActorNetState = _G.mqActorNetState or {
    runscript = true,
}

local State = _G.mqActorNetState

function State.stop()
    State.runscript = false
end

return State
