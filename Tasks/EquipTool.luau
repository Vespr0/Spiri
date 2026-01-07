local SUCCESS = 1

local Task = {
	run = function(spiri, index)
		local toolIndex = index or 1

		spiri.serverEntity.backpack:equipTool(toolIndex)
		return SUCCESS
	end,
}

return Task
