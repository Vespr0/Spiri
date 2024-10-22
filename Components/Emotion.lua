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

local MOTIVATIONS = {
    Neutral = 0,
    Energetic = 1, -- AKA: Excited.
    Lethargic = 2 -- AKA: Lacks energy.
}

function Emotion:getMorale()
    -- Morale is from 0 to 5, 0 being destroyed, 5 being ready to die for anything.

    local moodPoints = if self.Mood == MOODS.Happy then 1 else 0
    local fatiguePoints = 2 - (math.max(0,self.Fatigue.Mental - 5)/5 + math.max(0,self.Fatigue.Physical - 5)/5)

    local atmosphereBoosts = {
        [ATMOSPHERES.Relaxing] = 1,
        [ATMOSPHERES.War] = 0,
        [ATMOSPHERES.Joyful] = 2,
    }
    warn(atmosphereBoosts)
    local atmospherePoints = if table.find(atmosphereBoosts, self.Atmosphere) then atmosphereBoosts[self.Atmosphere] else 1
    
    local motivationBoosts = {
        [MOTIVATIONS.Energetic] = 1,
        [MOTIVATIONS.Lethargic] = 0,
    }
    local motivationPoints = if table.find(motivationBoosts, self.Motivation) then motivationBoosts[self.Motivation] else 1

    local sum = moodPoints + fatiguePoints + atmospherePoints + motivationPoints

    local morale = math.clamp(sum, 0, 5)

    return morale
end

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

function Emotion:boostFatigue(type)
    if type == "Mental" then
        self.Fatigue.Mental = math.clamp(self.Fatigue.Mental + 1,0,5)
    elseif type == "Physical" then
        self.Fatigue.Physical = math.clamp(self.Fatigue.Physical + 1,0,5)
    end
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

    self.Fatigue = { 
        Mental = 0, -- From 0,5
        Physical = 0 -- From 0,5
    }

    return self
end

return Emotion