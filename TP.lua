-- TP.lua — 5 Mundos + X2 + Keyboard (World 3 Path) + Speed
print("TP.lua cargado correctamente")

-- Cargar WindUI
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end

local Window = WindUI:CreateWindow({
    Title = "+1 Speed Monkey Kenscript",
    Icon = "star",
    Theme = "Dark",
    Folder = "MyHub"
})

-- ==================== TAB MAIN ====================
local TabMain = Window:Tab({ Title = "Main", Icon = "home" })

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
    TabMain:Toggle({
        Title = title,
        Value = false,
        Callback = function(state)
            if state then
                updateHumanoid()
                local pos = MUNDOS[mundoNum]
                if humanoidRef and not originalWalkSpeed then
                    originalWalkSpeed = humanoidRef.WalkSpeed
                end
                teleportTo(pos)
                if humanoidRef then pcall(function() humanoidRef.WalkSpeed = 0 end) end
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

createMundoToggle(1, "Mundo 1")
createMundoToggle(2, "Mundo 2")
createMundoToggle(3, "Mundo 3")
createMundoToggle(4, "Mundo 4")
createMundoToggle(5, "Mundo 5")
createMundoToggle(6, "X2")

-- ==================== SPEED CONTROL ====================
local speedValue = 16

TabMain:Input({
    Title = "Speed (1-300)",
    Value = "16",
    Placeholder = "Escribe la velocidad...",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            speedValue = math.clamp(num, 1, 300)
        end
    end
})

TabMain:Button({
    Title = "Put",
    Callback = function()
        updateHumanoid()
        if humanoidRef then
            pcall(function()
                humanoidRef.WalkSpeed = speedValue
            end)
            print("Velocidad puesta a:", speedValue)
        else
            warn("No se encontró el Humanoid")
        end
    end
})

-- ==================== TAB KEYBOARD ====================
local TabKeyboard = Window:Tab({ Title = "Keyboard", Icon = "keyboard" })

local WORLD3_PATH = {
    Vector3.new(-1455, -158, -948),
    Vector3.new(-1433, -157, -839),
    Vector3.new(-1431, -122, -728),
    Vector3.new(-1428, -67, -531),
    Vector3.new(-1449, -68, -486),
    Vector3.new(-1447, -57, -399),
    Vector3.new(-1448, -55, -319),
    Vector3.new(-1440, -55, -194),
    Vector3.new(-1446, -55, -65),
    Vector3.new(-1454, -55, -2),
    Vector3.new(-1454, -55, 84),
    Vector3.new(-1454, -25, 84),
    Vector3.new(-1454, 4, 84),
    Vector3.new(-1454, 52, 84),
    Vector3.new(-1454, 92, 91),
    Vector3.new(-1433, 96, 95),
    Vector3.new(-1433, 143, 95),
    Vector3.new(-1433, 188, 95),
    Vector3.new(-1434, 217, 111),
    Vector3.new(-1437, 223, 170),
    Vector3.new(-1439, 225, 230),
    Vector3.new(-1438, 217, 347),
    Vector3.new(-1455, 217, 452),
    Vector3.new(-1446, 217, 533),
    Vector3.new(-1451, 217, 575),
    Vector3.new(-1451, 276, 627),
    Vector3.new(-1451, 366, 627),
    Vector3.new(-1453, 363, 604),
    Vector3.new(-1454, 362, 496),
    Vector3.new(-1356, 362, 495),
    Vector3.new(-1255, 335, 494),
    Vector3.new(-1235, 324, 595),
    Vector3.new(-1232, 331, 657),
    Vector3.new(-1225, 337, 751),
    Vector3.new(-1219, 347, 829),
    Vector3.new(-1289, 356, 837),
    Vector3.new(-1369, 367, 846),
    Vector3.new(-1397, 367, 787),
    Vector3.new(-1408, 381, 725),
    Vector3.new(-1408, 429, 725),
    Vector3.new(-1408, 484, 725),
    Vector3.new(-1408, 558, 725),
    Vector3.new(-1406, 535, 755),
    Vector3.new(-1403, 535, 833),
    Vector3.new(-1405, 535, 1079),
    Vector3.new(-1405, 535, 1143),
    Vector3.new(-1404, 535, 1335),
    Vector3.new(-1412, 535, 1425),
    Vector3.new(-1487, 511, 1445),
    Vector3.new(-1575, 511, 1447),
    Vector3.new(-1656, 511, 1447),
    Vector3.new(-1662, 511, 1446),
    Vector3.new(-1733, 511, 1447),
    Vector3.new(-1802, 511, 1446),
    Vector3.new(-1878, 511, 1447),
    Vector3.new(-1959, 511, 1446),
    Vector3.new(-2064, 445, 1485),
    Vector3.new(-2134, 445, 1482),
    Vector3.new(-2274, 441, 1489),
    Vector3.new(-2409, 443, 1491),
    Vector3.new(-2498, 449, 1492),
    Vector3.new(-2668, 445, 1494),
    Vector3.new(-2884, 476, 1489),
    Vector3.new(-2952, 554, 1489),
    Vector3.new(-3024, 638, 1488),
    Vector3.new(-3175, 675, 1488),
    Vector3.new(-3328, 663, 1488),
    Vector3.new(-3450, 645, 1499),
    Vector3.new(-3615, 622, 1483),
    Vector3.new(-3677, 619, 1486),
    Vector3.new(-3831, 619, 1488),
    Vector3.new(-4082, 619, 1506),
    Vector3.new(-4140, 619, 1488),
    Vector3.new(-4175, 618, 1488),
    Vector3.new(-4626, 619, 1441),
    Vector3.new(-4840, 619, 1554),
    Vector3.new(-4980, 619, 1476),
}

local world3Running = false
local world3Index = 1

local function isInLobby()
    local char = localPlayer and localPlayer.Character
    if not char then return true end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end

    local pos = hrp.Position
    local startPos = WORLD3_PATH[1]
    if (pos - startPos).Magnitude < 40 or pos.Y < -140 then
        return true
    end
    return false
end

local function runWorld3Path()
    task.spawn(function()
        while world3Running do
            if isInLobby() then
                world3Index = 1
                print("Lobby detectado → reiniciando World 3")
            end

            local target = WORLD3_PATH[world3Index]
            if target then
                teleportTo(target)
                world3Index = world3Index + 1

                if world3Index > #WORLD3_PATH then
                    world3Index = 1
                    print("Path completado → volviendo al inicio")
                end
            end

            task.wait(0.35)
        end
    end)
end

TabKeyboard:Toggle({
    Title = "World 3",
    Value = false,
    Callback = function(state)
        world3Running = state
        if state then
            print("World 3 activado")
            world3Index = 1
            updateHumanoid()
            if humanoidRef then
                pcall(function() humanoidRef.WalkSpeed = 0 end)
            end
            runWorld3Path()
        else
            print("World 3 desactivado")
            if humanoidRef and originalWalkSpeed then
                pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end)
            end
        end
    end,
})

print("UI creada - Main + Keyboard + Speed listos")