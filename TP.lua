local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "*Kenscript* +1 Escapa del teclado",
   LoadingTitle = "Cargando...",
   LoadingSubtitle = "by xxkenxr",
   ConfigurationSaving = { Enabled = false },
})

-- Key System
local KeyTab = Window:CreateTab("Key System", 4483362458)

KeyTab:CreateInput({
   Name = "Key",
   PlaceholderText = "Ingresa la clave...",
   Callback = function(Value)
      if Value == "XKR" then
         Rayfield:Notify({Title = "✅ Key Correcta", Content = "Acceso concedido", Duration = 4})
         loadMainMenu()
      else
         Rayfield:Notify({Title = "❌ Key Incorrecta", Content = "Key Invalid", Duration = 3})
      end
   end,
})

KeyTab:CreateParagraph({Title = "Nota", Content = "El mejor script"})

-- Temporizador en pantalla
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0, 180, 0, 40)
TimerLabel.Position = UDim2.new(0.5, -90, 0.1, 0)
TimerLabel.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.TextScaled = true
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.Text = "Temporizador: 45s"
TimerLabel.Visible = false
TimerLabel.Active = true
TimerLabel.Draggable = true
TimerLabel.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local function startTimer()
   TimerLabel.Visible = true
   local t = 45
   spawn(function()
      while t > 0 do
         TimerLabel.Text = "Temporizador: " .. t .. "s"
         wait(1)
         t -= 1
      end
      TimerLabel.Text = "Temporizador: 0s"
   end)
end

-- ==================== AUTO WALK ESTILO ORVA ====================
local RunService = game:GetService("RunService")
local autoWalking = false
local walkConnection = nil

local function toggleAutoWalk(state)
   autoWalking = state
   local player = game.Players.LocalPlayer
   local character = player.Character
   if not character then return end
   local humanoid = character:FindFirstChild("Humanoid")
   if not humanoid then return end

   if state then
      Rayfield:Notify({Title = "Auto Walk ON", Content = "Recorriendo etapas hacia 200M wins...", Duration = 5})
      walkConnection = RunService.Heartbeat:Connect(function()
         if humanoid and autoWalking then
            humanoid:Move(Vector3.new(0.8, 0, 0.6), true) -- Movimiento diagonal natural
            if math.random(1, 20) == 1 then
               humanoid.Jump = true
            end
         end
      end)
   else
      if walkConnection then 
         walkConnection:Disconnect() 
      end
      Rayfield:Notify({Title = "Auto Walk OFF", Content = "Detenido", Duration = 3})
   end
end

-- ==================== REMOVE OBSTACLES MEJORADO ====================
local obstaclesRemoved = false

local function toggleRemoveObstacles(state)
   obstaclesRemoved = state
   if state then
      Rayfield:Notify({Title = "Remove Obstacles ON", Content = "Eliminando barreras...", Duration = 4})
      spawn(function()
         while obstaclesRemoved do
            for _, v in pairs(workspace:GetDescendants()) do
               if v:IsA("BasePart") and v.CanCollide and v.Transparency < 1 then
                  local name = v.Name:lower()
                  if name:find("wall") or name:find("obstacle") or name:find("barrier") or name:find("floor") or v.Size.Y > 5 then
                     v.CanCollide = false
                     v.Transparency = 0.6
                  end
               end
            end
            wait(1.5)
         end
      end)
   else
      Rayfield:Notify({Title = "Remove Obstacles OFF", Content = "Reactivado", Duration = 3})
   end
end

-- ==================== MENÚ ====================
function loadMainMenu()
   local MainTab = Window:CreateTab("Teleports", 4483362458)

   MainTab:CreateButton({
      Name = "Etapa 16 TP",
      Callback = function()
         local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
         if root then
            root.CFrame = CFrame.new(7961, 720, 5144)
            startTimer()
         end
      end,
   })

   MainTab:CreateToggle({
      Name = "Auto Walk (Recorre Etapas)",
      CurrentValue = false,
      Callback = function(Value)
         toggleAutoWalk(Value)
      end,
   })

   MainTab:CreateToggle({
      Name = "Remove Obstacles",
      CurrentValue = false,
      Callback = function(Value)
         toggleRemoveObstacles(Value)
      end,
   })
end

print("🔒 Kenscript cargado - Usa la clave XKR")