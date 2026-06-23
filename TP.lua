local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local HEIGHT_OFFSET = 5
local TIMER_DURATION = 45
local CORRECT_KEY = "XKR"

local function TeleportTo(x, y, z)
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    root.CFrame = CFrame.new(Vector3.new(x, y + HEIGHT_OFFSET, z))
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== KEY SYSTEM ====================
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 320, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -160, 0.35, 0)
KeyFrame.BackgroundColor3 = Color3.from