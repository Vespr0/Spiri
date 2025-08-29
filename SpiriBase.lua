local Spiri = {}
Spiri.__index = Spiri

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[[
    __  ____            _          _  __
   / / / ___|   _ __   (_)  _ __  (_) \ \
  | |  \___ \  | '_ \  | | | '__| | |  | |
 < <    ___) | | |_) | | | | |    | |   > >
  | |  |____/  | .__/  |_| |_|    |_|  | |
   \_\         |_|                    /_/

   The art of giving the illusion of intelligence.
]]

-- Dependencies --

-- Components:
local Components = script.Parent.Components
local movement = require(Components.Movement)
local flags = require(Components.Flags)
local actionQueue = require(Components.ActionQueue)
local events = require(Components.Events)
local debugger = require(Components.Debugger)
local targeter = require(Components.Targeter)
local cooler = require(ReplicatedStorage.Utility.Cooler)

-- Class --
--[[
    Create a new Spiri, it takes control of a ServerEntity.
    The ServerEntity provides the body (rig), humanoid, and root part.
    It also provides access to backpack and other entity features.
]]
function Spiri.new(serverEntity, config)
	-- warn(serverEntity.id)
    assert(serverEntity, "ServerEntity is required for Spiri")
    config = config or {}
    local self = setmetatable({}, Spiri)
    -- Abstract properties:
    self.active = false
    self.reflex = config.reflex or .2 -- Time delay for every iteration of the main loop.
    -- Physical properties:
    self.serverEntity = serverEntity -- Reference to the ServerEntity (required)
    self.body = serverEntity.rig -- The body is the rig from the ServerEntity
    self.humanoid = serverEntity.humanoid -- Use the humanoid from the ServerEntity
    self.root = serverEntity.root -- Use the root part from the ServerEntity
    -- Interfaces:
	self.movement = self.humanoid and movement.new(self.body) or nil -- Movement interface will only be available on humanoid:
	self.flags = flags.new()
	self.events = events.new()
	self.actionQueue = actionQueue.new()
	self.cooler = cooler.new()
	self.debugger = debugger.new(self.serverEntity)
	self.targeter = targeter.new(self.serverEntity)
	self.random = Random.new(serverEntity.id)
	
	-- Setup events and such:
	self:setup()
	-- Activate the Spiri right away:
	self:activate()

    return self
end

function Spiri:setup()
	-- Died event:
	local diedEvent = self.events:add("died")
	-- Tick event:
	self.events:add("tick")

	task.spawn(function()
		while true do
			if self.body == nil or self.body.Parent == nil then
				diedEvent:Fire()
				return
			else
				if self.humanoid then
					if self.humanoid.Health <= 0 then
						diedEvent:Fire()
						return
					end
				end
			end
			task.wait(self.reflex)
		end
	end)
end

--[[
	Activate the spiri.
]]
-- TODO: Make the main loop global which is more performant , having one loop for all spiris is very beneficial
function Spiri:activate()
	self.actionQueue:activate()
	self.active = true
	local tickEvent = self.events:get("tick")

	task.spawn(function()
		while true do
			tickEvent:Fire()
			task.wait(self.reflex)
		end
	end)
end

-- Deactivate the spiri:
function Spiri:dectivate()
	self.active = false
end

return Spiri