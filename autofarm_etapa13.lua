-- +1 Speed Keyboard Escape - Autofarm bbno$ (Etapa 13) MEJORADO
-- Rayfield UI

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Keyboard Escape | Autofarm",
   LoadingTitle = "Cargando...",
   LoadingSubtitle = "bbno$ Etapa 13",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false,
})

local Tab = Window:CreateTab("Autofarm", 4483362458)

local autofarm = false
local selectedStage = 13

local function Notify(title, content)
   Rayfield:Notify({
      Title = title,
      Content = content,
      Duration = 3,
   })
end

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

Tab:CreateDropdown({
   Name = "Seleccionar Etapa",
   Options = {"11", "12", "13", "14"},
   CurrentOption = {"13"},
   Flag = "StageSelect",
   Callback = function(Option)
      selectedStage = tonumber(Option[1])
      Notify("Etapa", "Ahora farmando Etapa "..selectedStage)
   end,
})

-- Función para encontrar y hacer click en un botón por texto
local function ClickButtonByText(text)
   local player = game.Players.LocalPlayer
   local playerGui = player:WaitForChild("PlayerGui")
   
   for _, gui in pairs(playerGui:GetDescendants()) do
      if gui:IsA("TextButton") or gui:IsA("ImageButton") or gui:IsA("TextLabel") then
         local buttonText = ""
         
         if gui:IsA("TextButton") or gui:IsA("TextLabel") then
            buttonText = gui.Text
         elseif gui:FindFirstChild("TextLabel") then
            buttonText = gui.TextLabel.Text
         elseif gui:FindFirstChildWhichIsA("TextLabel") then
            buttonText = gui:FindFirstChildWhichIsA("TextLabel").Text
         end
         
         if buttonText and string.find(string.lower(buttonText), string.lower(text)) then
            -- Intentar varias formas de click
            pcall(function()
               if firesignal then
                  firesignal(gui.MouseButton1Click)
               end
            end)
            pcall(function()
               if gui.Activated then
                  gui.Activated:Fire()
               end
            end)
            pcall(function()
               gui:Activate()
            end)
            return true
         end
      end
   end
   return false
end

-- Función principal de teleport
local function TeleportToStage(stage)
   -- 1. Click en el botón Teletransporte (izquierda)
   local clicked = ClickButtonByText("Teletransporte")
   if not clicked then
      ClickButtonByText("Teleport")
   end
   
   task.wait(0.6) -- Esperar a que se abra el menú
   
   -- 2. Click en la etapa específica
   local stageText = "Etapa " .. stage
   local success = ClickButtonByText(stageText)
   
   if not success then
      -- Intentar otras variantes
      ClickButtonByText("Stage " .. stage)
      ClickButtonByText(tostring(stage))
   end
   
   task.wait(1.2) -- Esperar a que teletransporte
end

-- Función para correr la etapa
local function RunStage()
   local player = game.Players.LocalPlayer
   local char = player.Character
   if not char then return end
   
   local hrp = char:FindFirstChild("HumanoidRootPart")
   local humanoid = char:FindFirstChild("Humanoid")
   if not hrp or not humanoid then return end
   
   humanoid.WalkSpeed = 300
   
   local startTime = tick()
   while autofarm and (tick() - startTime) < 22 do
      if not char or not char.Parent or not hrp or not hrp.Parent then break end
      
      -- Mover hacia adelante
      local look = hrp.CFrame.LookVector
      humanoid:Move(Vector3.new(look.X, 0, look.Z), false)
      
      -- Impulso extra
      hrp.AssemblyLinearVelocity = Vector3.new(look.X * 90, hrp.AssemblyLinearVelocity.Y, look.Z * 90)
      
      task.wait(0.04)
   end
end

-- Bucle principal
task.spawn(function()
   while true do
      if autofarm then
         local player = game.Players.LocalPlayer
         local char = player.Character
         
         if char and char:FindFirstChild("HumanoidRootPart") then
            -- 1. Abrir Teletransporte y seleccionar etapa
            TeleportToStage(selectedStage)
            
            -- 2. Correr la ruta
            RunStage()
            
            -- 3. Esperar a que termine y vuelva al hub
            task.wait(2.5)
         else
            task.wait(1)
         end
      else
         task.wait(0.3)
      end
   end
end)

-- Anti AFK
task.spawn(function()
   while true do
      if autofarm then
         pcall(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
         end)
      end
      task.wait(50)
   end
end)

Notify("Script listo", "Activa el Autofarm. Va a hacer click en Teletransporte → Etapa 13 automáticamente")
