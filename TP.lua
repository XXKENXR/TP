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
KeyFrame.Size = UDim2.new(0, 350, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -175, 0.35, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 12)
KeyCorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 60)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "Key System"
KeyTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
KeyTitle.TextScaled = true
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeySubtitle = Instance.new("TextLabel")
KeySubtitle.Size = UDim2.new(1, 0, 0, 30)
KeySubtitle.Position = UDim2.new(0, 0, 0, 55)
KeySubtitle.BackgroundTransparency = 1
KeySubtitle.Text = "Script by xxkenxr 🇵🇷"
KeySubtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
KeySubtitle.TextScaled = true
KeySubtitle.Font = Enum.Font.Gotham
KeySubtitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0, 45)
KeyBox.Position = UDim2.new(0.1, 0, 0.45, 0)
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
KeyButton.Size = UDim2.new(0.6, 0, 0, 45)
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
        KeyBox.PlaceholderText = "Clave incorrecta"
        wait(1)
        KeyBox.PlaceholderText = "Ingresa la clave..."
    end
end)

-- ==================== MAIN GUI ====================
function createMainGUI()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 320, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -160, 0.2

