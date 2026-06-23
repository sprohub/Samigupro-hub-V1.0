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

local Config = {
    WalkSpeed = 16,
    NoclipEnabled = false,
    InfJump = false,
    FullBright = false,
    FOV = 70,
    ESP_Boxes = false,
    ESP_Names = false,
    ESP_Chams = false,
    Language = "Español"
}

-- [DICCIONARIO REMASTERIZADO]
local Locales = {
    ["Español"] = {
        Player = "Gestión de Jugador", ESP = "Visualización ESP", TP = "Teletransportación", Sett = "Configuración",
        Speed = "Ajuste de Velocidad", Noc = "Atravesar Paredes", Box = "Rastreador de Cuadros", Name = "Etiquetas de Nombre",
        Chams = "Resaltar Cuerpo (Wallhack)", Select = "Seleccionar Objetivo", Go = "Ejecutar Teleporte", 
        Theme = "Estética del Panel", Lang = "Idioma del Sistema", Cred = "Autor: Samigupro (User: roblox)", 
        Desc = "v1.5 Remazter | UltraHub Estable", Jump = "Salto Infinito", Bright = "Brillo Total", FovT = "Campo de Visión (FOV)"
    },
    ["English"] = {
        Player = "Player Management", ESP = "ESP Visuals", TP = "Teleportation", Sett = "Settings",
        Speed = "Movement Speed", Noc = "Noclip Mode", Box = "Box Tracker", Name = "Name Tags",
        Chams = "Highlight Body (Wallhack)", Select = "Select Target", Go = "Execute Teleport", 
        Theme = "Panel Aesthetics", Lang = "System Language", Cred = "Author: Samigupro (User: roblox)", 
        Desc = "v1.5 Remazter | Stable UltraHub", Jump = "Infinite Jump", Bright = "Full Bright", FovT = "Field of View (FOV)"
    }
}

-- BOTÓN FLOTANTE S
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
Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 30)
local Stroke = Instance.new("UIStroke", MainButton)
Stroke.Thickness = 2.5
Stroke.Color = Color3.fromRGB(0, 255, 150)
MainButton.MouseButton1Click:Connect(function() Window:Minimize() end)

local Tabs = {
    Main = Window:AddTab({ Title = "Jugador", Icon = "user" }),
    ESP = Window:AddTab({ Title = "Visuales", Icon = "eye" }),
    Teleport = Window:AddTab({ Title = "Teleporte", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Ajustes", Icon = "settings" })
}

-- MOTOR DE CONTROL MEJORADO (No bloquea el táctil)
game:GetService("RunService").Heartbeat:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = Config.WalkSpeed
        
        if Config.NoclipEnabled then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

-- SALTO INFINITO
game:GetService("UserInputService").JumpRequest:Connect(function()
    if Config.InfJump and game.Players.LocalPlayer.Character then
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)

local SpdInp = Tabs.Main:AddInput("Spd", { Title = "Ajuste de Velocidad", Default = "16", Callback = function(v) Config.WalkSpeed = tonumber(v) or 16 end})
local NocTog = Tabs.Main:AddToggle("Noc", { Title = "Atravesar Paredes", Default = false, Callback = function(v) Config.NoclipEnabled = v end})
local JumpTog = Tabs.Main:AddToggle("Jump", { Title = "Salto Infinito", Default = false, Callback = function(v) Config.InfJump = v end})

-- SLIDER DE FOV (REPARADO PARA TÁCTIL)
local FovSlid = Tabs.Main:AddSlider("Fov", { 
    Title = "Campo de Visión (FOV)", 
    Default = 70, 
    Min = 70, 
    Max = 120, 
    Rounding = 0, 
    Callback = function(v) 
        Config.FOV = v 
        -- El FOV ahora se aplica solo al cambiar el slider, no en bucle infinito
        workspace.CurrentCamera.FieldOfView = v 
    end
})

local BrightTog = Tabs.Main:AddToggle("Bright", { Title = "Brillo Total", Default = false, Callback = function(v) 
    Config.FullBright = v 
    local L = game:GetService("Lighting")
    if not v then
        L.Brightness = 1; L.ClockTime = 12; L.GlobalShadows = true
    else
        L.Brightness = 2; L.ClockTime = 14; L.GlobalShadows = false
    end
end})

-- --- SISTEMA ESP ---
local function ApplyESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local char = p.Character
            -- Cajas
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local b = hrp:FindFirstChild("S_Box")
                if Config.ESP_Boxes then
                    if not b then
                        b = Instance.new("BoxHandleAdornment", hrp)
                        b.Name = "S_Box"; b.Size = Vector3.new(4, 6, 0.5); b.AlwaysOnTop = true; b.Adornee = char; b.Color3 = Color3.fromRGB(255, 0, 0); b.Transparency = 0.6
                    end
                elseif b then b:Destroy() end
            end
            -- Nombres
            local head = char:FindFirstChild("Head")
            if head then
                local n = head:FindFirstChild("S_Name")
                if Config.ESP_Names then
                    if not n then
                        n = Instance.new("BillboardGui", head)
                        n.Name = "S_Name"; n.Size = UDim2.new(0, 100, 0, 20); n.AlwaysOnTop = true; n.ExtentsOffset = Vector3.new(0, 3, 0)
                        local l = Instance.new("TextLabel", n)
                        l.BackgroundTransparency = 1; l.Size = UDim2.new(1, 0, 1, 0); l.Text = p.Name; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextSize = 13; l.Font = Enum.Font.GothamBold
                    end
                elseif n then n:Destroy() end
            end
            -- Chams
            local ch = char:FindFirstChild("S_Chams")
            if Config.ESP_Chams then
                if not ch then
                    ch = Instance.new("Highlight", char)
                    ch.Name = "S_Chams"; ch.FillColor = Color3.fromRGB(255, 0, 0); ch.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            elseif ch then ch:Destroy() end
        end
    end
end

local BoxTog = Tabs.ESP:AddToggle("B", {Title = "Rastreador de Cuadros", Callback = function(v) Config.ESP_Boxes = v ApplyESP() end})
local NamTog = Tabs.ESP:AddToggle("N", {Title = "Etiquetas de Nombre", Callback = function(v) Config.ESP_Names = v ApplyESP() end})
local ChamsTog = Tabs.ESP:AddToggle("C", {Title = "Resaltar Cuerpo (Wallhack)", Callback = function(v) Config.ESP_Chams = v ApplyESP() end})
task.spawn(function() while task.wait(3) do ApplyESP() end end)

-- --- TELEPORTE ---
local TPDrop = Tabs.Teleport:AddDropdown("D", { Title = "Seleccionar Objetivo", Values = {} })
local function RefreshPlayers() 
    local list = {} 
    for _, p in pairs(game.Players:GetPlayers()) do if p ~= game.Players.LocalPlayer then table.insert(list, p.Name) end end 
    TPDrop:SetValues(list) 
end
RefreshPlayers(); game.Players.PlayerAdded:Connect(RefreshPlayers); game.Players.PlayerRemoving:Connect(RefreshPlayers)
local TPBtn = Tabs.Teleport:AddButton({ Title = "Ejecutar Teleporte", Callback = function()
    local target = game.Players:FindFirstChild(TPDrop.Value)
    if target and target.Character then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame end
end})

-- --- IDIOMA Y TEMAS ---
local function SetLang(l)
    local T = Locales[l]
    Tabs.Main.Title = T.Player; Tabs.ESP.Title = T.ESP; Tabs.Teleport.Title = T.TP; Tabs.Settings.Title = T.Sett
    SpdInp:SetTitle(T.Speed); NocTog:SetTitle(T.Noc); JumpTog:SetTitle(T.Jump); FovSlid:SetTitle(T.FovT); BrightTog:SetTitle(T.Bright)
    BoxTog:SetTitle(T.Box); NamTog:SetTitle(T.Name); ChamsTog:SetTitle(T.Chams)
    TPDrop:SetTitle(T.Select); TPBtn:SetTitle(T.Go); ThemeDrop:SetTitle(T.Theme); LangDrop:SetTitle(T.Lang)
    CredPar:SetTitle(T.Cred); CredPar:SetText(T.Desc)
end

local ThemeDrop = Tabs.Settings:AddDropdown("T", { Title = "Estética del Panel", Values = {"Dark", "Light", "Amethyst", "Aqua", "Rose"}, Default = "Dark", Callback = function(v) pcall(function() Window:SetTheme(v) end) end })
local LangDrop = Tabs.Settings:AddDropdown("L", { Title = "Idioma del Sistema", Values = {"Español", "English"}, Default = "Español", Callback = function(v) SetLang(v) end })
local CredPar = Tabs.Settings:AddParagraph({ Title = "Samigupro (User: roblox)", Content = "v1.5 Remazter | UltraHub Estable" })

Window:SelectTab(1)
