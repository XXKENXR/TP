local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local HEIGHT_OFFSET = 5

local function TeleportTo(x, y, z)
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    root.CFrame = CFrame.new(Vector3.new(x, y + HEIGHT_OFFSET, z))
end

-- TP AUTOMÁTICO al cargar
TeleportTo(7961, 715, 5144)

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TPGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Title.Text = "Teleports"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Temporizador 40 segundos
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(1, 0, 0, 35)
TimerLabel.Position = UDim2.new(0, 0, 0, -38)
TimerLabel.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.TextScaled = true
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.Text = "Temporizador: 40s"
TimerLabel.Parent = MainFrame

local timeLeft = 40
spawn(function()
    while true do
        TimerLabel.Text = "Temporizador: " .. timeLeft .. "s"
        wait(1)
        timeLeft = timeLeft - 1
        if timeLeft <= 0 then
            timeLeft = 40
        end
    end
end)

-- Botones de Etapas
local stages = {
    {name = "Etapa 15 TP", pos = {7961, 715, 5144}},
    {name = "Etapa 16 TP", pos = {7961, 715, 5144}},
    {name = "Etapa 17 TP", pos = {7961, 715, 5144}},
    {name = "Etapa 18 TP", pos = {7961, 715, 5144}},
}

local y = 60
for _, stage in ipairs(stages) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 50)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = stage.name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame

    btn.MouseButton1Click:Connect(function()
        TeleportTo(unpack(stage.pos))
    end)
    y = y + 60
end

print("🚀 GUI + Temporizador cargado correctamente")
