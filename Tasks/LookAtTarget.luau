local SUCCESS, FAIL, RUNNING = 1, 2, 3

local Task = {
	run = function(spiri)
		if spiri.blackboard.targetDirection then
			spiri.movement:lookAt(spiri.blackboard.targetDirection)
		end

		return SUCCESS
	end,
}

return Task
