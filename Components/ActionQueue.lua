local ActionQueue = {}
ActionQueue.__index = ActionQueue

-- Dependancies --
local Action = require(script.Parent.Action)
-- How big the difference in priority has to be for an action to be aborted in favor of another one, feel free to customize.
local ABORTION_THRESHOLD = 1

export type QueueEntryType = {
    action: Action.ActionType,priority: number,expirationTime: number
}

local function isActionKeyValid(actionKey : string)
    if typeof(actionKey) ~= "string" then
        actionKey = tostring(actionKey)
        if not actionKey or actionKey == "" then
            error("''actionKey'' must be a non-empty string.")
        end
    end
    return true
end

function isActionPriorityValid(actionPriority : number)
    if typeof(actionPriority) ~= "number" then
        error("''actionPriority'' must be a number.")
    end
    return true
end

function ActionQueue:reset()
    for key,_ in pairs(self.set) do
        self.queue[key] = nil;
    end
end

function ActionQueue:add(actionKey: string, actionPriority: number, uninterruptible: boolean)
    if self.queue[actionKey] then
        warn("''"..actionKey.."'' is already in the queue.",warn(self.queue))
        return false
    end
    if isActionKeyValid(actionKey) and isActionPriorityValid(actionPriority) then
        local action = Action.new() 
        self.queue[actionKey] = {action = action,priority = actionPriority,uninterruptible = uninterruptible}; 
        return action.startSignal,action.finishSignal,action.abortSignal,action.isAborted
    end
end

function ActionQueue:getHighestPriorityAction()
    local highestPriorityAction = nil
    for key,entry in pairs(self.queue) do
        if highestPriorityAction == nil or entry.priority > highestPriorityAction.priority then
            highestPriorityAction = entry
        end
    end
    return highestPriorityAction
end

function ActionQueue:activate()
    task.spawn(function()
        while true do
            if next(self.queue) == nil then
                task.wait()
                continue
            end
            -- Handle actions in queue.
            local bestEntry = nil; local bestEntryKey
            for entryKey,entry in pairs(self.queue) do
                if bestEntry == nil or entry.priority > bestEntry.priority then
                    bestEntry = self.queue[entryKey]
                    bestEntryKey = entryKey
                end
            end
            -- Let the code that handles the action know it can start.
            bestEntry.action.startSignal:Fire()
            -- Wait for the action to finish, or a very high priority action to pass/abort to the next one.
            local function checkAbortion()
                local highestPriorityAction = self:getHighestPriorityAction()
                if highestPriorityAction then
                   local difference = highestPriorityAction.priority - bestEntry.priority
                   if not bestEntry.uninterruptible and difference > ABORTION_THRESHOLD then
                        return true
                   end
                end
                return false
            end
            repeat task.wait() until bestEntry.action.ended or checkAbortion()
            table.clear(self.queue[bestEntryKey])
            self.queue[bestEntryKey] = nil
            print(self.queue)
        end
    end)
end

function ActionQueue:isFree(name)
    return not self.queue[name]
end

function ActionQueue.new()
    local self = setmetatable({}, ActionQueue)

    self.queue = {} :: {QueueEntryType}; 

    return self
end

return ActionQueue