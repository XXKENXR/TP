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

-- Speed cap
local SPEED_CAP = 300 -- máxima velocidad permitida
local originalWalkSpeed = nil
local humanoidRef = nil

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

local function teleportTo(pos)
    local player = game.Players.LocalPlayer
    if not player then return false end
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
    if not hrp then return false end
    local ok, err = pcall(function()
        hrp.CFrame = CFrame.new(pos)
    end)
    if not ok then
        warn("Teleport error:", err)
    end
    return ok
end

local function enforceSpeedCap()
    if humanoidRef and humanoidRef.Parent then
        if humanoidRef.WalkSpeed > SPEED_CAP then
            humanoidRef.WalkSpeed = SPEED_CAP
        end
    end
end

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
                if humanoidRef then
                    originalWalkSpeed = humanoidRef.WalkSpeed
                    -- set to SPEED_CAP (no más de 300)
                    humanoidRef.WalkSpeed = math.min(SPEED_CAP, 300)
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
                if humanoidRef and originalWalkSpeed then
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
