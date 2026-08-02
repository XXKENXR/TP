-- LocalScript (ponlo en StarterPlayerScripts o en StarterCharacterScripts)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function teleport()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	
	hrp.CFrame = CFrame.new(0, 61, -9028)
end

-- Se teletransporta automáticamente al cargar el personaje
player.CharacterAdded:Connect(function()
	task.wait(0.1) -- pequeño delay para que cargue bien
	teleport()
end)

-- También se puede activar manualmente (opcional)
-- teleport()
