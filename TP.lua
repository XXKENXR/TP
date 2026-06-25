local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "*Kenscript* 🍫+1 Escapa del teclado🍩",
   LoadingTitle = "Cargando...",
   LoadingSubtitle = "by xxkenxr",
   ConfigurationSaving = { Enabled = false },
})

-- ==================== KEY SYSTEM ====================
local KeyTab = Window:CreateTab("Key System", 4483362458)

KeyTab:CreateInput({
   Name = "Key",
   PlaceholderText = "Ingresa la clave...",
   Callback = function(Value)
      if Value == "XKR" then
         Rayfield:Notify({
            Title = "✅ Key Correcta",
            Content = "Acceso concedido",
            Duration = 4,
         })
         loadMainMenu()
      else
         Rayfield:Notify({
            Title = "❌ Key Incorrecta",
            Content = "Key Invalid",
            Duration = 3,
         })
      end
   end,
})

KeyTab:CreateParagraph({
   Title = "Nota",
   Content = "El mejor script",
})

-- ==================== MENÚ PRINCIPAL ====================
function loadMainMenu()
   -- Cerramos el tab de Key System y creamos el nuevo
   local MainTab = Window:CreateTab("Teleports", 4483362458)

   MainTab:CreateButton({
      Name = "Etapa 16 TP",
      Callback = function()
         local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
         if root then
            root.CFrame = CFrame.new(7961, 720, 5144)
         end
      end,
   })
end

print("🔒 Kenscript cargado - Key: XKR")