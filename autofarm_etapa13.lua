--[[
    +1 Speed / Keyboard Escape
    Autofarm Etapa 13 + Control de Velocidad (hasta 300)
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Keyboard Escape | Autofarm",
   LoadingTitle = "Cargando...",
   LoadingSubtitle = "Etapa 13",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

local Tab = Window:CreateTab("Main", 4483362458)

local autofarm = false
local selectedStage = 13
local currentSpeed = 300 -- velocidad por defecto

local function Notify(title, text)
   Rayfield:Notify({
      Title = title,
      Content = text,
      Duration = 2.5,
   })
end

-------------------------------------------------
-- TOGGLE AUTOFARM
-------------------------------------------------
Tab:CreateToggle({
   Name = "Autofarm",
   CurrentValue = false,
   Flag = "AutofarmToggle",
   Callback = function(Value)
      autofarm = Value
      if Value then
         Notify("Autofarm", "Activado - Etapa " .. selectedStage .. " | Velocidad: " .. currentSpeed)
      else
         Notify("Autofarm", "Desactivado")
      end
   end,
})

-------------------------------------------------
-- SLIDER DE VELOCIDAD (hasta 300)
-------------------------------------------------
Tab:CreateSlider({
   Name = "Velocidad",
   Range = {16, 300},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 300,
   Flag = "SpeedSlider",
   Callback = function(Value)
      currentSpeed = Value
      -- Aplicar inmediatamente si el personaje existe
      local char = game.Players.LocalPlayer.Character
      if char then
         local humanoid = char:FindFirstChildOfClass("Humanoid")
         if humanoid then
            humanoid.WalkSpeed = currentSpeed
         end
      end
   end,
})

-------------------------------------------------
-- SELECCIONAR ETAPA
-------------------------------------------------
Tab:CreateDropdown({
   Name = "Seleccionar Etapa",
   Options = {"11", "12", "13", "14"},
   CurrentOption = {"13"},
   MultipleOptions = false,
   Flag = "StageDropdown",
   Callback = function(Option)
      selectedStage = tonumber(Option[1])
      Notify("Etapa", "Cambiada a Etapa " .. selectedStage)
   end,
})

-------------------------------------------------
-- FUNCIÓN PARA HACER CLICK
-------------------------------------------------
local function ClickButton(text)
   local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
   if not playerGui then return false end

   for _, v in pairs(playerGui:GetDescendants()) do
      if (v:IsA("TextButton") or v:IsA("ImageButton")) and v.Visible then
         local buttonText = ""

         if v:IsA("TextButton") then
            buttonText = v.Text or ""
         end

         local label = v:FindFirstChildWhichIsA("TextLabel")
         if label then
            buttonText = label.Text or buttonText
         end

         if buttonText ~= "" and string.find(string.lower(buttonText), string.lower(text)) then
            pcall(function()
               if firesignal then
                  firesignal(v.MouseButton1Click)
                  firesignal(v.Activated)
               end
               if getconnections then
                  for _, conn in pairs(getconnections(v.MouseButton1Click)) do
                     pcall(function() conn:Fire() end)
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

-------------------------------------------------
-- TELEPORT
-------------------------------------------------
local function TeleportToStage(stage)
   ClickButton("Teletransporte")
   task.wait(0.65)
   ClickButton("Etapa " .. stage)
   task.wait(0.15)
   ClickButton(tostring(stage))
   task.wait(1.3)
end

-------------------------------------------------
-- CORRER LA ETAPA
-------------------------------------------------
local function RunStage()
   local player = game.Players.LocalPlayer
   local char = player.Character
   if not char then return end

   local hrp = char:FindFirstChild("HumanoidRootPart")
   local humanoid = char:FindFirstChildOfClass("Humanoid")
   if not hrp or not humanoid then return end

   humanoid.WalkSpeed = currentSpeed

   local startTime = tick()
   while autofarm and (tick() - startTime) < 17 do
      if not char or not char.Parent or not hrp or not hrp.Parent then
         break
      end

      local look = hrp.CFrame.LookVector
      local moveDir = Vector3.new(look.X, 0, look.Z).Unit

      humanoid:Move(moveDir, false)
      hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * (currentSpeed * 0.38), hrp.AssemblyLinearVelocity.Y, moveDir.Z * (currentSpeed * 0.38))

      task.wait(0.03)
   end
end

-------------------------------------------------
-- BUCLE PRINCIPAL
-------------------------------------------------
task.spawn(function()
   while true do
      if autofarm then
         local char = game.Players.LocalPlayer.Character
         if char and char:FindFirstChild("HumanoidRootPart") then
            TeleportToStage(selectedStage)
            RunStage()
            task.wait(2.8)
         else
            task.wait(1)
         end
      else
         task.wait(0.25)
      end
   end
end)

-------------------------------------------------
-- ANTI AFK
-------------------------------------------------
task.spawn(function()
   local VirtualUser = game:GetService("VirtualUser")
   while true do
      if autofarm then
         pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
         end)
      end
      task.wait(40)
   end
end)

Notify("Listo", "Slider de velocidad hasta 300 agregado")
