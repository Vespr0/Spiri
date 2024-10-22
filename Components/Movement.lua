local Movement = {}
Movement.__index = Movement

function Movement:moveTo(position)
	self.humanoid:MoveTo(position)
	self.humanoid.MoveToFinished:Wait()
end

function Movement:stroll(backwards: boolean,vectorLenght: number)
	vectorLenght = vectorLenght or 8

	local cframe = self.root.CFrame
	local position = self.root.Position 

	local lookVector = if backwards then -cframe.LookVector else cframe.LookVector
	local rightVector = cframe.RightVector
	local vectors = {
		lookVector;
		(lookVector+rightVector).Unit;
		(lookVector-rightVector).Unit;
		rightVector;
		-rightVector;
	}

	for i = 1,#vectors do
		local vector = vectors[i]
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = {self.Rig,self.Target}
		local raycast = workspace:Raycast(position,vector*vectorLenght,raycastParams)
		if not raycast then
			self:moveTo(position+vector*vectorLenght)
			return
		end
	end
end

function Movement:setupLookAt()
	self.lookAtOn = false
	self.lookAt_Constraint = Instance.new("AlignOrientation")
	self.lookAt_Constraint.Parent = self.root
	self.lookAt_Constraint.Mode = Enum.OrientationAlignmentMode.OneAttachment
	self.lookAt_Constraint.PrimaryAxisOnly = true
	self.lookAt_Constraint.MaxTorque = 50000
	self.lookAt_Constraint.Responsiveness = 100
	self.lookAt_Constraint.MaxAngularVelocity = 50
	self.lookAt_Attachment = Instance.new("Attachment")
	self.lookAt_Attachment.Parent = self.root
	self.lookAt_Attachment.Orientation = Vector3.new(0,90,0)
	self.lookAt_Constraint.Attachment0 = self.AO_Attachment
	--self.lookAt_Connection = TiltAt.Setup(self.Rig)
end

function Movement:jump()
	self.humanoid.Jump = true
end

function Movement:halt()
	self:stopLookAt()
	self.humanoid:MoveTo(self.root.Position)
end

function Movement:turnTo(position)
	self.lookAt_Constraint.Enabled = true
	local vector = CFrame.lookAt(self.root.Position,Vector3.new(position.X,self.root.Position.Y,position.Z)).LookVector	
	self.lookAt_Constraint.PrimaryAxis = vector
end

function Movement:stopLookAt()
	self.lookAt_Constraint.Enabled = false
	self.lookAtOn = false
end

function Movement:lookAt(position)
	self.lookAtOn = true
	self:turnTo(position)
end

function Movement.new(body)
	local self = setmetatable({}, Movement)
	
	self.body = body
	self.root = body.PrimaryPart
	self.humanoid = body:FindFirstChild("Humanoid") :: Humanoid or error("Movement class requires a humanoid")
	
	self:setupLookAt()

	return self
end

return Movement