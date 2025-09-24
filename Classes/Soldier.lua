local Human = require(script.Parent.Parent.Subclasses.Human)

Soldier = {}
Soldier.__index = Soldier
setmetatable(Soldier, Human)

function Soldier:attack()
	local backpack = self.serverEntity.backpack
	if not backpack or not backpack.equippedTool then
		return false
	end

	local tool = backpack.equippedTool
	local toolName = tool.Name
	local toolIndex = tool:GetAttribute("Index")

	-- Assuming the ability is always a "Projectile" type for now
	-- This could be made more dynamic later if needed
	local mindController = backpack.abilities:getMindController(toolName, "Projectile", toolIndex)

	if mindController then
		local direction = self.blackboard.targetDirection or self.body.CFrame.LookVector
		local startPosition = self.root.Position + Vector3.yAxis * 1.5 -- Muzzle position approximation
		mindController:Fire("Fire", direction, startPosition)
		return true
	end

	return false
end

function Soldier.new(serverEntity, treeName, config)
	local self = Human.new(serverEntity, treeName, config)
	setmetatable(self, Soldier)

	return self
end

return Soldier
