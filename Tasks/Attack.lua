local SUCCESS, FAIL, RUNNING = 1, 2, 3

local Task = {
	run = function(spiri)
		if not spiri.attack or not spiri.blackboard.target then
			return FAIL
		end

		spiri:attack()

		return SUCCESS
	end,
}

return Task
