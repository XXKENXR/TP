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
KeyBox.PlaceholderText = "Insert key"
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
        KeyBox.PlaceholderText = "Insert key"
    end
end)

-- ==================== MENÚ DESPLEGABLE PEQUEÑO ====================
function createMainGUI()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 220, 0, 45)
    MainFrame.Position = UDim2.new(0.5, -110, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local TitleBtn = Instance.new("TextButton")
    TitleBtn.Size = UDim2.new(1,0,1,0)
    TitleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    TitleBtn.Text = "Teleports ▼"
    TitleBtn.TextColor3 = Color3.new(1,1,1)
    TitleBtn.TextScaled = true
    TitleBtn.Font = Enum.Font.GothamBold
    TitleBtn.Parent = MainFrame

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1,0,0,45)
    Content.Position = UDim2.new(0,0,1,0)
    Content.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Content.Visible = false
    Content.Parent = MainFrame

    local TPBtn = Instance.new("TextButton")
    TPBtn.Size = UDim2.new(1,-16,0,35)
    TPBtn.Position = UDim2.new(0,8,0,5)
    TPBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    TPBtn.Text = "Etapa 16 TP"
    TPBtn.TextColor3 = Color3.new(1,1,1)
    TPBtn.TextScaled = true
    TPBtn.Parent = Content

    local isOpen = false

    TitleBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Content.Visible = isOpen
        MainFrame.Size = isOpen and UDim2.new(0, 220, 0, 95) or UDim2.new(0, 220, 0, 45)
        TitleBtn.Text = isOpen and "Teleports ▲" or "Teleports ▼"
    end)

    -- Temporizador
    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(0, 160, 0, 30)
    TimerLabel.Position = UDim2.new(0.5, -80, 0, 8)
    TimerLabel.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
    TimerLabel.TextColor3 = Color3.new(1,1,1)
    TimerLabel.TextScaled = true
    TimerLabel.Font = Enum.Font.GothamBold
    TimerLabel.Text = "Temporizador: 45s"
    TimerLabel.Visible = false
    TimerLabel.Parent = ScreenGui

    local function startTimer()
        TimerLabel.Visible = true
        local t = TIMER_DURATION
        spawn(function()
            while t > 0 do
                TimerLabel.Text = "Temporizador: " .. t .. "s"
                wait(1)
                t -= 1
            end
            TimerLabel.Text = "Temporizador: 0s"
        end)
    end

    TPBtn.MouseButton1Click:Connect(function()
        TeleportTo(7961, 715, 5144)
        startTimer()
    end)
end

print("🔒 Script cargado - Usa la clave XKR")