local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- =================================================================
-- KONFIGURASI TOTAL LOKASI
-- =================================================================
local TotalLocations = 7 -- Tetap 7 lokasi sesuai request Yahayuk

-- =================================================================
-- 1. BERSIHKAN UI SEBELUMNYA
-- =================================================================
local guisToDelete = {"FluentMountHud", "VeloraMountUI", "YahayukMountUI"}
for _, name in pairs(guisToDelete) do
    if game.CoreGui:FindFirstChild(name) then
        game.CoreGui[name]:Destroy()
    end
end

-- =================================================================
-- 2. DATABASE LOKASI (MOUNT YAHAYUK)
-- =================================================================
local MountLocations = {
    ["1"] = CFrame.new(-421, 264, 782),
    ["2"] = CFrame.new(-338, 398, 522),
    ["3"] = CFrame.new(294, 445, 495),
    ["4"] = CFrame.new(323, 500, 347),
    ["5"] = CFrame.new(226, 325, -142),
    ["6"] = CFrame.new(-618, 910, -549),
    ["7"] = CFrame.new(-622, 943, -496)
}

-- =================================================================
-- 3. SYSTEM RGB GLOBAL
-- =================================================================
local RainbowRegistry = {} 

local function AddToRainbow(instance, propertyType)
    table.insert(RainbowRegistry, {Obj = instance, Type = propertyType})
end

-- =================================================================
-- 4. LOGIC UTAMA
-- =================================================================
local currentIdx = 1
local isAuto = false
local autoDelay = 1.5

local function TeleportTo(index)
    local key = tostring(index)
    local target = MountLocations[key]
    if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target
        -- Update HUD
        if game.CoreGui:FindFirstChild("FluentMountHud") then
            game.CoreGui.FluentMountHud.MountName.Text = "Yahayuk CP: " .. index
            game.CoreGui.FluentMountHud.MountName.Visible = true
        end
        return true
    end
    return false
end

-- =================================================================
-- 5. UI BUILD
-- =================================================================
local VeloraGui = Instance.new("ScreenGui")
VeloraGui.Name = "YahayukMountUI"
VeloraGui.Parent = game.CoreGui
VeloraGui.Enabled = true 
VeloraGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
VeloraGui.DisplayOrder = 50

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "RainbowFrame"
MainFrame.Parent = VeloraGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -125)
MainFrame.Size = UDim2.new(0, 420, 0, 250)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
AddToRainbow(MainFrame, "Background")

local UICornerMain = Instance.new("UICorner"); UICornerMain.CornerRadius = UDim.new(0, 10); UICornerMain.Parent = MainFrame

-- INNER FRAME
local InnerFrame = Instance.new("Frame")
InnerFrame.Name = "ContentFrame"
InnerFrame.Parent = MainFrame
InnerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
InnerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
InnerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
InnerFrame.Size = UDim2.new(1, -6, 1, -6)
InnerFrame.BorderSizePixel = 0
InnerFrame.ClipsDescendants = true
local UICornerInner = Instance.new("UICorner"); UICornerInner.CornerRadius = UDim.new(0, 8); UICornerInner.Parent = InnerFrame

-- TITLE BAR
local TitleBar = Instance.new("Frame")
TitleBar.Parent = InnerFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BorderSizePixel = 0
local TitleCorner = Instance.new("UICorner"); TitleCorner.CornerRadius = UDim.new(0, 8); TitleCorner.Parent = TitleBar

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Parent = TitleBar
TitleLbl.Text = "  ⚡ Mount Yahayuk Manager ⚡"
TitleLbl.Font = Enum.Font.GothamBlack
TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLbl.TextSize = 15
TitleLbl.Size = UDim2.new(1, -60, 1, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
AddToRainbow(TitleLbl, "Text")

-- CONTROL WINDOW BUTTONS
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TitleBar; MinBtn.Text = "-"; MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200); MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MinBtn.Position = UDim2.new(1, -55, 0, 0); MinBtn.Size = UDim2.new(0, 25, 1, 0); MinBtn.BorderSizePixel = 0

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar; CloseBtn.Text = "X"; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100); CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CloseBtn.Position = UDim2.new(1, -25, 0, 0); CloseBtn.Size = UDim2.new(0, 25, 1, 0); CloseBtn.BorderSizePixel = 0
local CloseCorner = Instance.new("UICorner"); CloseCorner.CornerRadius = UDim.new(0, 8); CloseCorner.Parent = CloseBtn

local isMin = false
CloseBtn.MouseButton1Click:Connect(function() VeloraGui.Enabled = false; isAuto = false end)
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        MainFrame:TweenSize(UDim2.new(0, 420, 0, 41), "Out", "Quad", 0.3, true)
    else
        MainFrame:TweenSize(UDim2.new(0, 420, 0, 250), "Out", "Quad", 0.3, true)
    end
end)

-- CONTENT
local ContentArea = Instance.new("Frame")
ContentArea.Parent = InnerFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 0, 0, 35)
ContentArea.Size = UDim2.new(1, 0, 1, -35)

-- >> KIRI: CONTROLS
local LeftPanel = Instance.new("Frame")
LeftPanel.Parent = ContentArea
LeftPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LeftPanel.Size = UDim2.new(0.45, 0, 1, 0)
LeftPanel.BorderSizePixel = 0

-- FUNGSI MEMBUAT TOMBOL NEON
local function CreateNeonButton(parent, text, pos, size)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Position = pos
    btn.Size = size
    btn.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = btn
    local stroke = Instance.new("UIStroke"); stroke.Parent = btn; stroke.Thickness = 1.5; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    AddToRainbow(btn, "Text")
    AddToRainbow(stroke, "Border")
    
    return btn
end

local BackBtn = CreateNeonButton(LeftPanel, "<", UDim2.new(0.05, 0, 0.05, 0), UDim2.new(0.42, 0, 0, 40))
BackBtn.TextSize = 18

local NextBtn = CreateNeonButton(LeftPanel, ">", UDim2.new(0.53, 0, 0.05, 0), UDim2.new(0.42, 0, 0, 40))
NextBtn.TextSize = 18

local AutoBtn = CreateNeonButton(LeftPanel, "Auto: OFF", UDim2.new(0.05, 0, 0.28, 0), UDim2.new(0.9, 0, 0, 40))

local DelayLabel = Instance.new("TextLabel"); DelayLabel.Parent = LeftPanel; DelayLabel.Text = "Delay (s):"; DelayLabel.BackgroundTransparency = 1; DelayLabel.TextColor3 = Color3.fromRGB(180, 180, 180); DelayLabel.Font = Enum.Font.Gotham; DelayLabel.Position = UDim2.new(0.05, 0, 0.52, 0); DelayLabel.Size = UDim2.new(0.4, 0, 0, 30); DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
local DelayInput = Instance.new("TextBox"); DelayInput.Parent = LeftPanel; DelayInput.Text = "1.5"; DelayInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); DelayInput.TextColor3 = Color3.fromRGB(255, 255, 255); DelayInput.Font = Enum.Font.GothamBold; DelayInput.Position = UDim2.new(0.5, 0, 0.52, 0); DelayInput.Size = UDim2.new(0.45, 0, 0, 30)
local DC = Instance.new("UICorner"); DC.CornerRadius = UDim.new(0, 6); DC.Parent = DelayInput
local DS = Instance.new("UIStroke"); DS.Parent = DelayInput; DS.Thickness = 1; DS.Color = Color3.fromRGB(80,80,80)

local ResetBtn = CreateNeonButton(LeftPanel, "RESET CP", UDim2.new(0.05, 0, 0.75, 0), UDim2.new(0.9, 0, 0, 40))

-- >> KANAN: LIST LANGSUNG
local RightPanel = Instance.new("Frame"); RightPanel.Parent = ContentArea; RightPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20); RightPanel.Position = UDim2.new(0.45, 0, 0, 0); RightPanel.Size = UDim2.new(0.55, 0, 1, 0); RightPanel.BorderSizePixel = 0
local ListLabel = Instance.new("TextLabel"); ListLabel.Parent = RightPanel; ListLabel.Text = "Pilih Checkpoint:"; ListLabel.BackgroundTransparency = 1; ListLabel.TextColor3 = Color3.fromRGB(150, 150, 150); ListLabel.Font = Enum.Font.GothamBold; ListLabel.Size = UDim2.new(1, 0, 0, 25); ListLabel.Position = UDim2.new(0, 0, 0.02, 0)
AddToRainbow(ListLabel, "Text")

local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Parent = RightPanel
ScrollList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ScrollList.Position = UDim2.new(0.05, 0, 0.15, 0)
ScrollList.Size = UDim2.new(0.9, 0, 0.8, 0)
ScrollList.Visible = true
ScrollList.ScrollBarThickness = 4
ScrollList.BorderSizePixel = 0
ScrollList.ZIndex = 5
ScrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)

local SLC = Instance.new("UICorner"); SLC.CornerRadius = UDim.new(0, 6); SLC.Parent = ScrollList
local UIL = Instance.new("UIListLayout"); UIL.Parent = ScrollList; UIL.SortOrder = Enum.SortOrder.LayoutOrder; UIL.Padding = UDim.new(0, 2)

-- FUNCTIONS
local function UpdateActiveButton(idx)
    currentIdx = idx
end

for i = 1, TotalLocations do
    local item = Instance.new("TextButton")
    item.Parent = ScrollList
    item.LayoutOrder = i
    item.Size = UDim2.new(1, 0, 0, 30)
    item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    item.BackgroundTransparency = 0.5
    item.Text = "  Checkpoint " .. i -- Sesuai request: CHECKPOINT
    item.TextColor3 = Color3.fromRGB(220, 220, 220)
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.Font = Enum.Font.GothamMedium
    item.TextSize = 12
    item.ZIndex = 6
    local ItemCorner = Instance.new("UICorner"); ItemCorner.CornerRadius = UDim.new(0,4); ItemCorner.Parent = item
    
    AddToRainbow(item, "Text")
    
    item.MouseButton1Click:Connect(function() 
        UpdateActiveButton(i) 
        TeleportTo(i) 
    end)
end

-- LOGIC TOMBOL
BackBtn.MouseButton1Click:Connect(function() if currentIdx > 1 then UpdateActiveButton(currentIdx - 1); TeleportTo(currentIdx) end end)
NextBtn.MouseButton1Click:Connect(function() if currentIdx < TotalLocations then UpdateActiveButton(currentIdx + 1); TeleportTo(currentIdx) end end)

DelayInput.FocusLost:Connect(function() local val = tonumber(DelayInput.Text); if val and val > 0 then autoDelay = val else DelayInput.Text = tostring(autoDelay) end end)
ResetBtn.MouseButton1Click:Connect(function() isAuto = false; AutoBtn.Text = "Auto: OFF"; UpdateActiveButton(1); TeleportTo(1) end)

AutoBtn.MouseButton1Click:Connect(function()
    isAuto = not isAuto
    if isAuto then
        AutoBtn.Text = "Auto: ON"
        task.spawn(function()
            while isAuto and currentIdx < TotalLocations do
                if not VeloraGui.Enabled then break end
                UpdateActiveButton(currentIdx + 1); TeleportTo(currentIdx)
                task.wait(autoDelay)
            end
            if currentIdx >= TotalLocations then isAuto = false; AutoBtn.Text = "Selesai" end
        end)
    else AutoBtn.Text = "Auto: OFF" end
end)

-- HUD SEDERHANA
local MountHud = Instance.new("ScreenGui"); MountHud.Name = "FluentMountHud"; MountHud.Parent = game.CoreGui
local MountLabel = Instance.new("TextLabel"); MountLabel.Name = "MountName"; MountLabel.Parent = MountHud; MountLabel.AnchorPoint = Vector2.new(0.5, 0); MountLabel.Position = UDim2.new(0.5, 0, 0.1, 0); MountLabel.Size = UDim2.new(0, 300, 0, 50); MountLabel.BackgroundTransparency = 1; MountLabel.TextColor3 = Color3.fromRGB(255, 220, 0); MountLabel.Font = Enum.Font.GothamBlack; MountLabel.TextSize = 24; MountLabel.Text = ""; MountLabel.Visible = false; 
local HS = Instance.new("UIStroke"); HS.Thickness = 2; HS.Parent = MountLabel
AddToRainbow(MountLabel, "Text")

-- =================================================================
-- 6. RAINBOW LOOP ENGINE
-- =================================================================
task.spawn(function()
    while VeloraGui.Parent do
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        
        for _, item in pairs(RainbowRegistry) do
            if item.Obj and item.Obj.Parent then
                if item.Type == "Text" then
                    item.Obj.TextColor3 = color
                elseif item.Type == "Background" then
                    item.Obj.BackgroundColor3 = color
                elseif item.Type == "Border" then
                    item.Obj.Color = color
                end
            end
        end
        task.wait(0.03)
    end
end)
