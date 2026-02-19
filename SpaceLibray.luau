--[[
    SpaceLibrary - Dark Minimalist UI
    Baseado na estrutura TurtleUiLib
]]

local SpaceLibrary = {}
local windowCount = 0
local windows = {}
local tabs = {}
local currentTab = nil
local draggingCircle = false

local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local mouse = players.LocalPlayer:GetMouse()

-- Criar ScreenGui principal
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "SpaceLibrary"
MainGui.Parent = (syn and syn.protect_gui and syn.protect_gui(MainGui)) or coreGui
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Função de Arrastar (Melhorada)
local function Dragify(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    run.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

Dragify(MainFrame)

-- Barra Lateral (Sidebar)
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.Size = UDim2.new(0, 120, 1, -40)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 2
Sidebar.Visible = false -- Só aparece se houver > 1 janela

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.Size = UDim2.new(1, 0, 0, 40)

local LibTitle = Instance.new("TextLabel")
LibTitle.Parent = Header
LibTitle.BackgroundTransparency = 1
LibTitle.Position = UDim2.new(0, 15, 0, 0)
LibTitle.Size = UDim2.new(0, 200, 1, 0)
LibTitle.Font = Enum.Font.GothamBold
LibTitle.Text = "SpaceLibrary"
LibTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LibTitle.TextSize = 16
LibTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Botão Minimizar
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = Header
MinBtn.BackgroundTransparency = 1
MinBtn.Position = UDim2.new(1, -40, 0, 0)
MinBtn.Size = UDim2.new(0, 40, 0, 40)
MinBtn.Font = Enum.Font.Gotham
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 20

-- Círculo Minimizado
local MinimizedCircle = Instance.new("ImageButton")
MinimizedCircle.Name = "MinimizedCircle"
MinimizedCircle.Parent = MainGui
MinimizedCircle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MinimizedCircle.Position = UDim2.new(0.1, 0, 0.1, 0)
MinimizedCircle.Size = UDim2.new(0, 50, 0, 50)
MinimizedCircle.Visible = false
MinimizedCircle.Image = "rbxassetid://6031094678" -- Ícone de Espaço
MinimizedCircle.ImageColor3 = Color3.fromRGB(255, 255, 255)

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0) -- Círculo Perfeito
CircleCorner.Parent = MinimizedCircle

Dragify(MinimizedCircle)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedCircle.Visible = true
end)

MinimizedCircle.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedCircle.Visible = false
end)

-- Sistema de Janelas
function SpaceLibrary:Window(name)
    windowCount = windowCount + 1
    
    if windowCount > 1 then
        Sidebar.Visible = true
        for _, v in pairs(windows) do
            v.Size = UDim2.new(1, -120, 1, -40)
            v.Position = UDim2.new(0, 120, 0, 40)
        end
    end

    local WindowPage = Instance.new("ScrollingFrame")
    WindowPage.Name = name .. "Page"
    WindowPage.Parent = MainFrame
    WindowPage.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    WindowPage.BackgroundTransparency = 1
    WindowPage.Position = windowCount > 1 and UDim2.new(0, 120, 0, 40) or UDim2.new(0, 10, 0, 40)
    WindowPage.Size = windowCount > 1 and UDim2.new(1, -120, 1, -40) or UDim2.new(1, -20, 1, -40)
    WindowPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    WindowPage.ScrollBarThickness = 3
    WindowPage.Visible = (windowCount == 1)
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = WindowPage
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = WindowPage
    UIPadding.PaddingTop = UDim.new(0, 10)

    table.insert(windows, WindowPage)

    -- Botão na Sidebar
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = Sidebar
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.TextSize = 14

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(windows) do v.Visible = false end
        WindowPage.Visible = true
    end)

    local func = {}

    -- Botão (Minimalista)
    function func:Button(text, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = WindowPage
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Button.Size = UDim2.new(0, 350, 0, 35)
        Button.Font = Enum.Font.Gotham
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = Button

        Button.MouseButton1Click:Connect(callback)
        WindowPage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end

    -- Toggle (AIO Style)
    function func:Toggle(text, default, callback)
        local toggled = default or false
        
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Parent = WindowPage
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleFrame.Size = UDim2.new(0, 350, 0, 35)
        
        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(0, 6)
        tCorner.Parent = ToggleFrame

        local TText = Instance.new("TextLabel")
        TText.Parent = ToggleFrame
        TText.BackgroundTransparency = 1
        TText.Position = UDim2.new(0, 15, 0, 0)
        TText.Size = UDim2.new(0, 200, 1, 0)
        TText.Font = Enum.Font.Gotham
        TText.Text = text
        TText.TextColor3 = Color3.fromRGB(200, 200, 200)
        TText.TextSize = 14
        TText.TextXAlignment = Enum.TextXAlignment.Left

        local TOuter = Instance.new("Frame")
        TOuter.Parent = ToggleFrame
        TOuter.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TOuter.Position = UDim2.new(1, -50, 0.5, -10)
        TOuter.Size = UDim2.new(0, 40, 0, 20)
        
        local oCorner = Instance.new("UICorner")
        oCorner.CornerRadius = UDim.new(1, 0)
        oCorner.Parent = TOuter

        local TInner = Instance.new("Frame")
        TInner.Parent = TOuter
        TInner.BackgroundColor3 = toggled and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(255, 255, 255)
        TInner.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        TInner.Size = UDim2.new(0, 16, 0, 16)

        local iCorner = Instance.new("UICorner")
        iCorner.CornerRadius = UDim.new(1, 0)
        iCorner.Parent = TInner

        local TBtn = Instance.new("TextButton")
        TBtn.Parent = ToggleFrame
        TBtn.BackgroundTransparency = 1
        TBtn.Size = UDim2.new(1, 0, 1, 0)
        TBtn.Text = ""

        TBtn.MouseButton1Click:Connect(function()
            toggled = not toggled
            TInner:TweenPosition(toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
            TInner.BackgroundColor3 = toggled and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(255, 255, 255)
            callback(toggled)
        end)
        
        WindowPage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end

    -- Slider
    function func:Slider(text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Parent = WindowPage
        SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SliderFrame.Size = UDim2.new(0, 350, 0, 50)
        
        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(0, 6)
        sCorner.Parent = SliderFrame

        local SText = Instance.new("TextLabel")
        SText.Parent = SliderFrame
        SText.BackgroundTransparency = 1
        SText.Position = UDim2.new(0, 15, 0, 5)
        SText.Size = UDim2.new(0, 200, 0, 20)
        SText.Font = Enum.Font.Gotham
        SText.Text = text
        SText.TextColor3 = Color3.fromRGB(200, 200, 200)
        SText.TextSize = 13
        SText.TextXAlignment = Enum.TextXAlignment.Left

        local SBar = Instance.new("Frame")
        SBar.Parent = SliderFrame
        SBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        SBar.Position = UDim2.new(0.5, -160, 1, -15)
        SBar.Size = UDim2.new(0, 320, 0, 4)
        
        local barCorner = Instance.new("UICorner")
        barCorner.Parent = SBar

        local SFiller = Instance.new("Frame")
        SFiller.Parent = SBar
        SFiller.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        SFiller.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        
        local fCorner = Instance.new("UICorner")
        fCorner.Parent = SFiller

        local Val = Instance.new("TextLabel")
        Val.Parent = SliderFrame
        Val.BackgroundTransparency = 1
        Val.Position = UDim2.new(1, -60, 0, 5)
        Val.Size = UDim2.new(0, 50, 0, 20)
        Val.Font = Enum.Font.Gotham
        Val.Text = tostring(default)
        Val.TextColor3 = Color3.fromRGB(255, 255, 255)
        Val.TextSize = 13
        Val.TextXAlignment = Enum.TextXAlignment.Right

        -- Lógica Slider
        local dragging = false
        local function update()
            local pos = math.clamp((mouse.X - SBar.AbsolutePosition.X) / SBar.AbsoluteSize.X, 0, 1)
            SFiller.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(((max - min) * pos) + min)
            Val.Text = tostring(value)
            callback(value)
        end

        SliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                update()
            end
        end)
        uis.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        mouse.Move:Connect(function()
            if dragging then update() end
        end)

        WindowPage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end

    return func
end

return SpaceLibrary
