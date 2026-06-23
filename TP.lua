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
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Title.Text = "Key System"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = KeyFrame

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1,0,0,30)
Subtitle.Position = UDim2.new(0,0,0,50)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Script by xxkenxr 🇵🇷"
Subtitle.TextColor3 = Color3.fromRGB(200,200,200)
Subtitle.TextScaled = true
Subtitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8,0,0,40)
KeyBox.Position = UDim2.new(0.1,0,0.45,0)
KeyBox.PlaceholderText = "Ingresa la clave..."
KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.TextScaled = true
KeyBox.Parent = KeyFrame

local ConfirmBtn = Instance.new("TextButton")
ConfirmBtn.Size = UDim2.new(0.6,0,0,40)
ConfirmBtn.Position = UDim2.new(0.2,0,0.7,0)
ConfirmBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
ConfirmBtn.Text = "Confirmar"
ConfirmBtn.TextColor3 = Color3.new(1,1,1)
ConfirmBtn.TextScaled = true
ConfirmBtn.Parent = KeyFrame

ConfirmBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CORRECT_KEY then
        KeyFrame:Destroy()
        createMainGUI()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Key Invalid"
        wait(1.5)
        KeyBox.PlaceholderText = "Ingresa la clave..."
    end
end)

-- ==================== MAIN GUI ====================
function createMainGUI()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -150, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local Title2 = Instance.new("TextLabel")
    Title2.Size = UDim2.new(1,0,0,45)
    Title2.BackgroundColor3 = Color3.fromRGB(0,120,255)
    Title2.Text = "Teleports"
    Title2.TextColor3 = Color3.new(1,1,1)
    Title2.TextScaled = true
    Title2.Parent = MainFrame

    -- Bolita Roja Movible
    local TimerBall = Instance.new("Frame")
    TimerBall.Size = UDim2.new(0, 70, 0, 70)
    TimerBall.Position = UDim2.new(0.8, 0, 0.1, 0)
    TimerBall.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    TimerBall.Active = true
    TimerBall.Draggable = true
    TimerBall.Visible = false
    TimerBall.Parent = ScreenGui

    local BallCorner = Instance.new("UICorner")
    BallCorner.CornerRadius = UDim.new(1, 0)
    BallCorner.Parent = TimerBall

    local TimerText = Instance.new("TextLabel")
    TimerText.Size = UDim2.new(1,0,1,0)
    TimerText.BackgroundTransparency = 1
    TimerText.Text = "45s"
    TimerText.TextColor3 = Color3.new(1,1,1)
    TimerText.TextScaled = true
    TimerText.Font = Enum.Font.GothamBold
    TimerText.Parent = TimerBall

    local function startTimer()
        TimerBall.Visible = true
        local t = TIMER_DURATION
        spawn(function()
            while t > 0 do
                TimerText.Text = t .. "s"
                wait(1)
                t -= 1
            end
            TimerText.Text = "0s"
        end)
    end

    -- Botones
    local stages = {
        {name = "Etapa 15 TP", pos = {7961, 715, 5144}},
        {name = "Etapa 16 TP", pos = {7961, 715, 5144}},
        {name = "Etapa 17 TP", pos = {7961, 715, 5144}},
        {name = "Etapa 18 TP", pos = {7961, 715, 5144}},
    }

    local y = 55
    for _, stage in ipairs(stages) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-20,0,45)
        btn.Position = UDim2.new(0,10,0,y)
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        btn.Text = stage.name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Parent = MainFrame

        btn.MouseButton1Click:Connect(function()
            TeleportTo(unpack(stage.pos))
            startTimer()   -- Reinicia y muestra la bolita
        end)
        y = y + 55
    end
end

print("🔒 Script cargado - Usa XKR")