-- give_win_handler.lua (ServerScriptService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local REMOTE_NAME = "ClaimWin"
local TARGET_POS = Vector3.new(808, 814, 915)
local ALLOWED_RADIUS = 8          -- distancia máxima (en studs) desde TARGET_POS para validar
local COOLDOWN_SECONDS = 3        -- evita spam

-- Crear RemoteEvent si no existe
local ev = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not ev then
    ev = Instance.new("RemoteEvent")
    ev.Name = REMOTE_NAME
    ev.Parent = ReplicatedStorage
end

local lastClaim = {} -- track cooldown por jugador

local function ensureLeaderstats(player)
    local stats = player:FindFirstChild("leaderstats")
    if not stats then
        stats = Instance.new("Folder")
        stats.Name = "leaderstats"
        stats.Parent = player
    end
    local wins = stats:FindFirstChild("Wins")
    if not wins then
        wins = Instance.new("IntValue")
        wins.Name = "Wins"
        wins.Value = 0
        wins.Parent = stats
    end
    return stats, wins
end

ev.OnServerEvent:Connect(function(player)
    -- Anti-spam / cooldown
    local now = tick()
    if lastClaim[player] and now - lastClaim[player] < COOLDOWN_SECONDS then
        return
    end
    lastClaim[player] = now

    -- Validar personaje y posición
    local char = player.Character
    local primary = char and (char.PrimaryPart or char:FindFirstChild("HumanoidRootPart"))
    if not primary then return end

    local pos = primary.Position
    if (pos - TARGET_POS).Magnitude <= ALLOWED_RADIUS then
        -- Otorgar win
        local _, wins = ensureLeaderstats(player)
        wins.Value = wins.Value + 1
        print("[GiveWin] Otorgada 1 win a", player.Name, "nueva:", wins.Value)
    else
        warn("[GiveWin] Petición fuera de rango de", player.Name, "pos:", pos)
    end
end)

print("[GiveWin] Handler cargado. RemoteEvent:", ev:GetFullName())
