local Targeter = {}
Targeter.__index = Targeter

local Entities = workspace.Entities

function Targeter:getDistance(entityA,entityB)
    return (entityA.PrimaryPart.Position - entityB.PrimaryPart.Position).Magnitude
end

function Targeter:findClosest()
    local bestEntity = nil

    for _,entity in pairs(Entities:GetChildren()) do
        if entity == self.body then
            continue
        end

        if entity:FindFirstChild("Humanoid") then
            if entity.Humanoid.Health > 0 then
                if entity:FindFirstChild("HumanoidRootPart") then
                    if bestEntity == nil then
                        bestEntity = entity
                    end
                    local distance = self:getDistance(entity,self.body)
                    local bestDistance = self:getDistance(bestEntity,self.body)
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

    return bestEntity
end

function Targeter.new(body)
	local self = setmetatable({}, Targeter)
	
	self.body = body
	self.root = body.PrimaryPart
	self.humanoid = body:FindFirstChild("Humanoid") :: Humanoid or error("Movement class requires a humanoid")

    self.target = nil
    self.range = 100

	return self
end

return Targeter