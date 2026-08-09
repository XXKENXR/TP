-- TP.lua - UI fixed: ensure Tab:Toggle/Tab:Slider called with colon so titles appear correctly
print("TP.lua loaded: fixing UI labels and ensuring controls are created")

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Kenscript",
    Icon = "star",
    Theme = "Dark",
    Folder = "MyHub",
})

local Tab = Window:Tab({
    Title = "Autofarm",
    Icon = "home",
})

-- Waypoints list (kept as before)
local waypoints = {
    Vector3.new(-1455, -158, -948), Vector3.new(-1433, -157, -839), Vector3.new(-1431, -122, -728),
    Vector3.new(-1428, -67, -531), Vector3.new(-1449, -68, -486), Vector3.new(-1447, -57, -399),
    Vector3.new(-1448, -55, -319), Vector3.new(-1440, -55, -194), Vector3.new(-1446, -55, -65),
    Vector3.new(-1454, -55, -2), Vector3.new(-1454, -55, 84), Vector3.new(-1454, -25, 84),
    Vector3.new(-1454, 4, 84), Vector3.new(-1454, 52, 84), Vector3.new(-1454, 92, 91),
    Vector3.new(-1433, 96, 95), Vector3.new(-1433, 143, 95), Vector3.new(-1433, 188, 95),
    Vector3.new(-1434, 217, 111), Vector3.new(-1437, 223, 170), Vector3.new(-1439, 225, 230),
    Vector3.new(-1438, 217, 347), Vector3.new(-1455, 217, 452), Vector3.new(-1446, 217, 533),
    Vector3.new(-1451, 217, 575), Vector3.new(-1451, 276, 627), Vector3.new(-1451, 366, 627),
    Vector3.new(-1453, 363, 604), Vector3.new(-1454, 362, 496), Vector3.new(-1356, 362, 495),
    Vector3.new(-1255, 335, 494), Vector3.new(-1235, 324, 595), Vector3.new(-1232, 331, 657),
    Vector3.new(-1225, 337, 751), Vector3.new(-1219, 347, 829), Vector3.new(-1289, 356, 837),
    Vector3.new(-1369, 367, 846), Vector3.new(-1397, 367, 787), Vector3.new(-1408, 381, 725),
    Vector3.new(-1408, 429, 725), Vector3.new(-1408, 484, 725), Vector3.new(-1408, 558, 725),
    Vector3.new(-1406, 535, 755), Vector3.new(-1403, 535, 833), Vector3.new(-1405, 535, 1079),
    Vector3.new(-1405, 535, 1143), Vector3.new(-1404, 535, 1335), Vector3.new(-1412, 535, 1425),
    Vector3.new(-1487, 511, 1445), Vector3.new(-1575, 511, 1447), Vector3.new(-1656, 511, 1447),
    Vector3.new(-1662, 511, 1446), Vector3.new(-1733, 511, 1447), Vector3.new(-1802, 511, 1446),
    Vector3.new(-1878, 511, 1447), Vector3.new(-1959, 511, 1446), Vector3.new(-2064, 445, 1485),
    Vector3.new(-2134, 445, 1482), Vector3.new(-2274, 441, 1489), Vector3.new(-2409, 443, 1491),
    Vector3.new(-2498, 449, 1492), Vector3.new(-2668, 445, 1494), Vector3.new(-2884, 476, 1489),
    Vector3.new(-2952, 554, 1489), Vector3.new(-3024, 638, 1488), Vector3.new(-3175, 675, 1488),
    Vector3.new(-3328, 663, 1488), Vector3.new(-3450, 645, 1499), Vector3.new(-3615, 622, 1483),
    Vector3.new(-3677, 619, 1486), Vector3.new(-3831, 619, 1488), Vector3.new(-4082, 619, 1506),
    Vector3.new(-4140, 619, 1488), Vector3.new(-4175, 618, 1488), Vector3.new(-4626, 619, 1441),
    Vector3.new(-4840, 619, 1554), Vector3.new(-4980, 619, 1476),
}

-- States
local runAutofarm = false
local obstacleRemovalEnabled = false
local desiredSpeed = 100
local SPEED_CAP = 300

local humanoidRef = nil
local originalWalkSpeed = nil

-- Helpers
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local function getCharacter()
    if not localPlayer then return nil end
    return localPlayer.Character
end

local function updateHumanoidRefs()
    local char = getCharacter()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    humanoidRef = hum or humanoidRef
    if humanoidRef and not originalWalkSpeed then originalWalkSpeed = humanoidRef.WalkSpeed end
end

-- Teleport helper
local function teleportTo(pos)
    local char = getCharacter() or (localPlayer and localPlayer.CharacterAdded:Wait())
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    pcall(function()
        hrp.Velocity = Vector3.new(0,0,0)
        pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0,0,0) end)
        hrp.CFrame = CFrame.new(pos)
    end)
    return true
end

-- Obstacle removal sensors
local hazardNames = {"lava","kill","spike","trap","acid","death","hazard","damage"}
local lastTouchedPart = nil
local lastTouchedTime = 0
local touchedConn, diedConn, charAddedConn

local function isLikelyHazard(part)
    if not part or not part:IsA("BasePart") then return false end
    local name = tostring(part.Name):lower()
    for _, pat in ipairs(hazardNames) do if name:find(pat) then return true end end
    return false
end

local function attachObstacleSensors(char)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hrp then
        if touchedConn then pcall(function() touchedConn:Disconnect() end) end
        touchedConn = hrp.Touched:Connect(function(part)
            lastTouchedPart = part; lastTouchedTime = tick()
        end)
    end
    if hum then
        if diedConn then pcall(function() diedConn:Disconnect() end) end
        diedConn = hum.Died:Connect(function()
            if obstacleRemovalEnabled and lastTouchedPart and tick() - lastTouchedTime <= 3 then
                pcall(function()
                    if lastTouchedPart and lastTouchedPart.Parent then
                        lastTouchedPart:Destroy()
                        print("[Obstaculos] Eliminado parte tocada: ", lastTouchedPart:GetFullName())
                    end
                end)
            end
        end)
    end
end

if localPlayer then
    if localPlayer.Character then attachObstacleSensors(localPlayer.Character); updateHumanoidRefs() end
    charAddedConn = localPlayer.CharacterAdded:Connect(function(c)
        attachObstacleSensors(c)
        task.spawn(function() task.wait(0.05); updateHumanoidRefs() end)
    end)
end

-- Scanner thread
local scannerThread
local function startScanner()
    if scannerThread then return end
    scannerThread = task.spawn(function()
        while obstacleRemovalEnabled do
            for _, v in ipairs(workspace:GetDescendants()) do
                if not obstacleRemovalEnabled then break end
                if v:IsA("BasePart") and isLikelyHazard(v) then
                    pcall(function() v:Destroy(); print("[Obstaculos] Eliminado por nombre:", v:GetFullName()) end)
                end
            end
            task.wait(3)
        end
        scannerThread = nil
    end)
end
local function stopScanner()
    obstacleRemovalEnabled = false
    if scannerThread then scannerThread = nil end
    if touchedConn then pcall(function() touchedConn:Disconnect() end); touchedConn = nil end
    if diedConn then pcall(function() diedConn:Disconnect() end); diedConn = nil end
end

-- Speed enforcement
local enforcerRunning = false
local function enforceSpeed()
    if not humanoidRef or not humanoidRef.Parent then return end
    local want = math.max(1, math.min(SPEED_CAP, math.floor(desiredSpeed)))
    if humanoidRef.WalkSpeed ~= want then humanoidRef.WalkSpeed = want end
end

-- UI creation using colon syntax and pcall to avoid breaking
local ok, err

-- Autofarm toggle
ok, err = pcall(function()
    Tab:Toggle({
        Title = "Autofarm",
        Value = runAutofarm,
        Callback = function(state)
            runAutofarm = state
            print("Autofarm:", state)
            if runAutofarm then
                updateHumanoidRefs()
                -- start enforcer
                if not enforcerRunning then
                    enforcerRunning = true
                    task.spawn(function()
                        while runAutofarm do enforceSpeed(); task.wait(0.15) end
                        enforcerRunning = false
                    end)
                end
                task.spawn(function()
                    while runAutofarm do
                        for i = 1, #waypoints do
                            if not runAutofarm then break end
                            teleportTo(waypoints[i])
                            task.wait(0.2)
                        end
                        if not runAutofarm then break end
                        print("Ruta completada; esperando lobby (no autolobby detection in this minimal build).")
                        task.wait(1)
                    end
                    if humanoidRef and originalWalkSpeed then pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end) end
                    print("Autofarm detenido")
                end)
            else
                if humanoidRef and originalWalkSpeed then pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end) end
            end
        end,
    })
end)
if not ok then warn("Failed to create Autofarm toggle:", err) end

-- Velocidad label + slider + buttons
ok, err = pcall(function()
    Tab:Label({ Title = "Velocidad" })
end)
if not ok then warn("Label not available:", err) end

ok, err = pcall(function()
    Tab:Slider({
        Title = "Velocidad",
        Min = 1,
        Max = 300,
        Value = desiredSpeed,
        Format = function(v) return tostring(math.floor(v)) end,
        Callback = function(v)
            desiredSpeed = math.max(1, math.min(300, math.floor(v)))
            print("Velocidad ajustada a:", desiredSpeed)
            updateHumanoidRefs(); if humanoidRef then pcall(function() humanoidRef.WalkSpeed = desiredSpeed end) end
        end,
    })
end)
if not ok then warn("Slider failed, creating +/- buttons fallback:", err)
    pcall(function()
        Tab:Button({ Title = "+5", Callback = function() desiredSpeed = math.min(300, desiredSpeed + 5); print("Velocidad:", desiredSpeed); updateHumanoidRefs(); if humanoidRef then pcall(function() humanoidRef.WalkSpeed = desiredSpeed end) end end })
        Tab:Button({ Title = "-5", Callback = function() desiredSpeed = math.max(1, desiredSpeed - 5); print("Velocidad:", desiredSpeed); updateHumanoidRefs(); if humanoidRef then pcall(function() humanoidRef.WalkSpeed = desiredSpeed end) end end })
    end)
end

-- Eliminar Obstaculos toggle
ok, err = pcall(function()
    Tab:Toggle({
        Title = "Eliminar Obstaculos",
        Value = obstacleRemovalEnabled,
        Callback = function(state)
            obstacleRemovalEnabled = state
            print("Eliminar Obstaculos:", state)
            if obstacleRemovalEnabled then startScanner() else stopScanner() end
        end,
    })
end)
if not ok then warn("Failed to create Eliminar Obstaculos toggle:", err) end

Tab:Space()

-- Final print so user can see script loaded
print("TP.lua UI (Autofarm / Velocidad / Eliminar Obstaculos) created — recarga con loadstring if you don't see it.")
