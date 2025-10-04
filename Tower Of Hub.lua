local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TowerOfHubMenu"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 330)
MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.Text = "Tower Of Hub"
TitleBar.TextColor3 = Color3.new(1, 1, 1)
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.TextSize = 18
TitleBar.Parent = MainFrame

local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(0, 120, 1, -30)
TabButtons.Position = UDim2.new(0, 0, 0, 30)
TabButtons.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabButtons.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -120, 1, -30)
ContentFrame.Position = UDim2.new(0, 120, 0, 30)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ContentFrame.Parent = MainFrame

local function CreateTab(name, order)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.Position = UDim2.new(0, 0, 0, (order - 1) * 35 + 5)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = name
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 16
    Button.Parent = TabButtons

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 500)
    Page.ScrollBarThickness = 6
    Page.Visible = false
    Page.BackgroundTransparency = 1
    Page.Parent = ContentFrame

    Button.MouseButton1Click:Connect(function()
        for _, v in pairs(ContentFrame:GetChildren()) do
            if v:IsA("ScrollingFrame") then
                v.Visible = false
            end
        end
        Page.Visible = true
    end)

    return Page
end

local MainTab = CreateTab("Main", 1)
local MiscTab = CreateTab("Misc", 2)
local ExecTab = CreateTab("Executor", 3)

local function makeButton(parent, text, x, y, width)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0, width or 180, 0, 30)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Parent = parent
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 100)
    stroke.Thickness = 1
    stroke.Parent = btn
    return btn
end

local function makeTextBox(parent, placeholder, x, y, width, height)
    local box = Instance.new("TextBox")
    box.PlaceholderText = placeholder
    box.Size = UDim2.new(0, width or 120, 0, height or 30)
    box.Position = UDim2.new(0, x, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 16
    box.Parent = parent
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 100)
    stroke.Thickness = 1
    stroke.Parent = box
    return box
end

local function giveItem(itemName)
    local gearFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gear")
    local item = gearFolder:FindFirstChild(itemName)
    if item then
        local clone = item:Clone()
        clone.Parent = LocalPlayer.Backpack
    end
end

makeButton(MainTab, "GodMode", 10, 10).MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        LocalPlayer.Character.Humanoid.Health = math.huge
    end
end)

makeButton(MainTab, "TP Tool", 10, 50).MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "TP Tool"
    tool.Activated:Connect(function()
        LocalPlayer.Character:MoveTo(Mouse.Hit.p)
    end)
    tool.Parent = LocalPlayer.Backpack
end)

local infJump = false
makeButton(MainTab, "Inf Jump", 10, 90).MouseButton1Click:Connect(function()
    infJump = not infJump
end)
UserInputService.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

local flyEnabled = false
makeButton(MainTab, "Fly", 10, 130).MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if flyEnabled and hrp then
        task.spawn(function()
            while flyEnabled do
                RunService.Heartbeat:Wait()
                hrp.Velocity = (Mouse.Hit.p - hrp.Position).Unit * 60
            end
        end)
    end
end)

local freecamEnabled = false
local freecamSpeed = 50
makeButton(MainTab, "Freecam", 10, 170).MouseButton1Click:Connect(function()
    freecamEnabled = not freecamEnabled
    if freecamEnabled then
        Camera.CameraType = Enum.CameraType.Scriptable
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            Camera.CFrame = hrp.CFrame
        end
        task.spawn(function()
            while freecamEnabled do
                RunService.RenderStepped:Wait()
                local moveDirection = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end
                if moveDirection.Magnitude > 0 then
                    Camera.CFrame = Camera.CFrame + moveDirection.Unit * freecamSpeed * RunService.RenderStepped:Wait()
                end
            end
            Camera.CameraType = Enum.CameraType.Custom
        end)
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

local FOVBox = makeTextBox(MainTab, "Enter FOV", 10, 210)
local FOVButton = makeButton(MainTab, "Set FOV", 10, 250)
FOVButton.MouseButton1Click:Connect(function()
    local fov = tonumber(FOVBox.Text)
    if fov then
        Camera.FieldOfView = math.clamp(fov, 10, 120)
    end
end)

local chamsEnabled = false
local chamsFolder = Instance.new("Folder", game.CoreGui)
chamsFolder.Name = "ChamsFolder"
local function applyChams(player)
    if player ~= LocalPlayer and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local parts = {}
            if humanoid.RigType == Enum.HumanoidRigType.R6 then
                for _, partName in pairs({"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}) do
                    local part = player.Character:FindFirstChild(partName)
                    if part and part:IsA("BasePart") then
                        table.insert(parts, part)
                    end
                end
            else
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        table.insert(parts, part)
                    end
                end
            end
            for _, part in pairs(parts) do
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Adornee = part
                highlight.Parent = chamsFolder
            end
        end
    end
end
local function updateChams()
    chamsFolder:ClearAllChildren()
    if chamsEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            applyChams(player)
        end
    end
end
makeButton(MainTab, "ESP/Chams", 10, 290).MouseButton1Click:Connect(function()
    chamsEnabled = not chamsEnabled
    if chamsEnabled then
        updateChams()
        Players.PlayerAdded:Connect(function(player)
            if chamsEnabled then
                player.CharacterAdded:Connect(function()
                    wait(0.1)
                    applyChams(player)
                end)
            end
        end)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                player.CharacterAdded:Connect(function()
                    if chamsEnabled then
                        wait(0.1)
                        applyChams(player)
                    end
                end)
            end
        end
    else
        chamsFolder:ClearAllChildren()
    end
end)

local AntiKickEnabled = false
local AntiKickBtn = makeButton(MainTab, "Anti Kick (Client)", 10, 330)
AntiKickBtn.MouseButton1Click:Connect(function()
    AntiKickEnabled = not AntiKickEnabled
    AntiKickBtn.Text = "Anti Kick: " .. (AntiKickEnabled and "ON" or "OFF")
    if AntiKickEnabled then
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if AntiKickEnabled and tostring(method) == "Kick" and self == LocalPlayer then
                warn("[AntiKick] Blocked a kick attempt for " .. LocalPlayer.Name)
                return nil
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

makeButton(MiscTab, "Give Cola", 10, 10).MouseButton1Click:Connect(function() giveItem("cola") end)
makeButton(MiscTab, "Give Gravity", 10, 50).MouseButton1Click:Connect(function() giveItem("gravity") end)
makeButton(MiscTab, "Give Speed", 10, 90).MouseButton1Click:Connect(function() giveItem("speed") end)

makeButton(MiscTab, "Give All Items", 10, 130).MouseButton1Click:Connect(function()
    local gearFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Gear")
    for _, item in pairs(gearFolder:GetChildren()) do
        local clone = item:Clone()
        clone.Parent = LocalPlayer.Backpack
    end
end)

local MiscSpeedBox = makeTextBox(MiscTab, "Enter Speed", 10, 170)
local MiscSpeedButton = makeButton(MiscTab, "OK", 10, 210)
MiscSpeedButton.MouseButton1Click:Connect(function()
    local speed = tonumber(MiscSpeedBox.Text)
    if speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end)

local MiscJumpBox = makeTextBox(MiscTab, "Enter JumpPower", 10, 250)
local MiscJumpButton = makeButton(MiscTab, "OK", 10, 290)
MiscJumpButton.MouseButton1Click:Connect(function()
    local jump = tonumber(MiscJumpBox.Text)
    if jump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = jump
    end
end)

local ExecBox = makeTextBox(ExecTab, "Enter your script here...", 10, 10, 380, 220)
ExecBox.MultiLine = true
ExecBox.TextScaled = false
ExecBox.TextWrapped = true
ExecBox.Text = ""
ExecBox.ClearTextOnFocus = false

local ExecBtn = makeButton(ExecTab, "Execute", 10, 240, 185)
ExecBtn.MouseButton1Click:Connect(function()
    local code = ExecBox.Text
    local func, err = loadstring(code)
    if func then
        func()
    else
        warn("Executor Error: " .. tostring(err))
    end
end)

local ClearBtn = makeButton(ExecTab, "Clear", 205, 240, 185)
ClearBtn.MouseButton1Click:Connect(function()
    ExecBox.Text = ""
end)

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
}
gradient.Rotation = 45
gradient.Parent = ExecBox

MainTab.Visible = true
