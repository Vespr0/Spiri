local Cooler = {}
Cooler.__index = Cooler

function Cooler:heat(name,time)
    task.spawn(function()
        self.dict[name] = true
        task.wait(time)
        self.dict[name] = false
    end)
end

function Cooler:isReady(name)
    return not self.dict[name]
end

function Cooler.new()
    local self = setmetatable({}, Cooler)

    self.dict = {}

    return self
end

return Cooler