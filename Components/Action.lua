local Action = {}
Action.__index = Action

--[[
    This whole class may be obsolete lmao
]]

-- Dependencies --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.signal)

export type ActionType = {
    startSignal: Signal.Signal,finishSignal: Signal.Signal
}

function Action:delete()
    setmetatable(self, nil)
    table.clear(self)
    table.freeze(self)
end

function Action.new()
    local self = setmetatable({}, Action) 

    self.startSignal = Signal.new()
    self.finishSignal = Signal.new()
    self.abortSignal = Signal.new()

    self.aborted = false
    self.ended = false
    self.isAborted = function()
        return self.aborted
    end

    self.abortSignal:Connect(function()
        self.aborted = true
        self.ended = true
    end)

    self.finishSignal:Connect(function()
        self.ended = true
        task.wait(60)
        self:delete()
    end)

    return self :: ActionType
end

return Action