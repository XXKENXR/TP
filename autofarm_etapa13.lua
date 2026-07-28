-- +1 Speed Keyboard Escape - Autofarm bbno$ (Etapa 13)
-- Rayfield UI

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Keyboard Escape | Autofarm",
   LoadingTitle = "Cargando Autofarm...",
   LoadingSubtitle = "bbno$ World",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

local Tab = Window:CreateTab("Autofarm", 4483362458)

local autofarm = false
local selectedStage = 13 -- Cambia a 14 si quieres Etapa 14

-- Notificación
local function Notify(title, content)
   Rayfield:Notify({
      Title = title,
      Content = content,
      Duration = 3,
   })
end

-- Toggle principal
Tab:CreateToggle({
   Name = "Autofarm (Etapa 13)",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value)
      autofarm = Value
      if Value then
         Notify("Autofarm", "Activado - Farmando Etapa "..selectedStage)
      else
         Notify("Autofarm", "Desactivado")
      end
   end,
})

-- Selector de etapa
Tab:CreateDropdown({
   Name = "Seleccionar Etapa",
   Options = {"11","12","13","14"},
   CurrentOption = {"13"},
   Flag = "StageSelect",
   Callback = function(Option)
      selectedStage = tonumber(Option[1])
      Notify("Etapa", "Ahora farmando Etapa "..selectedStage)
   end,
})

-- Función para teletransportarse a la etapa (usando el GUI del juego)
local function TeleportToStage(stage)
   local player = game.Players.LocalPlayer
   local playerGui = player:WaitForChild("PlayerGui")
   
   -- Intentar abrir el menú de teletransporte
   local success, err = pcall(function()
      -- Buscar el botón de teletransporte en la UI izquierda
      for _, gui in pairs(playerGui:GetDescendants()) do
         if gui:IsA("ImageButton") or gui:IsA("TextButton") then
            local name = string.lower(gui.Name)
            if name:find("teleport") or name:find("tp") or name:find("etapa") then
               -- Simular click si es posible
               if firesignal then
                  firesignal(gui.MouseButton1Click)
               end
            end
         end
      end
   end)
   
   task.wait(0.4)
   
   -- Buscar y clickear la etapa específica
   pcall(function()
      for _, gui in pairs(playerGui:GetDescendants()) do
         if gui:IsA("TextButton") or gui:IsA("ImageButton") then
            local text = ""
            if gui:FindFirstChild("TextLabel") then
               text = gui.TextLabel.Text
            elseif gui:IsA("TextButton") then
               text = gui.Text
            end
            
            if text:find("Etapa "..stage) or text:find("Stage "..stage) then
               if firesignal then
                  firesignal(gui.MouseButton1Click)
               elseif gui.Activated then
                  gui.Activated:Fire()
               end
               break
            end
         end
      end
   end)
end

-- Función de movimiento hacia adelante (correr la etapa)
local function RunStage()
   local player = game.Players.LocalPlayer
   local char = player.Character or player.CharacterAdded:Wait()
   local hrp = char:WaitForChild("HumanoidRootPart")
   local humanoid = char:WaitForChild("Humanoid")
   
   -- Mantener velocidad alta
   humanoid.WalkSpeed = 300
   
   -- Moverse hacia adelante continuamente
   local startTime = tick()
   while autofarm and (tick() - startTime) < 25 do -- máximo 25 segundos por etapa
      if not char or not char.Parent or not hrp then break end
      
      -- Dirección hacia adelante
      local lookVector = hrp.CFrame.LookVector
      humanoid:Move(Vector3.new(lookVector.X, 0, lookVector.Z), false)
      
      -- Pequeño impulso extra por si acaso
      hrp.Velocity = Vector3.new(lookVector.X * 80, hrp.Velocity.Y, lookVector.Z * 80)
      
      task.wait(0.05)
   end
end

-- Bucle principal del Autofarm
task.spawn(function()
   while true do
      if autofarm then
         local player = game.Players.LocalPlayer
         local char = player.Character
         if not char or not char:FindFirstChild("HumanoidRootPart") then
            task.wait(1)
         else
            -- 1. Teleport a la etapa
            TeleportToStage(selectedStage)
            task.wait(1.2)
            
            -- 2. Correr la etapa
            RunStage()
            
            -- 3. Esperar un poco a que se complete y vuelva al hub
            task.wait(2)
         end
      else
         task.wait(0.4)
      end
   end
end)

-- Anti-AFK simple
task.spawn(function()
   while true do
      if autofarm then
         local VirtualUser = game:GetService("VirtualUser")
         VirtualUser:CaptureController()
         VirtualUser:ClickButton2(Vector2.new())
      end
      task.wait(60)
   end
end)

Notify("Script cargado", "Activa el toggle Autofarm para empezar")
