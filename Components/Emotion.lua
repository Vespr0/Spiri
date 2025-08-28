local Emotion = {}
Emotion.__index = Emotion

local MOODS = {
    Neutral = 0, 
    Happy = 1, 
    Sad = 2,
    Angry = 3 
}

local ATMOSPHERES = {
    Neutral = 0,
    War = 1, -- AKA: Chaotic and violent. EX: A war zone.
    Sacred = 2, -- AKA: Respectful, delicate. EX: A religious place.
    Relaxing = 3, -- AKA: Calm and peaceful. EX: A lake or a park.
    Joyful = 4 -- AKA: Exciting, happy. EX: A party.
}

function Emotion:getMood()
    local anger = self.Mood.Anger
    local happiness = self.Mood.Happiness
    local sadness = self.Mood.Sadness

    local largest = math.max(anger,happiness,sadness)

    if largest == anger then
        return MOODS.Angry
    elseif largest == happiness then
        return MOODS.Happy
    elseif largest == sadness then
        return MOODS.Sad
    end
end

function Emotion:boostMood(type)
    if self.Mood[type] then
        self.Mood[type] = math.clamp(self.Mood[type] + 1,0,5)
    end
end

function Emotion:setAtmosphere(type)
    self.Atmosphere = ATMOSPHERES[type]
end

function Emotion.new()
    local self = setmetatable({}, Emotion) 

    self.Atmosphere = 0
    self.Motivation = 0

    self.Mood = {
        Anger = 0, -- From 0,5
        Happiness = 0, -- From 0,5  
        Sadness = 0 -- From 0,5
    }

    return self
end

return Emotion