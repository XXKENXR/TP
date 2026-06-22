-- Condonsitos Online - Brainrot Spawner LocalScript
-- Colócalo en StarterPlayer > StarterPlayerScripts
-- Funciona en la mayoría de juegos con trading (visuales del lado cliente, pero usa replicación básica si hay remotes)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CondonsitosOnline"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
title.Text = "🧠 Condonsitos Online 🧠"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(0.9, 0, 0, 60)
spawnButton.Position = UDim2.new(0.05, 0, 0.2, 0)
spawnButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
spawnButton.Text = "Spawnear Brainrot Visual"
spawnButton.TextColor3 = Color3.new(0,0,0)
spawnButton.TextScaled = true
spawnButton.Font = Enum.Font.GothamBold
spawnButton.Parent = mainFrame

local clearButton = Instance.new("TextButton")
clearButton.Size = UDim2.new(0.9, 0, 0, 50)
clearButton.Position = UDim2.new(0.05, 0, 0.4, 0)
clearButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
clearButton.Text = "Eliminar Brainrots"
clearButton.TextColor3 = Color3.new(1,1,1)
clearButton.TextScaled = true
clearButton.Parent = mainFrame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 40)
status.Position = UDim2.new(0.05, 0, 0.6, 0)
status.BackgroundTransparency = 1
status.Text = "Brainrot listo para spawnear 😎"
status.TextColor3 = Color3.new(1,1,1)
status.TextScaled = true
status.Parent = mainFrame

local brainrotsFolder = Instance.new("Folder")
brainrotsFolder.Name = "CondonsitosBrainrots"
brainrotsFolder.Parent = workspace

local brainrotPhrases = {
    "Skibidi Toilet Rizz 🧼",
    "Ohio Brainrot 🌀",
    "Sigma Mewing 😭",
    "Fanum Tax Gyatt 🍑",
    "Edge Lord 3000 💀",
    "Condonsitos Online 🔥",
    "Brainrot Maxxing 🧠"
}

local function createBrainrot(position)
    local model = Instance.new("Model")
    model.Name = "Brainrot_" .. math.random(1000,9999)
    
    -- Part visual principal (flotante)
    local part = Instance.new("Part")
    part.Size = Vector3.new(4, 4, 4)
    part.Shape = Enum.PartType.Ball
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(math.random(100,255), 0, math.random(100,255))
    part.Position = position + Vector3.new(0, 5, 0)
    part.Anchored = true
    part.CanCollide = false
    part.Parent = model
    
    -- BillboardGui con texto brainrot
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(8, 0, 4, 0)
    billboard.Adornee = part
    billboard.AlwaysOnTop = true
    billboard.Parent = part
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = brainrotPhrases[math.random(1, #brainrotPhrases)]
    textLabel.TextColor3 = Color3.new(1,1,1)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.Arcade
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0,0,0)
    textLabel.Parent = billboard
    
    -- Partículas para más brainrot vibe
    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://243660364" -- efecto glow
    particles.Color = ColorSequence.new(part.Color)
    particles.Lifetime = NumberRange.new(1, 3)
    particles.Rate = 50
    particles.Speed = NumberRange.new(5, 15)
    particles.Parent = part
    
    model.Parent = brainrotsFolder
    
    -- Animación de flotación
    spawn(function()
        while part and part.Parent do
            part.Position = part.Position + Vector3.new(0, math.sin(tick()*3)*0.1, 0)
            wait(0.03)
        end
    end)
    
    return model
end

spawnButton.MouseButton1Click:Connect(function()
    status.Text = "¡Brainrot spawneado! 😈"
    for i = 1, 5 do
        local pos = character.HumanoidRootPart.Position + Vector3.new(math.random(-15,15), 8, math.random(-15,15))
        createBrainrot(pos)
    end
    
    -- Intentar que sea visible en trade (si el juego replica partes en workspace)
    wait(0.5)
    status.Text = "Brainrots visibles en trade machine ✅"
end)

clearButton.MouseButton1Click:Connect(function()
    for _, v in pairs(brainrotsFolder:GetChildren()) do
        v:Destroy()
    end
    status.Text = "Todos los brainrots eliminados"
end)

-- Spawnear al mover el mouse (mantén clic derecho)
mouse.Button2Down:Connect(function()
    local target = mouse.Hit.Position
    createBrainrot(target)
end)

print("✅ Condonsitos Online cargado - Brainrot Spawner listo!")
print("Clic derecho para spawnear en cursor | Botones para control")
