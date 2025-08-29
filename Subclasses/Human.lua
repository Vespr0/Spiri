local Spiri = require(script.Parent.Parent.SpiriBase)
local Emotion = require(script.Parent.Parent.Components.Emotion)

Human = {}
Human.__index = Human
setmetatable(Human, Spiri)

function Human.new(serverEntity, config)
    local self = Spiri.new(serverEntity, config)
    setmetatable(self, Human)

    self.Emotion = Emotion.new()

    return self
end

return Human