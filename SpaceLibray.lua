
--// =========================
--// SpaceLibray
--// Dark Minimal UI Library
--// Fixed Height + Areas + Minimize Circle
--// =========================

local SpaceLibray = {}
local windowCount = 0
local areas = {}
local areaButtons = {}
local currentArea = nil

if game.CoreGui:FindFirstChild("SpaceLibray") then
    game.CoreGui:FindFirstChild("SpaceLibray"):Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

--// Drag Function
local function Dragify(Frame)
    local dragging = false
    local dragInput, startPos, startInputPos

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = Frame.Position
            startInputPos = input.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startInputPos
            Frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpaceLibray"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

--// Main Window
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Dragify(Main)

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,10)
Corner.Parent = Main

--// Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,40)
Header.BackgroundColor3 = Color3.fromRGB(25,25,25)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0,10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-60,1,0)
Title.Position = UDim2.new(0,15,0,0)
Title.BackgroundTransparency = 1
Title.Text = "SpaceLibray"
Title.TextColor3 = Color3.fromRGB(220,220,220)
Title.Font = Enum.Font.Gotham
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

--// Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-40,0,5)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
MinBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0.5,0)
MinCorner.Parent = MinBtn

--// Minimized Circle
local MiniCircle = Instance.new("ImageButton")
MiniCircle.Size = UDim2.new(0,60,0,60)
MiniCircle.Position = UDim2.new(0.5,-30,0.5,-30)
MiniCircle.BackgroundColor3 = Color3.fromRGB(25,25,25)
MiniCircle.Image = "rbxassetid://7072719338"
MiniCircle.Visible = false
MiniCircle.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0.5,0)
MiniCorner.Parent = MiniCircle

Dragify(MiniCircle)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MiniCircle.Visible = true
end)

MiniCircle.MouseButton1Click:Connect(function()
    Main.Visible = true
    MiniCircle.Visible = false
end)

--// Side Area Bar
local SideBar = Instance.new("ScrollingFrame")
SideBar.Size = UDim2.new(0,140,1,-40)
SideBar.Position = UDim2.new(0,0,0,40)
SideBar.CanvasSize = UDim2.new(0,0,0,0)
SideBar.ScrollBarThickness = 4
SideBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
SideBar.BorderSizePixel = 0
SideBar.Visible = false
SideBar.Parent = Main

--// Content Area
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1,-150,1,-50)
Content.Position = UDim2.new(0,150,0,45)
Content.CanvasSize = UDim2.new(0,0,0,0)
Content.ScrollBarThickness = 4
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.Parent = Main

--// Area Function
function SpaceLibray:Area(name)
    windowCount += 1

    local AreaFrame = Instance.new("Frame")
    AreaFrame.Size = UDim2.new(1,0,0,0)
    AreaFrame.BackgroundTransparency = 1
    AreaFrame.Visible = false
    AreaFrame.Parent = Content

    areas[name] = AreaFrame

    if windowCount > 1 then
        SideBar.Visible = true
    end

    if windowCount >= 1 then
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1,-10,0,35)
        Btn.Position = UDim2.new(0,5,0,(windowCount-1)*40)
        Btn.Text = name
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        Btn.TextColor3 = Color3.fromRGB(220,220,220)
        Btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        Btn.Parent = SideBar

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0,8)
        BtnCorner.Parent = Btn

        SideBar.CanvasSize = UDim2.new(0,0,0,windowCount*40)

        Btn.MouseButton1Click:Connect(function()
            for _,v in pairs(areas) do
                v.Visible = false
            end
            AreaFrame.Visible = true
            currentArea = AreaFrame
        end)
    end

    if not currentArea then
        AreaFrame.Visible = true
        currentArea = AreaFrame
    end

    local elementY = 0

    local elements = {}

    function elements:Toggle(text, callback)
        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(0,300,0,40)
        Toggle.Position = UDim2.new(0,10,0,elementY)
        Toggle.BackgroundColor3 = Color3.fromRGB(28,28,28)
        Toggle.Text = text
        Toggle.TextColor3 = Color3.fromRGB(200,200,200)
        Toggle.Font = Enum.Font.Gotham
        Toggle.TextSize = 14
        Toggle.Parent = AreaFrame

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0,8)
        Corner.Parent = Toggle

        local enabled = false

        Toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            Toggle.BackgroundColor3 = enabled and Color3.fromRGB(40,80,160) or Color3.fromRGB(28,28,28)
            if callback then
                callback(enabled)
            end
        end)

        elementY += 50
        AreaFrame.Size = UDim2.new(1,0,0,elementY)
        Content.CanvasSize = UDim2.new(0,0,0,elementY)

        return Toggle
    end

    return elements
end

return SpaceLibray
