local SUCCESS, FAIL, RUNNING = 1, 2, 3

local Task = {
	run = function(spiri)
		local target, direction = spiri.targeter:findClosest()
		if target then
			spiri.blackboard.target = target
			spiri.blackboard.targetDirection = direction
			spiri.blackboard.hasTarget = true
			return SUCCESS
		else
			spiri.blackboard.target = nil
			spiri.blackboard.targetDirection = nil
			spiri.blackboard.hasTarget = false
			return FAIL
		end
	end,
}

return Task
