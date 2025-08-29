local Debugger = {}
Debugger.__index = Debugger

--[[
    Debug component using ChatService 
]]

local ChatService = game:GetService("Chat")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

function Debugger:chat(message : string)
    ChatService:Chat(self.serverEntity.rig.Head, message, "White")
end

function Debugger.new(serverEntity)
    local self = setmetatable({}, Debugger)

    self.serverEntity = serverEntity

    return self
end

return Debugger