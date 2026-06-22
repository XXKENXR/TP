loadstring([[
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local HEIGHT_OFFSET = 5

local function TeleportTo(x, y, z)
    local character = LocalPlayer.Character
    if not character then 
        warn("❌ No tienes personaje") 
        return 
    end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then 
        warn("❌ HumanoidRootPart no encontrado") 
        return 
    end
    
    root.CFrame = CFrame.new(Vector3.new(x, y + HEIGHT_OFFSET, z))
    print("✅ Teletransportado a X:" .. x .. " | Y:" .. y .. " | Z:" .. z)
end

-- TP AUTOMÁTICO a tus coordenadas
TeleportTo(7961, 715, 5144)

-- Comandos extras
getgenv().TP = function(x, y, z)
    if x and y and z then
        TeleportTo(x, y, z)
    else
        warn("❌ Usa: TP(x, y, z)")
    end
end

getgenv().GetPos = function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local pos = root.Position
        print("📍 Tu posición actual: X:" .. pos.X .. " | Y:" .. pos.Y .. " | Z:" .. pos.Z)
        return pos
    end
end

print("🚀 TP cargado correctamente")
print("→ Ya te moviste a las coordenadas deseadas")
]])()
