-- TP.lua — 5 Mundos + X2 (TP + Hold Position)
print("TP.lua cargado correctamente")

-- Cargar WindUI de forma más estable
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("Falló cargar WindUI, intentando método alternativo...")
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end

local Window = WindUI:CreateWindow({
    Title = "+1 Speed Monkey Kenscript",
    Icon = "star",
    Theme = "Dark",
    Folder = "MyHub"
})

local Tab = Window:Tab({ Title = "Main", Icon = "home" })

-- Coordenadas
local MUNDOS = {
    [1] = Vector3.new(-9461, 389, -256),
    [2] = Vector3.new(-3606, 155, -9378),
    [3] = Vector3.new(-8078, 282, 2741),
    [4] = Vector3.new(-7760, 21, 5741),
    [5] = Vector3.new(-1331, 26, 7561),
    [6] = Vector3.new(-1350, 26, 7562), -- X2
}

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local humanoidRef = nil
local originalWalkSpeed = nil

local holdRunning = false
local currentHoldPos = nil

local function updateHumanoid()
    local char = localPlayer and localPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        humanoidRef = hum
        if not originalWalkSpeed then
            originalWalkSpeed = humanoidRef.WalkSpeed
        end
    end
end

local function teleportTo(pos)
    local char = localPlayer and (localPlayer.Character or localPlayer.CharacterAdded:Wait())
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return false end

    for i = 1, 8 do
        pcall(function()
            hrp.Velocity = Vector3.new(0, 0, 0)
            pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
            hrp.CFrame = CFrame.new(pos)
        end)
        task.wait(0.04)
        if (hrp.Position - pos).Magnitude <= 3 then return true end
    end
    pcall(function() hrp.CFrame = CFrame.new(pos) end)
    return (hrp.Position - pos).Magnitude <= 6
end

local function startHoldPosition(pos)
    if holdRunning and currentHoldPos == pos then return end
    holdRunning = false
    task.wait(0.05)
    holdRunning = true
    currentHoldPos = pos

    task.spawn(function()
        while holdRunning do
            local char = localPlayer and localPlayer.Character
            if not char then
                task.wait(0.2)
            else
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
                        hrp.CFrame = CFrame.new(pos)
                    end)
                end
                task.wait(0.07)
            end
        end
    end)
end

local function stopHoldPosition()
    holdRunning = false
    currentHoldPos = nil
end

if localPlayer then
    if localPlayer.Character then updateHumanoid() end
    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.1)
        updateHumanoid()
        if holdRunning and currentHoldPos then
            task.wait(0.15)
            startHoldPosition(currentHoldPos)
        end
    end)
end

local function createMundoToggle(mundoNum, title)
    Tab:Toggle({
        Title = title,
        Value = false,
        Callback = function(state)
            print(title .. ":", state)

            if state then
                updateHumanoid()
                local pos = MUNDOS[mundoNum]

                if humanoidRef and not originalWalkSpeed then
                    originalWalkSpeed = humanoidRef.WalkSpeed
                end

                local ok = teleportTo(pos)
                if not ok then
                    warn("Teleport a " .. title .. " puede haber fallado, intentando hold...")
                end

                if humanoidRef then
                    pcall(function() humanoidRef.WalkSpeed = 0 end)
                end

                startHoldPosition(pos)
            else
                if currentHoldPos == MUNDOS[mundoNum] then
                    stopHoldPosition()
                    if humanoidRef and originalWalkSpeed then
                        pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end)
                    end
                end
            end
        end,
    })
end

-- Toggles
createMundoToggle(1, "Mundo 1")
createMundoToggle(2, "Mundo 2")
createMundoToggle(3, "Mundo 3")
createMundoToggle(4, "Mundo 4")
createMundoToggle(5, "Mundo 5")
createMundoToggle(6, "X2")

print("UI creada - 5 Mundos + X2 listos")