local Targeter = {}
Targeter.__index = Targeter

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Game = require(ReplicatedStorage.Utility.Game)

function Targeter:getDistanceRaw(positionA,positionB)
    return (positionA - positionB).Magnitude
end

function Targeter:getDistance(entityA,entityB)
    return self:getDistanceRaw(entityA.PrimaryPart.Position,entityB.PrimaryPart.Position)
end

function Targeter:findClosest()
    local bestEntity = nil
    local entities = CollectionService:GetTagged(Game.Tags.Entity)

    for _,entity in pairs(entities) do
        if entity == self.serverEntity.rig then
            continue
        end

        if entity:FindFirstChild("Humanoid") then
            if entity.Humanoid.Health > 0 then
                if entity:FindFirstChild("HumanoidRootPart") then
                    if bestEntity == nil then
                        bestEntity = entity
                    end
                    local distance = self:getDistance(entity,self.serverEntity.rig)
                    local bestDistance = self:getDistance(bestEntity,self.serverEntity.rig)
                    if distance > self.range then
                        continue
                    end
                    if distance < bestDistance then
                        bestEntity = entity
                    end
                end
            end
        end
    end

    if bestEntity then
        local direction = CFrame.lookAt(self.serverEntity.root.Position, bestEntity.PrimaryPart.Position).LookVector
        direction = Vector3.new(direction.X,0,direction.Z)

        return bestEntity, direction
    end

    return nil
end

function Targeter.new(serverEntity)
	local self = setmetatable({}, Targeter)
	
	self.serverEntity = serverEntity

    self.target = nil
    self.range = 100

	return self
end

return Targeter