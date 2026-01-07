local SUCCESS = 1

local Task = {
	run = function(spiri)
		spiri.movement:stroll(true)
		return SUCCESS
	end,
}

return Task
