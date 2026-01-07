-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Dependencies --
local BTree = require(ReplicatedStorage.Packages._Index["onv-il_btreesv5@5.0.18"].btreesv5)
local Components = script.Parent.Components
local movement = require(Components.Movement)
local flags = require(Components.Flags)
local events = require(Components.Events)
local debugger = require(Components.Debugger)
local targeter = require(Components.Targeter)
local cooler = require(ReplicatedStorage.ClockworkShared.Utility.Cooler)
local Trove = require(ReplicatedStorage.Packages.trove)

-- Types --
local Types = ReplicatedStorage.ClockworkShared.Types
local TypeEntity = require(Types.TypeEntity)
type ServerEntity = TypeEntity.ServerEntity

export type SpiriConfig = {
	reflex: number?,
}

local Spiri = {}
Spiri.__index = Spiri

function Spiri.new(serverEntity: ServerEntity, treeName: string, config: SpiriConfig)
	assert(serverEntity, "ServerEntity is required for Spiri")
	assert(treeName, "treeName is required for Spiri")
	config = config or {}
	local self = setmetatable({}, Spiri)

	self.active = false
	self.reflex = config.reflex or 0.3
	self.treeName = treeName
	self.serverEntity = serverEntity
	self.body = serverEntity.rig
	self.humanoid = serverEntity.humanoid
	self.root = serverEntity.root

	self.movement = self.humanoid and movement.new(self.body) or nil
	self.flags = flags.new()
	self.events = events.new()
	self.trove = Trove.new()
	self.cooler = cooler.new()
	self.debugger = debugger.new(self.serverEntity)
	self.targeter = targeter.new(self.serverEntity)
	self.random = Random.new(serverEntity.id)
	self.blackboard = {}

	self:setup()
	self:activate()

	return self
end

function Spiri:setup()
	-- The serverEntity already handles its own death logic and fires this event.
	-- We just need to listen for it and clean up the Spiri instance.
	self.trove:Add(self.serverEntity.events.Died:Connect(function()
		self:destroy()
	end))

	if self.serverEntity.backpack then
		self.trove:Add(self.serverEntity.backpack.events.ToolEquip:Connect(function(tool)
			if self.onToolEquipped then
				self:onToolEquipped(tool)
			end
		end))
	end
end

function Spiri:activate()
	self.active = true
	local treeFolder = ServerStorage.Trees:FindFirstChild(self.treeName)
	if not treeFolder then
		warn("No behavior tree found for " .. self.treeName)
		return
	end
	self.btree = BTree:Create(treeFolder)

	task.spawn(function()
		while self.active do
			self.btree:run(self)
			task.wait(self.reflex)
		end
	end)
end

function Spiri:dectivate()
	self.active = false
end

function Spiri:destroy()
	if not self.active then
		return
	end

	self:dectivate()

	-- TODO: Clean up tree
	-- TODO: Clean up tree
	self.events:destroy()
	self.debugger:destroy()
	self.movement:destroy()
	self.trove:Destroy()
end

return Spiri
