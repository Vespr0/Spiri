local Spiri = require(script.Parent.Parent)
local Emotion = require(script.Parent.Parent.Emotion)

Creature = {}
Creature.__index = Creature
setmetatable(Creature, Spiri)

function Creature.new(body,config)
    local self = Spiri.new(body,config)
    setmetatable(self, Creature)

    self.Emotion = Emotion.new()

    return self
end

return Creature