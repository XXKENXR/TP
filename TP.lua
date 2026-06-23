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
ScreenGui.Name = "TPGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== KEY SYSTEM ====================
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 320, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -160, 0.35, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 12)
KeyCorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "Key System"
KeyTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
KeyTitle.TextScaled = true
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeySubtitle = Instance.new("TextLabel")
KeySubtitle.Size = UDim2.new(1, 0, 0, 25)
KeySubtitle.Position = UDim2.new(0, 0, 0, 48)
KeySubtitle.BackgroundTransparency = 1
KeySubtitle.Text = "Script by xxkenxr 🇵🇷"
KeySubtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
KeySubtitle.TextScaled = true
KeySubtitle.Font = Enum.Font.Gotham
KeySubtitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.85, 0, 0, 40)
KeyBox.Position = UDim2.new(0.075, 0, 0.42, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyBox.Text = ""
KeyBox.PlaceholderText = "Ingresa la clave..."
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.TextScaled = true
KeyBox.Font = Enum.Font.Gotham
KeyBox.Parent = KeyFrame

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 8)
KeyBoxCorner.Parent = KeyBox

local KeyButton = Instance.new("TextButton")
KeyButton.Size = UDim2.new(0.6, 0, 0, 40)
KeyButton.Position = UDim2.new(0.2, 0, 0.72, 0)
KeyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
KeyButton.Text = "Confirmar"
KeyButton.TextColor3 = Color3.new(1,1,1)
KeyButton.TextScaled = true
KeyButton.Font = Enum.Font.GothamBold
KeyButton.Parent = KeyFrame

local KeyButtonCorner = Instance.new("UICorner")
KeyButtonCorner.CornerRadius = UDim.new(0, 8)
KeyButtonCorner.Parent = KeyButton

KeyButton.MouseButton1Click:Connect(function()
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

-- ==================== MAIN GUI + BOLITA ROJA ====================
function createMainGUI()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -150, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    Title.Text = "Teleports"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = Title

    -- Bolita Roja Movible
    local TimerBall = Instance.new("Frame")
    TimerBall.Size = UDim2.new(0, 70, 0, 70)
    TimerBall
