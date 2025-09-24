local SUCCESS, FAIL, RUNNING = 1, 2, 3

local Task = {
	run = function(spiri)
		local randomVector = Vector3.new(spiri.random:NextInteger(-10, 10), 0, spiri.random:NextInteger(-10, 10)).Unit
		spiri.movement:lookAt(randomVector)
		spiri.movement:stroll()
		return SUCCESS
	end,
}

return Task
