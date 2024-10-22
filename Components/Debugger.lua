local Debugger = {}
Debugger.__index = Debugger

local Debris = game:GetService("Debris")
local AssetsDealer = require(game:GetService("ReplicatedStorage").Shared.AssetsDealer)

function Debugger:chat(message : string)
    local label = self.TextTemplate:Clone()
    label.Text = message
    label.Parent = self.Ui.Frame

    local lifetime = 4 + string.len(message)/8
    Debris:AddItem(label,lifetime)
end

function Debugger:setup(body)
    local asset = AssetsDealer.GetUiElement("Misc/Debugger")
    self.Ui = asset:FindFirstChildOfClass("Attachment").Gui:Clone()
    self.Ui.Parent = body:WaitForChild("Head")
    self.TextTemplate = self.Ui.Frame.Label:Clone()
    -- Clean up
    asset:Destroy()
    self.Ui.Frame.Label:Destroy()
end

function Debugger.new(body)
    local self = setmetatable({}, Debugger)

    self.Ui = nil
    self:setup(body)

    return self
end

return Debugger