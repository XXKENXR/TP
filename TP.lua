-- TP.lua — Kenscript Hub
print("TP.lua cargado correctamente")

local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not success or not WindUI then
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end

local Window = WindUI:CreateWindow({
    Title = "Kenscript Hub",
    Icon = "star",
    Theme = "Dark",
    Folder = "MyHub"
})

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

    for i = 1, 6 do
        pcall(function()
            hrp.Velocity = Vector3.new(0, 0, 0)
            pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
            hrp.CFrame = CFrame.new(pos)
        end)
        task.wait(0.03)
        if (hrp.Position - pos).Magnitude <= 3 then return true end
    end
    return true
end

local function startHoldPosition(pos)
    if holdRunning and currentHoldPos == pos then return end
    holdRunning = false
    task.wait(0.03)
    holdRunning = true
    currentHoldPos = pos

    task.spawn(function()
        while holdRunning do
            local char = localPlayer and localPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
                        hrp.CFrame = CFrame.new(pos)
                    end)
                end
            end
            task.wait(0.07)
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
            task.wait(0.1)
            startHoldPosition(currentHoldPos)
        end
    end)
end

local function createMundoToggle(tab, mundoNum, title, positions)
    tab:Toggle({
        Title = title,
        Value = false,
        Callback = function(state)
            if state then
                updateHumanoid()
                local pos = positions[mundoNum]
                teleportTo(pos)
                if humanoidRef then pcall(function() humanoidRef.WalkSpeed = 0 end) end
                startHoldPosition(pos)
            else
                if currentHoldPos == positions[mundoNum] then
                    stopHoldPosition()
                    if humanoidRef and originalWalkSpeed then
                        pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end)
                    end
                end
            end
        end,
    })
end

-- ==================== TAB MONKEY FARM ====================
local TabMain = Window:Tab({ Title = "Monkey farm", Icon = "home" })

local MUNDOS = {
    [1] = Vector3.new(-9461, 389, -256),
    [2] = Vector3.new(-3606, 155, -9378),
    [3] = Vector3.new(-8078, 282, 2741),
    [4] = Vector3.new(-7760, 21, 5741),
    [5] = Vector3.new(-1331, 26, 7561),
    [6] = Vector3.new(-1350, 26, 7562),
}

createMundoToggle(TabMain, 1, "Mundo 1", MUNDOS)
createMundoToggle(TabMain, 2, "Mundo 2", MUNDOS)
createMundoToggle(TabMain, 3, "Mundo 3", MUNDOS)
createMundoToggle(TabMain, 4, "Mundo 4", MUNDOS)
createMundoToggle(TabMain, 5, "Mundo 5", MUNDOS)
createMundoToggle(TabMain, 6, "X2", MUNDOS)

-- ==================== TAB MONKEY FARM X2 ====================
local TabX2 = Window:Tab({ Title = "Monkey Farm X2", Icon = "zap" })

local MUNDOS_X2 = {
    [1] = Vector3.new(-9458, 389, -189),
    [2] = Vector3.new(-3671, 155, -9378),
    [3] = Vector3.new(-8096, 282, 2741),
    [4] = Vector3.new(-7778, 21, 5741),
    [5] = Vector3.new(-1349, 26, 7562),
}

createMundoToggle(TabX2, 1, "Mundo 1 X2 Wins", MUNDOS_X2)
createMundoToggle(TabX2, 2, "Mundo 2 X2 Wins", MUNDOS_X2)
createMundoToggle(TabX2, 3, "Mundo 3 X2 Wins", MUNDOS_X2)
createMundoToggle(TabX2, 4, "Mundo 4 X2 Wins", MUNDOS_X2)
createMundoToggle(TabX2, 5, "Mundo 5 X2 Wins", MUNDOS_X2)

-- ==================== TAB KEYBOARD ====================
local TabKeyboard = Window:Tab({ Title = "Keyboard", Icon = "keyboard" })

local isRecording = false
local isPlaying = false
local recordedPath = {}
local recordConnection = nil
local deleteObstacles = false

-- Detectar lobby (ajusta si hace falta)
local function isInLobby()
    local char = localPlayer and localPlayer.Character
    if not char then return true end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end

    local pos = hrp.Position
    -- Si no hay ruta, no se puede comparar
    if #recordedPath == 0 then return false end

    local startPos = recordedPath[1].CFrame.Position
    -- Si está cerca del inicio o muy abajo = lobby / respawn
    if (pos - startPos).Magnitude < 50 or pos.Y < -100 then
        return true
    end
    return false
end

-- Borrar Obstáculos
TabKeyboard:Toggle({
    Title = "Borrar Obstáculos",
    Value = false,
    Callback = function(state)
        deleteObstacles = state
        if state then
            print("Borrar Obstáculos activado")
            task.spawn(function()
                while deleteObstacles do
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local name = string.lower(obj.Name)
                            if string.find(name, "kill") or 
                               string.find(name, "death") or 
                               string.find(name, "trap") or 
                               string.find(name, "spike") or 
                               string.find(name, "lava") or 
                               string.find(name, "damage") or
                               string.find(name, "hurt") or
                               string.find(name, "die") or
                               string.find(name, "obstacle") or
                               string.find(name, "boss") or
                               string.find(name, "wave") or
                               string.find(name, "ola") then
                                pcall(function() obj:Destroy() end)
                            end
                        end
                    end
                    task.wait(0.4)
                end
            end)
        else
            print("Borrar Obstáculos desactivado")
        end
    end,
})

-- Grabar Ruta (velocidad 200)
TabKeyboard:Toggle({
    Title = "Grabar Ruta",
    Value = false,
    Callback = function(state)
        isRecording = state

        if state then
            recordedPath = {}
            updateHumanoid()
            if humanoidRef then
                pcall(function() humanoidRef.WalkSpeed = 200 end)
            end
            print("Grabando ruta a 200 de velocidad...")

            local lastTime = tick()
            recordConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not isRecording then return end

                local char = localPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum then return end

                local now = tick()
                table.insert(recordedPath, {
                    CFrame = hrp.CFrame,
                    Jump = hum.Jump,
                    Delta = now - lastTime
                })
                lastTime = now
            end)
        else
            if recordConnection then
                recordConnection:Disconnect()
                recordConnection = nil
            end
            if humanoidRef and originalWalkSpeed then
                pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end)
            end
            print("Ruta guardada! Puntos:", #recordedPath)
        end
    end,
})

-- Ejecutar Ruta (bucle + detecta lobby)
TabKeyboard:Toggle({
    Title = "Ejecutar Ruta",
    Value = false,
    Callback = function(state)
        isPlaying = state

        if state then
            if #recordedPath < 2 then
                warn("No hay ruta grabada o es muy corta")
                return
            end

            print("Ejecutando ruta en bucle...")

            task.spawn(function()
                while isPlaying do
                    -- Si detecta lobby, reinicia
                    if isInLobby() then
                        print("Lobby detectado → reiniciando ruta")
                    end

                    for i = 1, #recordedPath do
                        if not isPlaying then break end

                        -- Si en medio del path vuelve al lobby, reinicia
                        if isInLobby() and i > 5 then
                            print("Lobby detectado a mitad de ruta → reiniciando")
                            break
                        end

                        local data = recordedPath[i]
                        local char = localPlayer.Character

                        if char then
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            local hum = char:FindFirstChildOfClass("Humanoid")

                            if hrp and data.CFrame then
                                pcall(function()
                                    hrp.CFrame = data.CFrame
                                end)
                            end

                            if hum and data.Jump then
                                pcall(function()
                                    hum.Jump = true
                                end)
                            end
                        end

                        local waitTime = data.Delta or 0.016
                        if waitTime > 0.3 then waitTime = 0.05 end
                        task.wait(waitTime)
                    end

                    if isPlaying then
                        print("Ruta terminada → repitiendo...")
                        task.wait(0.3)
                    end
                end
            end)
        else
            print("Ejecución detenida")
        end
    end,
})

-- Eliminar Ruta
TabKeyboard:Toggle({
    Title = "Eliminar Ruta",
    Value = false,
    Callback = function(state)
        if state then
            recordedPath = {}
            isPlaying = false
            isRecording = false
            if recordConnection then
                recordConnection:Disconnect()
                recordConnection = nil
            end
            print("Ruta eliminada. Ya puedes grabar una nueva.")
        end
    end,
})

print("Kenscript Hub cargado")