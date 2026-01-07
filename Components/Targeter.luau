local Targeter = {}
Targeter.__index = Targeter

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Game = require(ReplicatedStorage.ClockworkShared.Utility.Game)
local CombatUtility = require(ReplicatedStorage.ClockworkShared.Abilities.CombatUtility)
local ServerEntity = require(script.Parent.Parent.Parent.Parent.Entities.ServerEntity)

function Targeter:getDistanceRaw(positionA, positionB)
	return (positionA - positionB).Magnitude
end

function Targeter:getDistance(entityA, entityB)
	return self:getDistanceRaw(entityA.PrimaryPart.Position, entityB.PrimaryPart.Position)
end

function Targeter:findClosest()
	local bestEntity = nil
	local rigs = CollectionService:GetTagged(Game.Tags.Entity)

	for _, rig in pairs(rigs) do
		if rig == self.serverEntity.rig then
			continue
		end

		local otherEntity = ServerEntity.Get(rig:GetAttribute("ID"))
		if not CombatUtility.IsEnemy(self.serverEntity, otherEntity) then
			continue
		end

		if rig:FindFirstChild("Humanoid") then
			if rig.Humanoid.Health > 0 then
				if rig:FindFirstChild("HumanoidRootPart") then
					if bestEntity == nil then
						bestEntity = rig
					end
					local distance = self:getDistance(rig, self.serverEntity.rig)
					local bestDistance = self:getDistance(bestEntity, self.serverEntity.rig)
					if distance > self.range then
						continue
					end
					if distance < bestDistance then
						bestEntity = rig
					end
				end
			end
		end
	end

	if bestEntity then
		local direction = CFrame.lookAt(self.serverEntity.root.Position, bestEntity.PrimaryPart.Position).LookVector
		direction = Vector3.new(direction.X, 0, direction.Z)

		return bestEntity, direction
	end

	return nil
end

function Targeter.new(serverEntity)
	local self = setmetatable({}, Targeter)

	self.serverEntity = serverEntity

	self.target = nil
	self.range = 50

	return self
end

return Targeter
