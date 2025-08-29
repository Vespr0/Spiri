local Human = require(script.Parent.Parent.Subclasses.Human)

Soldier = {}
Soldier.__index = Soldier
setmetatable(Soldier, Human)

-- function Soldier:attack()
--     local target = self.targeter:findClosest()
--     if not target then
--         return false
--     end

--     -- Queue the attack action with a high priority
--     local start, finish = self.actionQueue:add("attack", 10, true)
--     if not start then
--         return false
--     end

--     start:Connect(function()
--         self.debugger:chat("Take that!")
--         -- Simulate an attack animation or effect
--         -- For example, you could apply damage to the target here
--         task.wait(0.5) -- Simulate attack duration
--         finish:Fire()
--     end)

--     return true
-- end

function Soldier:patrol()
    local start, finish, abort, isAborted = self.actionQueue:add("patrol", 2)
    if not start then
        return false
    end

    start:Connect(function()
        -- This is a simplified patrol. In reality, you'd move between specific waypoints.
        -- Move to a random nearby position
        local randomVector = Vector3.new(self.random:NextInteger(-10,10), 0, self.random:NextInteger(-10,10)).Unit
        local pos = self.root.Position + randomVector * 20

        self.movement:lookAt(randomVector)
        task.wait(1/2)
        self.movement:stroll() -- Move to the position
        -- self.movement:moveTo(pos)

        finish:Fire()
    end)

    abort:Connect(function()
        self.movement:halt()
    end)

    return true
end

function Soldier:start()
    self.events:get("tick"):Connect(function()
        -- Check if the soldier is free to patrol
        -- if self.actionQueue:isFree("patrol") then
        --     self:patrol()
        -- end

        local target, direction = self.targeter:findClosest()
        if target then
            self.movement:lookAt(direction)
        end

        -- -- Check if the soldier is free to attack and there's a target nearby
        -- if self.actionQueue:isFree("attack") then
        --     local target = self.targeter:findClosest()
        --     if target and self.targeter:getDistance(target, self.body) <= 15 then
        --         if self:attack() then
        --             -- Attack cooldown could be implemented here if needed
        --         end
        --     end
        -- end
    end)
end

function Soldier.new(serverEntity, config)
    local self = Human.new(serverEntity, config)
    setmetatable(self, Soldier)

    self:start()

    return self
end

return Soldier