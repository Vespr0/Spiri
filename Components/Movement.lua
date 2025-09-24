local Movement = {}
Movement.__index = Movement

function Movement:moveTo(position)
	self.body.Humanoid:MoveTo(position)
	self.body.Humanoid.MoveToFinished:Wait()
end

function Movement:stroll(backwards: boolean, vectorLenght: number)
	vectorLenght = vectorLenght or 8

	local cframe = self.body.PrimaryPart.CFrame
	local position = self.body.PrimaryPart.Position + Vector3.yAxis * (self.body.PrimaryPart.Size.Y / 2 + 1)

	local lookVector = if backwards then -cframe.LookVector else cframe.LookVector
	local rightVector = cframe.RightVector
	local vectors = {
		lookVector,
		(lookVector + rightVector).Unit,
		(lookVector - rightVector).Unit,
		rightVector,
		-rightVector,
	}

	for i = 1, #vectors do
		local vector = vectors[i]
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = { self.body } -- TODO: self.Target is not defined, need to fix this
		local raycast = workspace:Raycast(position, vector * vectorLenght, raycastParams)
		if not raycast then
			self:moveTo(position + vector * vectorLenght)
			return
		end
	end
end

function Movement:setupLookAt()
	-- AlignOrientation
	self.AlignOrientation = Instance.new("AlignOrientation")
	self.AlignOrientation.Name = "LookAtAlignOrientation"
	self.AlignOrientation.Parent = self.body.PrimaryPart
	self.AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	self.AlignOrientation.PrimaryAxisOnly = true
	self.AlignOrientation.MaxTorque = 50000
	self.AlignOrientation.Responsiveness = 50
	self.AlignOrientation.MaxAngularVelocity = 5
	self.AlignOrientation.Enabled = false
	-- Attachment
	self.AlignOrientation.Attachment0 = self.body.PrimaryPart:FindFirstChild("RootAttachment")
	self.AlignOrientation.Attachment0.Axis = Vector3.new(0, 0, -1)

	-- self.lookAt_Connection = TiltAt.Setup(self.body)
end

function Movement:jump()
	self.body.Humanoid.Jump = true
end

function Movement:halt()
	self:stopLookAt()
	self.body.Humanoid:MoveTo(self.body.PrimaryPart.Position)
end

-- function Movement:lookAtPosition(position)
-- 	local vector = CFrame.lookAt(self.body.PrimaryPart.Position,Vector3.new(position.X,self.body.PrimaryPart.Position.Y,position.Z)).LookVector
-- 	self:lookAt(vector)
-- end

function Movement:lookAt(direction)
	self.AlignOrientation.Enabled = true
	self.AlignOrientation.PrimaryAxis = Vector3.new(direction.X, 0, direction.Z)
end

function Movement:stopLookAt()
	self.AlignOrientation.Enabled = false
end

function Movement.new(body)
	local self = setmetatable({}, Movement)

	self.body = body

	self:setupLookAt()

	return self
end

function Movement:destroy()
	self.AlignOrientation:Destroy()
end

return Movement
