local Human = require(script.Parent.Parent.Subclasses.Human)

Citizen = {}
Citizen.__index = Citizen
setmetatable(Citizen, Human)

function Citizen:scream()
    local target = self.targeter:findClosest()
    if self.targeter:getDistance(target,self.body) > 20 then
        return false
    end
    local start,finish = self.actionQueue:add("scream",5,true)
    if not start then
        return false
    end
    start:Connect(function()
        self.debugger:chat("AAAAAh!")
        self.movement:jump()
        task.wait(1)
        finish:Fire()
    end)
    return true
end

function Citizen:wander()
    local start,finish,abort,isAborted = self.actionQueue:add("wander",1)
    if not start then
        return false
    end

    -- Define a start function to actually execute the action
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

    -- Define abortion to make sure the action is interrupted in favor of higher priority ones
    abort:Connect(function()
        self.movement:halt()
    end)
    return true
end

function Citizen:start()
    self.flags:set("Wandering",false)

    self.events.get("tick"):Connect(function()
        -- The tick event is fired every self.reflex
        -- Every tick check if the Citizen is free to walk around randomly (see Movement component)
        if self.actionQueue:isFree("wander") then
            self:wander()            
        end

        -- Every tick check if the Citizen is free to scream, which can only be done every 10 seconds (see Coolers component)
        if self.actionQueue:isFree("scream") and self.cooler:isReady("scream") then
            if self:scream() then
                self.cooler:heat("scream",10)
            end
        end
    end)
end

function Citizen.new(body,config)
    local self = Human.new(body,config)
    setmetatable(self, Citizen)

    self:start()

    return self
end

return Citizen