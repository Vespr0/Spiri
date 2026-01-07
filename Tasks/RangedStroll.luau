local SUCCESS, FAIL, RUNNING = 1, 2, 3

local Task = {
	run = function(spiri)
		if spiri.blackboard.target then
			local distance = spiri.targeter:getDistance(spiri.blackboard.target, spiri.body)
			if distance <= 10 then
				task.spawn(function()
					spiri.movement:stroll(true)
				end)
				return SUCCESS
			elseif distance > 30 then
				task.spawn(function()
					spiri.movement:stroll(false)
				end)
				return SUCCESS
			else
				return SUCCESS
			end
		else
			return SUCCESS
		end
	end,
}

return Task
