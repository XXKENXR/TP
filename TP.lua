-- TP.lua — 5 Mundos (TP + Hold Position)
print("TP.lua loaded: 5 Mundos con TP y hold position")

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "+1 Speed Monkey Kenscript",
    Icon = "star",
    Theme = "Dark",
    Folder = "MyHub"
})
local Tab = Window:Tab({ Title = "Main", Icon = "home" })

-- Coordenadas de los 5 mundos
local MUNDOS = {
    [1] = Vector3.new(-9461, 389, -256),
    [2] = Vector3.new(-3606, 155, -9378),
    [3] = Vector3.new(-8078, 282, 2741),
    [4] = Vector3.new(-7760, 21, 5741),
    [5] = Vector3.new(-1331, 26, 7561),
}

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local humanoidRef = nil
local originalWalkSpeed = nil

-- Hold system
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
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
    if not hrp then return false end

    for i = 1, 6 do
        pcall(function()
            hrp.Velocity = Vector3.new(0, 0, 0)
            pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
            hrp.CFrame = CFrame.new(pos)
        end)
        task.wait(0.03)
        if (hrp.Position - pos).Magnitude <= 2 then return true end
    end
    pcall(function() hrp.CFrame = CFrame.new(pos) end)
    return (hrp.Position - pos).Magnitude <= 5
end

local function startHoldPosition(pos)
    if holdRunning and currentHoldPos == pos then return end
    holdRunning = false
    task.wait(0.05)
    holdRunning = true
    currentHoldPos = pos

    task.spawn(function()
        local char = localPlayer and localPlayer.Character
        if not char then
            holdRunning = false
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")

        while holdRunning and hrp and hrp.Parent do
            pcall(function()
                hrp.Velocity = Vector3.new(0, 0, 0)
                pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
                hrp.CFrame = CFrame.new(pos)
            end)
            task.wait(0.08)
            hrp = hrp.Parent and hrp.Parent:FindFirstChild("HumanoidRootPart") or nil
        end
        holdRunning = false
    end)
end

local function stopHoldPosition()
    holdRunning = false
    currentHoldPos = nil
end

-- Character added
if localPlayer then
    if localPlayer.Character then updateHumanoid() end
    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.05)
        updateHumanoid()
        if holdRunning and currentHoldPos then
            task.wait(0.1)
            startHoldPosition(currentHoldPos)
        end
    end)
end

-- Función genérica para crear cada toggle
local function createMundoToggle(mundoNum, title)
    Tab:Toggle({
        Title = title,
        Value = false,
        Callback = function(state)
            print(title .. ":", state)

            if state then
                updateHumanoid()
                local pos = MUNDOS[mundoNum]

                -- Guardar velocidad original
                if humanoidRef and not originalWalkSpeed then
                    originalWalkSpeed = humanoidRef.WalkSpeed
                end

                -- Teleport
                local ok = teleportTo(pos)
                if not ok then
                    warn("Teleport a " .. title .. " puede haber fallado, intentando hold...")
                end

                -- Congelar movimiento
                if humanoidRef then
                    pcall(function() humanoidRef.WalkSpeed = 0 end)
                end

                -- Empezar a traba
                startHoldPosition(pos)
            else
                -- Solo detener si este era el mundo activo
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

-- Crear los 5 toggles
createMundoToggle(1, "Mundo 1")
createMundoToggle(2, "Mundo 2")
createMundoToggle(3, "Mundo 3")
createMundoToggle(4, "Mundo 4")
createMundoToggle(5, "Mundo 5")