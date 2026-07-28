-- +1 Speed Keyboard Escape - Autofarm bbno$ Etapa 13 (Versión Final)
-- Hace exactamente la secuencia del video

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Keyboard Escape Autofarm",
   LoadingTitle = "Cargando...",
   LoadingSubtitle = "Etapa 13 bbno$",
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
      Duration = 2.5,
   })
end

Tab:CreateToggle({
   Name = "Autofarm Etapa 13",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value)
      autofarm = Value
      if Value then
         Notify("Autofarm", "Activado - Haciendo la ruta completa")
      else
         Notify("Autofarm", "Desactivado")
      end
   end,
})

Tab:CreateDropdown({
   Name = "Etapa",
   Options = {"12", "13", "14"},
   CurrentOption = {"13"},
   Callback = function(Option)
      selectedStage = tonumber(Option[1])
      Notify("Etapa", "Seleccionada: " .. selectedStage)
   end,
})

-- Función para hacer click seguro en botones
local function ClickGUI(text)
   local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
   
   for _, v in pairs(playerGui:GetDescendants()) do
      if v:IsA("TextButton") or v:IsA("ImageButton") then
         local txt = ""
         if v:IsA("TextButton") then
            txt = v.Text
         elseif v:FindFirstChild("TextLabel") then
            txt = v.TextLabel.Text
         elseif v:FindFirstChildWhichIsA("TextLabel") then
            txt = v:FindFirstChildWhichIsA("TextLabel").Text
         end
         
         if txt and string.find(string.lower(txt), string.lower(text)) then
            pcall(function()
               if firesignal then
                  firesignal(v.MouseButton1Click)
               end
               if getconnections then
                  for _, conn in pairs(getconnections(v.MouseButton1Click)) do
                     conn:Fire()
                  end
               end
               v:Activate()
            end)
            return true
         end
      end
   end
   return false
end

-- Teleport completo (Teletransporte → Etapa X)
local function DoTeleport(stage)
   -- 1. Abrir menú Teletransporte
   ClickGUI("Teletransporte")
   task.wait(0.7)
   
   -- 2. Click en la etapa
   local stageName = "Etapa " .. stage
   ClickGUI(stageName)
   
   -- Por si no encuentra "Etapa 13", intenta solo el número
   task.wait(0.15)
   ClickGUI(tostring(stage))
   
   task.wait(1.4) -- Esperar a que teletransporte
end

-- Correr la etapa completa
local function RunFullStage()
   local player = game.Players.LocalPlayer
   local char = player.Character
   if not char then return end
   
   local hrp = char:FindFirstChild("HumanoidRootPart")
   local humanoid = char:FindFirstChild("Humanoid")
   if not hrp or not humanoid then return end
   
   humanoid.WalkSpeed = 300
   
   local start = tick()
   while autofarm and (tick() - start) < 18 do
      if not char or not char.Parent or not hrp.Parent then break end
      
      local look = hrp.CFrame.LookVector
      humanoid:Move(Vector3.new(look.X, 0, look.Z), false)
      
      -- Impulso fuerte para no quedarse atascado
      hrp.AssemblyLinearVelocity = Vector3.new(look.X * 110, hrp.AssemblyLinearVelocity.Y, look.Z * 110)
      
      task.wait(0.03)
   end
end

-- Bucle principal
task.spawn(function()
   while true do
      if autofarm then
         local char = game.Players.LocalPlayer.Character
         if char and char:FindFirstChild("HumanoidRootPart") then
            
            -- Paso 1 y 2: Abrir Teletransporte + click Etapa 13
            DoTeleport(selectedStage)
            
            -- Paso 3: Correr toda la ruta (roja + BBNOS + CORRE!)
            RunFullStage()
            
            -- Paso 4: Esperar a que cobren el cash y vuelvan al hub
            task.wait(3)
         else
            task.wait(1)
         end
      else
         task.wait(0.25)
      end
   end
end)

-- Anti AFK
task.spawn(function()
   while true do
      if autofarm then
         pcall(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
         end)
      end
      task.wait(45)
   end
end)

Notify("Listo", "Activa el toggle. Hará: Teletransporte → Etapa 13 → Correr ruta → Cobrar → Repetir")
