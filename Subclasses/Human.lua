local Spiri = require(script.Parent.Parent.Class)
local Emotion = require(script.Parent.Parent.Components.Emotion)

Human = {}
Human.__index = Human
setmetatable(Human, Spiri)

function Human.new(body,config)
    local self = Spiri.new(body,config)
    setmetatable(self, Human)

    self.Emotion = Emotion.new()

    return self
end

return Human