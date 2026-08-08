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

-- Waypoints list (in order)
local waypoints = {
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

-- Simple Autofarm toggle
local runAutofarm = false
local currentIndex = 1
local targetCFrame = CFrame.new(-9460, 389, -253) -- kept for compatibility but not used in waypoint loop

-- Lobby detection (auto-detect if possible)
local lobbyPosition = nil -- will be auto-detected on first run
local lobbyThreshold = 60

-- Speed cap and user speed control
local SPEED_CAP = 300 -- máxima velocidad permitida
local desiredSpeed = 300 -- user-configurable speed (1..300)
local originalWalkSpeed = nil
local humanoidRef = nil
local speedControlEnabled = true -- toggle to enable/disable speed control

local enforcerRunning = false

local function setLobbyPositionIfNil()
    if lobbyPosition then return end
    local player = game.Players.LocalPlayer
    if not player then return end
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
    if hrp then
        lobbyPosition = Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
        print("Lobby position autoguardada en:", lobbyPosition)
    end
end

-- Try to set lobby position now if nil
pcall(setLobbyPositionIfNil)

local function isInLobby()
    if not lobbyPosition then return false end
    local player = game.Players.LocalPlayer
    if not player then return false end
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local pos = hrp.Position
    local dxz = Vector3.new(pos.X, 0, pos.Z) - Vector3.new(lobbyPosition.X, 0, lobbyPosition.Z)
    return dxz.Magnitude <= lobbyThreshold
end

-- More aggressive teleport: multiple quick attempts + reset velocities to help the client "stick" to the point
local function teleportTo(pos)
    local player = game.Players.LocalPlayer
    if not player then return false end
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
    if not hrp then return false end

    for i = 1, 6 do -- varios intentos rápidos
        pcall(function()
            -- intentar detener inercia si la hay
            pcall(function()
                hrp.Velocity = Vector3.new(0,0,0)
            end)
            pcall(function()
                -- AssemblyLinearVelocity puede no existir en algunos entornos, por eso pcall
                hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
            end)
            hrp.CFrame = CFrame.new(pos)
        end)
        task.wait(0.03)
        if (hrp.Position - pos).Magnitude <= 2 then
            return true
        end
    end

    -- intento final
    pcall(function() hrp.CFrame = CFrame.new(pos) end)
    return (hrp.Position - pos).Magnitude <= 5
end

local function enforceSpeedCap()
    if humanoidRef and humanoidRef.Parent and speedControlEnabled then
        -- clamp desiredSpeed to [1, SPEED_CAP]
        local want = math.max(1, math.min(SPEED_CAP, math.floor(desiredSpeed)))
        if humanoidRef.WalkSpeed ~= want then
            humanoidRef.WalkSpeed = want
        end
    end
end

-- Obstacle remover state
local obstacleRemovalEnabled = false
local lastTouchedPart = nil
local lastTouchedTime = 0
local touchedConn = nil
local diedConn = nil
local obstacleScannerThread = nil

-- Heuristic: part names that are likely to kill (lowercase)
local hazardNames = {"lava","kill","spike","damage","trap","acid","death","hazard"}

local function isLikelyHazard(part)
    if not part or not part:IsA("BasePart") then return false end
    local name = part.Name and string.lower(part.Name) or ""
    for _, pat in ipairs(hazardNames) do
        if name:find(pat) then return true end
    end
    -- if the part is non-collidable and transparent probably not hazard
    -- anchored hazards are common; accept anchored parts too
    return false
end

local function startObstacleRemoval()
    if obstacleScannerThread then return end

    local player = game.Players.LocalPlayer
    local function onTouched(part)
        lastTouchedPart = part
        lastTouchedTime = tick()
    end

    local function onDied()
        -- if we touched a part recently, try to destroy it
        if lastTouchedPart and tick() - lastTouchedTime <= 3 then
            local p = lastTouchedPart
            if p and p.Parent then
                local ok, err = pcall(function()
                    p:Destroy()
                end)
                if ok then
                    print("[Eliminar Obstaculos] Eliminado elemento tocado: ", p:GetFullName())
                else
                    warn("[Eliminar Obstaculos] Falló al eliminar elemento tocado:", err)
                end
            end
        end
    end

    -- connect to character when it spawns
    local function attachToCharacter(char)
        pcall(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hrp:IsA("BasePart") then
                touchedConn = hrp.Touched:Connect(onTouched)
            end
            if hum then
                diedConn = hum.Died:Connect(onDied)
            end
        end)
    end

    -- attach to current character
    local char = player.Character
    if char then attachToCharacter(char) end

    -- listen for future characters
    player.CharacterAdded:Connect(function(c)
        -- disconnect previous connections safely
        if touchedConn then touchedConn:Disconnect() touchedConn = nil end
        if diedConn then diedConn:Disconnect() diedConn = nil end
        attachToCharacter(c)
    end)

    -- scanner thread: periodically remove parts whose names match hazard patterns
    obstacleScannerThread = task.spawn(function()
        while obstacleRemovalEnabled do
            -- scan workspace quickly but safely
            for _, v in ipairs(workspace:GetDescendants()) do
                if not obstacleRemovalEnabled then break end
                if v:IsA("BasePart") and isLikelyHazard(v) then
                    -- try to destroy
                    local ok, err = pcall(function()
                        v:Destroy()
                    end)
                    if ok then
                        print("[Eliminar Obstaculos] Eliminado hazard por nombre:", v:GetFullName())
                    end
                end
            end
            -- wait a bit between scans
            task.wait(3)
        end
        obstacleScannerThread = nil
    end)
end

local function stopObstacleRemoval()
    obstacleRemovalEnabled = false
    -- disconnect connections
    if touchedConn then pcall(function() touchedConn:Disconnect() end) touchedConn = nil end
    if diedConn then pcall(function() diedConn:Disconnect() end) diedConn = nil end
    obstacleScannerThread = nil
end

-- UI: Speed enable toggle and slider (1..300)
Tab:Toggle({
    Title = "Enable Speed Control",
    Value = speedControlEnabled,
    Callback = function(state)
        speedControlEnabled = state
        if not speedControlEnabled and humanoidRef and originalWalkSpeed then
            pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end)
        end
    end,
})

Tab:Slider({
    Title = "Speed",
    Min = 1,
    Max = 300,
    Value = desiredSpeed,
    Format = function(v) return tostring(math.floor(v)) end,
    Callback = function(v)
        desiredSpeed = math.max(1, math.min(300, math.floor(v)))
        -- apply immediately if running and humanoid known and speed control enabled
        if runAutofarm and humanoidRef and speedControlEnabled then
            pcall(function()
                humanoidRef.WalkSpeed = math.max(1, math.min(SPEED_CAP, desiredSpeed))
            end)
        end
    end,
})

Tab:Space()

-- Toggle to remove obstacles
Tab:Toggle({
    Title = "Eliminar Obstaculos",
    Value = false,
    Callback = function(state)
        obstacleRemovalEnabled = state
        print("Eliminar Obstaculos:", state)
        if obstacleRemovalEnabled then
            startObstacleRemoval()
        else
            stopObstacleRemoval()
        end
    end,
})

Tab:Space()

Tab:Toggle({
    Title = "Autofarm",
    Value = false,
    Callback = function(state)
        runAutofarm = state
        print("Autofarm enabled:", state)
        local player = game.Players.LocalPlayer
        if runAutofarm then
            -- detect lobby position if not set
            pcall(setLobbyPositionIfNil)

            -- try to get humanoid and store original walkspeed
            local char = player and (player.Character or player.CharacterAdded:Wait())
            if char then
                humanoidRef = char:FindFirstChildOfClass("Humanoid")
                if humanoidRef and not originalWalkSpeed then
                    originalWalkSpeed = humanoidRef.WalkSpeed
                end
                if humanoidRef and speedControlEnabled then
                    humanoidRef.WalkSpeed = math.max(1, math.min(SPEED_CAP, desiredSpeed))
                end
            end

            -- start enforcer thread
            if not enforcerRunning then
                enforcerRunning = true
                task.spawn(function()
                    while runAutofarm do
                        enforceSpeedCap()
                        task.wait(0.15)
                    end
                    enforcerRunning = false
                end)
            end

            task.spawn(function()
                while runAutofarm do
                    -- Iterate waypoints sequentially WITHOUT delay
                    for i = 1, #waypoints do
                        if not runAutofarm then break end
                        currentIndex = i
                        local wp = waypoints[i]
                        teleportTo(wp)
                    end

                    if not runAutofarm then break end

                    -- Finished the route; now wait until we detect player in lobby to restart
                    print("Ruta completada, esperando a volver al lobby para reiniciar...")
                    local start = tick()
                    local timeout = 300 -- safety timeout in seconds
                    while runAutofarm and not isInLobby() and (tick() - start) < timeout do
                        task.wait(0.2)
                        -- keep enforcing cap while waiting
                        enforceSpeedCap()
                    end

                    if not runAutofarm then break end

                    if isInLobby() then
                        print("Lobby detectado: reiniciando ruta...")
                        task.wait(0.15)
                    else
                        warn("No se detectó el lobby dentro del timeout; reintentando la ruta")
                    end
                end

                -- restore original walkspeed if we changed it
                if humanoidRef and originalWalkSpeed and not speedControlEnabled then
                    pcall(function()
                        humanoidRef.WalkSpeed = originalWalkSpeed
                    end)
                end

                print("Autofarm detenido")
            end)
        else
            -- stopped: restore walkspeed immediately if possible
            if humanoidRef and originalWalkSpeed then
                pcall(function()
                    humanoidRef.WalkSpeed = originalWalkSpeed
                end)
            end
        end
    end,
})

Tab:Space()

-- Keybind (K) para abrir/cerrar la UI en PC
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local function toggleWindowVisibility()
    local success, err = pcall(function()
        if type(Window.Toggle) == "function" then
            Window:Toggle()
            return
        end
        if type(Window.ToggleVisibility) == "function" then
            Window:ToggleVisibility()
            return
        end
        if type(Window.SetVisible) == "function" then
            local vis = Window.Visible
            if type(vis) == "boolean" then
                Window:SetVisible(not vis)
                return
            end
        end
    end)

    if success then return end

    -- Fallback: buscar ScreenGui en PlayerGui o CoreGui y alternar su Enabled
    local function toggleGuiIn(parent)
        for _, gui in pairs(parent:GetChildren()) do
            if gui:IsA("ScreenGui") then
                local name = string.lower(gui.Name)
                if name:find("wind") or name:find("kenscript") or name:find("myhub") or name:find("autofarm") then
                    gui.Enabled = not gui.Enabled
                    return true
                end
            end
        end
        return false
    end

    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    if playerGui and toggleGuiIn(playerGui) then return end

    local coreGui = game:GetService("CoreGui")
    pcall(function()
        toggleGuiIn(coreGui)
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.K then
        toggleWindowVisibility()
    end
end)
