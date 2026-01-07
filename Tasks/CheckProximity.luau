local SUCCESS, FAIL = 1, 2

local Task = {
	run = function(spiri, taskConfig)
		if not spiri.blackboard.target then
			return FAIL
		end
        
		local target = spiri.blackboard.target
		
		local currentdist = spiri.targeter:getDistance(target, spiri.body)
		
		if currentdist <= 5 then
			return SUCCESS
		end

		return FAIL
	end,
}

return Task
