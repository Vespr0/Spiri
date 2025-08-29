local Cursor = {}
Cursor.__index = Cursor

-- Dependencies --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Fusion = require(Packages.fusion)
local Signal = require(Packages.signal)

export type CursorType = {
    segments: { [string]: Frame },
    setSpreadDistance: (number) -> (),
    destroy: () -> ()
}

-- Default segment properties
local SEGMENT_SIZE = UDim2.fromOffset(2, 2)
local SEGMENT_COLOR = Color3.fromRGB(255, 255, 255)
local BASE_OFFSET = 4 -- Base distance from center in pixels
local LARGE_MULTIPLIER = 1.5 -- Multiplier for the larger right segment

function Cursor:createSegment(name, positionOffset, sizeMultiplier)
    sizeMultiplier = sizeMultiplier or 1
    
    local segment = Instance.new("Frame")
    segment.Name = name
    segment.Size = SEGMENT_SIZE * sizeMultiplier
    segment.BackgroundColor3 = SEGMENT_COLOR
    segment.BorderSizePixel = 0
    segment.AnchorPoint = Vector2.new(0.5, 0.5)
    segment.Position = UDim2.fromScale(0.5, 0.5) + positionOffset
    
    return segment
end

function Cursor:setSpreadDistance(distance)
    local spread = distance * BASE_OFFSET
    
    -- Update segment positions with Fusion tween
    self.segments.Top.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(0, -spread)
    self.segments.Bottom.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(0, spread)
    self.segments.Left.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(-spread, 0)
    self.segments.Right.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(spread * LARGE_MULTIPLIER, 0)
end

function Cursor:destroy()
    for _, segment in pairs(self.segments) do
        if segment then
            segment:Destroy()
        end
    end
    setmetatable(self, nil)
    table.clear(self)
end

function Cursor.new(parentGui)
    local self = setmetatable({}, Cursor)
    
    self.segments = {
        Top = self:createSegment("Top", UDim2.fromOffset(0, -BASE_OFFSET)),
        Bottom = self:createSegment("Bottom", UDim2.fromOffset(0, BASE_OFFSET)),
        Left = self:createSegment("Left", UDim2.fromOffset(-BASE_OFFSET, 0)),
        Right = self:createSegment("Right", UDim2.fromOffset(BASE_OFFSET, 0), LARGE_MULTIPLIER)
    }
    
    -- Add segments to parent GUI
    for _, segment in pairs(self.segments) do
        segment.Parent = parentGui
    end
    
    return self :: CursorType
end

return Cursor