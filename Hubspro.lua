local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Samigupro Hub | v1.5 Remazter",
    SubTitle = "UltraHub Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 320),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl 
})

-- --- CONFIGURACIÓN REMASTERIZADA ---
local Config = {
    WalkSpeed = 16,
    NoclipEnabled = false,
    ESP_Boxes = false,
    ESP_Names = false,
    Language = "Español"
}

-- --- TRADUCCIONES REMASTERIZADAS ---
local Locales = {
    ["Español"] = {
        Player = "Gestión de Jugador", ESP = "Visualización ESP", TP = "Teletransportación", Sett = "Configuración",
        Speed = "Ajuste de Velocidad", Noc = "Atravesar Paredes", Box = "Rastreador de Cuadros", Name = "Etiquetas de Nombre",
        Select = "Seleccionar Objetivo", Go = "Ejecutar Teleporte", Theme = "Estética del Panel",
        Lang = "Idioma del Sistema", Cred = "Autor: Samigupro (User: roblox)", Desc = "v1.5 Remazter | UltraHub Estable"
    },
    ["English"] = {
        Player = "Player Management", ESP = "ESP Visuals", TP = "Teleportation", Sett = "System Settings",
        Speed = "Movement Speed", Noc = "Noclip Mode", Box = "Box Tracker", Name = "Name Tags",
        Select = "Select Target", Go = "Execute Teleport", Theme = "Panel Aesthetics",
        Lang = "System Language", Cred = "Author: Samigupro (User: roblox)", Desc = "v1.5 Remazter | Stable UltraHub"
    }
}

-- --- BOTÓN FLOTANTE REMASTERIZADO ---
local OpenButton = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainButton = Instance.new("TextButton", OpenButton)
OpenButton.ResetOnSpawn = false
MainButton.Size = UDim2.fromOffset(60, 60)
MainButton.Position = UDim2.new(0, 15, 0.5, -30)
MainButton.Text = "S"
MainButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Font = Enum.Font.GothamBold
MainButton.TextSize = 32
Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 30) -- Más redondeado
local Stroke = Instance.new("UIStroke", MainButton)
Stroke.Thickness = 2.5
Stroke.Color = Color3.fromRGB(0, 255, 150)
MainButton.MouseButton1Click:Connect(function() Window:Minimize() end)

-- --- PESTAÑAS ---
local Tabs = {
    Main = Window:AddTab({ Title = "Jugador", Icon = "user" }),
    ESP = Window:AddTab({ Title = "Visuales", Icon = "eye" }),
    Teleport = Window:AddTab({ Title = "Teleporte", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Ajustes", Icon = "settings" })
}

local SpdInp, NocTog, BoxTog, NamTog, TPDrop, TPBtn, ThemeDrop, LangDrop, CredPar

-- --- MOTOR DE CONTROL (OPTIMIZADO PARA DELTA) ---
game:GetService("RunService").Stepped:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
        if Config.NoclipEnabled then
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

SpdInp = Tabs.Main:AddInput("Spd", { Title = "Velocidad", Default = "16", Callback = function(v)
    Config.WalkSpeed = tonumber(v) or 16
end})

NocTog = Tabs.Main:AddToggle("Noc", { Title = "Atravesar Paredes", Default = false, Callback = function(v)
    Config.NoclipEnabled = v
end})

-- --- SISTEMA ESP REMASTERIZADO ---
local function ApplyESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local b = hrp:FindFirstChild("S_Box")
                if Config.ESP_Boxes then
                    if not b then
                        b = Instance.new("BoxHandleAdornment", hrp)
                        b.Name = "S_Box"; b.Size = Vector3.new(4, 6, 0.5); b.AlwaysOnTop = true
                        b.Adornee = p.Character; b.Color3 = Color3.fromRGB(255, 0, 0); b.Transparency = 0.6
                    end
                elseif b then b:Destroy() end
            end
            local head = p.Character:FindFirstChild("Head")
            if head then
                local n = head:FindFirstChild("S_Name")
                if Config.ESP_Names then
                    if not n then
                        n = Instance.new("BillboardGui", head)
                        n.Name = "S_Name"; n.Size = UDim2.new(0, 100, 0, 20); n.AlwaysOnTop = true; n.ExtentsOffset = Vector3.new(0, 3, 0)
                        local l = Instance.new("TextLabel", n)
                        l.BackgroundTransparency = 1; l.Size = UDim2.new(1, 0, 1, 0); l.Text = p.Name
                        l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextSize = 13; l.Font = Enum.Font.GothamBold
                    end
                elseif n then n:Destroy() end
            end
        end
    end
end

BoxTog = Tabs.ESP:AddToggle("B", {Title = "Rastreador de Cuadros", Callback = function(v) Config.ESP_Boxes = v ApplyESP() end})
NamTog = Tabs.ESP:AddToggle("N", {Title = "Etiquetas de Nombre", Callback = function(v) Config.ESP_Names = v ApplyESP() end})
task.spawn(function() while task.wait(3) do ApplyESP() end end)

-- --- TELEPORTACIÓN ---
TPDrop = Tabs.Teleport:AddDropdown("D", { Title = "Seleccionar Objetivo", Values = {} })
local function RefreshPlayers() 
    local list = {} 
    for _, p in pairs(game.Players:GetPlayers()) do 
        if p ~= game.Players.LocalPlayer then table.insert(list, p.Name) end 
    end 
    TPDrop:SetValues(list) 
end
RefreshPlayers(); game.Players.PlayerAdded:Connect(RefreshPlayers); game.Players.PlayerRemoving:Connect(RefreshPlayers)

TPBtn = Tabs.Teleport:AddButton({ Title = "Ejecutar Teleporte", Callback = function()
    local target = game.Players:FindFirstChild(TPDrop.Value)
    if target and target.Character then 
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame 
    end
end})

-- --- IDIOMA Y ESTÉTICA ---
local function SetLang(l)
    local T = Locales[l]
    Tabs.Main.Title = T.Player; Tabs.ESP.Title = T.ESP; Tabs.Teleport.Title = T.TP; Tabs.Settings.Title = T.Sett
    SpdInp:SetTitle(T.Speed); NocTog:SetTitle(T.Noc); BoxTog:SetTitle(T.Box); NamTog:SetTitle(T.Name)
    TPDrop:SetTitle(T.Select); TPBtn:SetTitle(T.Go); ThemeDrop:SetTitle(T.Theme); LangDrop:SetTitle(T.Lang)
    CredPar:SetTitle(T.Cred); CredPar:SetText(T.Desc)
end

ThemeDrop = Tabs.Settings:AddDropdown("T", {
    Title = "Estética del Panel",
    Values = {"Dark", "Light", "Amethyst", "Aqua", "Rose"},
    Default = "Dark",
    Callback = function(v) 
        pcall(function() Window:SetTheme(v) end)
        local colors = {Amethyst = Color3.fromRGB(180, 100, 255), Aqua = Color3.fromRGB(0, 255, 255), Rose = Color3.fromRGB(255, 100, 200)}
        Stroke.Color = colors[v] or Color3.fromRGB(0, 255, 150)
    end
})

LangDrop = Tabs.Settings:AddDropdown("L", {
    Title = "Idioma del Sistema",
    Values = {"Español", "English"},
    Default = "Español",
    Callback = function(v) SetLang(v) end
})

CredPar = Tabs.Settings:AddParagraph({ Title = "Samigupro (User: roblox)", Content = "v1.5 Remazter | UltraHub Estable" })

Window:SelectTab(1)
