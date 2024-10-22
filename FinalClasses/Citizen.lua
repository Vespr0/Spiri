local Creature = require(script.Parent.Parent.Spiri.Subclasses.Creature)

NPC = {}
NPC.__index = NPC
setmetatable(NPC, Creature)

function NPC:scream()
    local target = self.targeter:findClosest()
    if self.targeter:getDistance(target,self.body) > 20 then
        return false
    end
    local start,finish = self.actionQueue:add("scream",5,true)
    if not start then
        return false
    end
    start:Connect(function()
        self.debugger:chat("AAAAAAAAAA")
        self.movement:jump()
        task.wait(1)
        self.debugger:chat("Im done screaming lol")
        finish:Fire()
    end)
    return true
end

function NPC:wander()
    local start,finish,abort,isAborted = self.actionQueue:add("wander",1)
    if not start then
        return false
    end
    start:Connect(function()
        self.flags:set("Wandering",true)
        
        for i = 1,5 do
            if isAborted() then
                break
            end
            local randomVector = Vector3.new(math.random(-5,5),0,math.random(-5,5)).Unit
            local pos = self.root.Position+randomVector
            self.movement:lookAt(pos)
            task.wait(1/3)
            self.movement:stroll()
        end
        
        self.flags:set("Wandering",false)
        finish:Fire()
    end)
    abort:Connect(function()
        self.movement:halt()
    end)
    return true
end

function NPC:start()
    self.flags:set("Wandering",false)

    self.events.get("tick"):Connect(function()
        if self.actionQueue:isFree("wander") then
            self:wander()            
        end
        task.wait(self.reflex)
    end)

    self.events.get("tick"):Connect(function()
        if self.actionQueue:isFree("scream") and self.cooler:isReady("scream") then
            if self:scream() then
                self.cooler:heat("scream",10)
            end
        end
        task.wait(self.reflex)
    end)
end

function NPC.new(body,config)
    local self = Creature.new(body,config)
    setmetatable(self, NPC)

    self:start()

    return self
end

return NPC