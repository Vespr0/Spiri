local SUCCESS = 1

local Task = {
	run = function(spiri)
		spiri.serverEntity.backpack:unequipTool()
		return SUCCESS
	end,
}

return Task
