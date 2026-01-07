local Flags = {}
Flags.__index = Flags

-- Typechecking:
type flag = {[string]: boolean}

local function isFlagKeyValid(flagKey : string)
    if typeof(flagKey) ~= "string" then
        flagKey = tostring(flagKey)
        if not flagKey or flagKey == "" then
            error("''flagKey'' must be a non-empty string.")
        end
    end
    return true
end

function isFlagValueValid(flagValue : boolean)
    if type(flagValue) ~= "boolean" then
        error("''value'' must be a boolean.")
    end
    return true
end

function Flags:reset()
    for key,_ in pairs(self.set) do
        self.dict[key] = false;
    end
end

function Flags:set(flagKey : string,flagValue : boolean)
    if isFlagKeyValid(flagKey) and isFlagValueValid(flagValue) then
        self.dict[flagKey] = flagValue; 
    end
end

function Flags:get(flagKey : string)
    if isFlagKeyValid(flagKey) then
        return self.dict[flagKey] 
    end
    return false
end

function Flags.new()
    local self = setmetatable({}, Flags)

    self.dict = {
        Moving = false;
        Attacking = false;
    } :: {flag}; 

    return self
end

return Flags