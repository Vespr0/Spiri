local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.signal)

local Events = {}
Events.__index = Events

function Events:add(name)
    local event = Signal.new()
    self.dict[name] = event
    return event
end

function Events:get(name)
    return self.dict[name]
end

function Events.new()
    local self = setmetatable({}, Events)

    self.dict = {}; 

    return self
end

return Events