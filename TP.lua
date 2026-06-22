local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local HEIGHT_OFFSET = 5
local TIMER_DURATION = 40
local CORRECT_KEY = "XKR"

-- ==================== VERIFICACIÓN DE CLAVE ====================
local keyEntered = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TPGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame de la clave
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ScreenGui

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
KeyTitle.Text = "Ingresa la Clave"
KeyTitle.TextColor3 = Color3.new(1,1,1)
KeyTitle.TextScaled = true
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyBox.Position = UDim2.new(0.1, 0, 0.45, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.Text = ""
KeyBox.PlaceholderText = "Escribe la clave aquí..."
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.TextScaled = true
KeyBox.Font = Enum.Font.Gotham
KeyBox.Parent = KeyFrame

local KeyButton = Instance.new("TextButton")
KeyButton.Size = UDim2.new(0.6, 0, 0, 35)
KeyButton.Position = UDim2.new(0.2, 0, 0.75, 0)
KeyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
KeyButton.Text = "Confirmar"
KeyButton.TextColor3 = Color3.new(1,1,1)
KeyButton.TextScaled = true
KeyButton.Font = Enum.Font.GothamBold
KeyButton.Parent = KeyFrame

KeyButton.MouseButton1Click:Connect(function()
    if KeyBox.Text == CORRECT_KEY then
        keyEntered = true
        KeyFrame:Destroy()
        createMainGUI()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Clave incorrecta, intenta de nuevo"
    end
end)

-- ==================== GUI PRINCIPAL ====================
function createMainGUI()
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

    -- Temporizador (oculto al inicio)
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
        {name = "Etapa 17 TP", pos = {7961, 715, 5144
