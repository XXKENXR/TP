local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local HEIGHT_OFFSET = 5
local TIMER_DURATION = 40

local function TeleportTo(x, y, z)
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    root.CFrame = CFrame.new(Vector3.new(x, y + HEIGHT_OFFSET, z))
end

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
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Title.Text = "Teleports"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Temporizador (empieza oculto)
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(1, 0, 0, 35)
TimerLabel.Position = UDim2.new(0, 0, 0, -38)
TimerLabel.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.TextScaled = true
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.Text = "Temporizador: 40s"
TimerLabel.Visible = false
TimerLabel.Parent = MainFrame

local currentTimer = TIMER_DURATION
local timerRunning = false

local function startTimer()
    TimerLabel.Visible = true
    if timerRunning then return end
    timerRunning = true
    currentTimer = TIMER_DURATION
    
    spawn(function()
        while currentTimer > 0 and timerRunning do
            TimerLabel.Text = "Temporizador: " .. currentTimer .. "s"
            wait(1)
            currentTimer -= 1
        end
        if currentTimer <= 0 then
            TimerLabel.Text = "Temporizador: 0s"
            timerRunning = false
        end
    end)
end

-- Botones
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
        startTimer()   -- Solo inicia cuando usas TP
    end)
    y = y + 60
end

print("🚀 GUI cargada - Temporizador solo al usar TP")
