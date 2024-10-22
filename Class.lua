local SPIRI = {}
SPIRI.__index = SPIRI

-- Services --
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[[
    __  ____            _          _  __
   / / / ___|   _ __   (_)  _ __  (_) \ \
  | |  \___ \  | '_ \  | | | '__| | |  | |
 < <    ___) | | |_) | | | | |    | |   > >
  | |  |____/  | .__/  |_| |_|    |_|  | |
   \_\         |_|                    /_/

   Spiri - EliteEngineer(CasualEngineer0)

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
local cooler = require(Components.Cooler)

-- Class --

--[[
 	Create a new Spiri, it takes control of a body, which can be any rig
 	as long as it has a humanoid.
]]
function SPIRI.new(body,config)
	config = config or {}
	local self = setmetatable({}, SPIRI)
	-- Abstract propieties:
	self.active = false
	self.reflex = .2 -- Time delay for every iteration of the main loop.
	-- Physical propieties:
	self.body = body
	self.humanoid = body:WaitForChild("Humanoid",5) :: Humanoid or nil
	self.root = body.PrimaryPart :: BasePart or nil
	-- Interfaces:
	self.movement = self.humanoid and movement.new(body) or nil -- Movement interface will only be avaiable on humanoid:
	self.flags = flags.new()
	self.events = events.new()
	self.actionQueue = actionQueue.new()
	self.cooler = cooler.new()
	self.debugger = debugger.new(body)
	self.targeter = targeter.new(body)
	-- Setup events and such:
	self:setup()
	-- Activate the Spiri right away:
	self:activate()
	return self
end

function SPIRI:setup()
	-- Died event:
	local diedEvent = self.events:add("died")

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
function SPIRI:activate()
	self.actionQueue:activate()
	self.active = true

	-- Tick event:
	local tickEvent = self.events:add("tick")

	task.spawn(function()
        while true do
            tickEvent:Fire()
            task.wait(self.reflex)
        end
    end)
end

-- Deactivate the spiri:
function SPIRI:dectivate()
	self.active = false
end

return SPIRI