local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Sense = loadstring(game:HttpGet('https://sirius.menu/sense'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local gitrepo = loadstring(game:HttpGet(""))()

local version = "1.0.0"

local Window = Rayfield:CreateWindow({
    Name = "Vispura",
    LoadingTitle = "VispuraCheats",
    LoadingSubtitle = "Made By @artemi",
    ConfigurationSaving = {Enabled=true, FolderName="VispuraCheats", FileName="Vispura"},
    Discord = {Enabled=false},
    KeySystem = false
})

local function Notify(Te, Ti, Dur, img)
    Rayfield:Notify({
        Title = Te,
        Content = Ti,
        Duration = Dur or 2.5,
        Image = img or "layers",
    })
end

-- Tabs
local HomeTab = Window:CreateTab("Home", "box")
local PlayerTab = Window:CreateTab("Player", "user")
local CombatTab = Window:CreateTab("Combat", "sword")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local MiscTab = Window:CreateTab("Miscallenous", "layers")
local HomeDivider = HomeTab:CreateDivider()

local Update = HomeTab:CreateLabel("Current Version: " .. version, 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme
local UpdateLog = HomeTab:CreateParagraph({Title = "Paragraph Example", Content = "Paragraph Example"})

local HumanoidSection = PlayerTab:CreateSection("Humanoid")

local moveInput = {W=false, A=false, S=false, D=false}

local States = {
    SpeedEnabled = false,
    JumpPowerEnabled = false,
    Speed = 16,
    JumpPowerScale = 1
}

local DefaultJumpPower = Humanoid.JumpPower

PlayerTab:CreateToggle({
    Name = "Enable Speed",
    CurrentValue = false,
    Flag = "EnabledSpeed",
    Callback = function(value)
        States.SpeedEnabled = value
    end
})

PlayerTab:CreateToggle({
    Name = "Enable JumpPower",
    CurrentValue = false,
    Flag = "EnabledJP",
    Callback = function(value)
        States.JumpPowerEnabled = value
    end
})

PlayerTab:CreateSlider({
    Name = "Speed",
    Range = {16,150},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "SpeedAmount",
    Callback = function(value)
        States.Speed = value
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power Scale",
    Range = {0.5, 3},
    Increment = 0.05,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "JumpScale",
    Callback = function(value)
        States.JumpPowerScale = value
    end
})

local DEFAULT_JUMP = 20

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then moveInput.W = true end
    if input.KeyCode == Enum.KeyCode.S then moveInput.S = true end
    if input.KeyCode == Enum.KeyCode.A then moveInput.A = true end
    if input.KeyCode == Enum.KeyCode.D then moveInput.D = true end
    if input.KeyCode == Enum.KeyCode.Space then
        if States.JumpPowerEnabled and Humanoid.FloorMaterial ~= Enum.Material.Air then
            local vel = HumanoidRootPart.AssemblyLinearVelocity
            local scaledJump = DEFAULT_JUMP * States.JumpPowerScale
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(vel.X, scaledJump, vel.Z)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then moveInput.W = false end
    if input.KeyCode == Enum.KeyCode.S then moveInput.S = false end
    if input.KeyCode == Enum.KeyCode.A then moveInput.A = false end
    if input.KeyCode == Enum.KeyCode.D then moveInput.D = false end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    DefaultJumpPower = Humanoid.JumpPower
end)

RunService.Heartbeat:Connect(function(dt)
    if not States.SpeedEnabled or not HumanoidRootPart or not Humanoid then return end

    local cam = Workspace.CurrentCamera
    local dir = Vector3.new(0,0,0)
    if moveInput.W then dir = dir + Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z) end
    if moveInput.S then dir = dir - Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z) end
    if moveInput.A then dir = dir - Vector3.new(cam.CFrame.RightVector.X,0,cam.CFrame.RightVector.Z) end
    if moveInput.D then dir = dir + Vector3.new(cam.CFrame.RightVector.X,0,cam.CFrame.RightVector.Z) end

    if dir.Magnitude > 0 then
        dir = dir.Unit * States.Speed
        local vel = HumanoidRootPart.AssemblyLinearVelocity
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(dir.X, vel.Y, dir.Z)
    else
        local vel = HumanoidRootPart.AssemblyLinearVelocity
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
    end
end)

local FlightState = {
    Enabled = false,
    Speed = 50
}

local FlightKeybind = PlayerTab:CreateKeybind({
    Name = "Flight",
    CurrentKeybind = "X",
    HoldToInteract = false,
    Flag = "FlightKeybind",
    Callback = function()
        FlightState.Enabled = not FlightState.Enabled
    end
})

PlayerTab:CreateSlider({
    Name = "Flight Speed",
    Range = {10, 200},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "FlightSpeed",
    Callback = function(value)
        FlightState.Speed = value
    end
})

local flightInput = {W=false, A=false, S=false, D=false, Up=false, Down=false}

-- Capture flight inputs
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then flightInput.W = true end
    if input.KeyCode == Enum.KeyCode.S then flightInput.S = true end
    if input.KeyCode == Enum.KeyCode.A then flightInput.A = true end
    if input.KeyCode == Enum.KeyCode.D then flightInput.D = true end
    if input.KeyCode == Enum.KeyCode.Space then flightInput.Up = true end
    if input.KeyCode == Enum.KeyCode.LeftControl then flightInput.Down = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then flightInput.W = false end
    if input.KeyCode == Enum.KeyCode.S then flightInput.S = false end
    if input.KeyCode == Enum.KeyCode.A then flightInput.A = false end
    if input.KeyCode == Enum.KeyCode.D then flightInput.D = false end
    if input.KeyCode == Enum.KeyCode.Space then flightInput.Up = false end
    if input.KeyCode == Enum.KeyCode.LeftControl then flightInput.Down = false end
end)
RunService.Heartbeat:Connect(function(dt)
    if not FlightState.Enabled or not HumanoidRootPart then return end

    local cam = workspace.CurrentCamera
    local dir = Vector3.zero

    local forward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
    local right   = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)

    if forward.Magnitude > 0 then forward = forward.Unit end
    if right.Magnitude > 0 then right = right.Unit end

    if flightInput.W then dir = dir + forward end
    if flightInput.S then dir = dir - forward end
    if flightInput.A then dir = dir - right end
    if flightInput.D then dir = dir + right end
    if flightInput.Up then dir = dir + Vector3.yAxis end
    if flightInput.Down then dir = dir - Vector3.yAxis end

    if dir.Magnitude > 0 then
        HumanoidRootPart.AssemblyLinearVelocity = dir.Unit * FlightState.Speed
    else
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    end
end)


local Noclipping = nil
local floatName = "HumanoidRootPart"

local function SetCollision(state)
    local char = LocalPlayer.Character
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= floatName then
            part.CanCollide = state
        end
    end
end

local function NoclipLoop()
    SetCollision(false)
end

PlayerTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(value)
        if value then
            if Noclipping then return end -- prevent double connect
            NoclipLoop()
            Noclipping = RunService.Stepped:Connect(NoclipLoop)
        else
            if Noclipping then
                Noclipping:Disconnect()
                Noclipping = nil
            end
            SetCollision(true)
        end
    end
})

local Root = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    Root = char:WaitForChild("HumanoidRootPart")
end)

local KillQueue = {}
local KillAllActive = false
local SelectedTarget = nil
local Snapping = false

local SnapHeight = 12
local SnapSpeed = 100
local StopDistance = 0.1

--// Raycast params (STATIC, not rebuilt every frame)
local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist
RayParams.IgnoreWater = true

--// Resolve target HRP
local function getTargetRoot()
    if not SelectedTarget then return end
    local plr = Players:FindFirstChild(SelectedTarget)
    if not plr or not plr.Character then return end
    return plr.Character:FindFirstChild("HumanoidRootPart")
end

--// Safe wall check (forgiving)
local function blocked(from, to)
    RayParams.FilterDescendantsInstances = {Character}
    local result = workspace:Raycast(from, to - from, RayParams)
    return result ~= nil and (result.Position - from).Magnitude < (to - from).Magnitude - 1
end

local function buildKillQueue()
    KillQueue = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(KillQueue, plr.Name)
        end
    end
end

local function advanceQueue()
    table.remove(KillQueue, 1)
    SelectedTarget = KillQueue[1]

    if SelectedTarget then
        Snapping = true
    else
        Snapping = false
        KillAllActive = false
    end
end

RunService.Heartbeat:Connect(function(dt)
    if not Snapping or not Root then return end

    local targetRoot = getTargetRoot()
    if not targetRoot then
    if KillAllActive then
        advanceQueue()
    else
        Snapping = false
    end
    return
end

    local targetPos = targetRoot.Position + Vector3.new(0, SnapHeight, 0)
    local currentPos = Root.Position
    local delta = targetPos - currentPos
    local dist = delta.Magnitude

    if dist <= StopDistance then return end

    local moveDist = math.min(dist, SnapSpeed * dt)
    local nextPos = currentPos + delta.Unit * moveDist

    -- Wall block check
    if blocked(currentPos, nextPos) then
        Snapping = false
        return
    end

    -- Velocity for Rivals auth
    Root.AssemblyLinearVelocity = delta.Unit * SnapSpeed

    -- Soft CFrame correction (prevents desync)
    Root.CFrame = CFrame.lookAt(nextPos, targetRoot.Position)
end)

--// Dropdown
local function getPlayerList()
    local t = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(t, plr.Name)
        end
    end
    return t
end

local KillSection = CombatTab:CreateSection("Kill")

local playersDropdown = CombatTab:CreateDropdown({
    Name = "Kill Player",
    Options = getPlayerList(),
    CurrentOption = nil,
    MultipleOptions = false,
    Callback = function(option)
        SelectedTarget = option[1]
        Snapping = SelectedTarget ~= nil
    end
})

Players.PlayerAdded:Connect(function()
    playersDropdown:Refresh(getPlayerList())
end)

Players.PlayerRemoving:Connect(function()
    playersDropdown:Refresh(getPlayerList())
end)

local KillallButton = CombatTab:CreateButton({
   Name = "Kill All (Need an InfAmmo Gun to be effective)",
   Callback = function()
        buildKillQueue()
        KillAllActive = true
        SelectedTarget = KillQueue[1]
        Snapping = true
   end,
})

local function createESP(character, player)
    local head = character:WaitForChild("Head", 5)
    if not head then return end

    if head:FindFirstChild("ESP") then
        head.ESP:Destroy()
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.Font = Enum.Font.Arcade
    label.TextSize = 19
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Parent = billboard
end

local ESPSection = VisualsTab:CreateSection("ESP")

local NameESP = VisualsTab:CreateToggle({
   Name = "Name ESP",
   CurrentValue = false,
   Flag = "ESPName", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        if Value then
                    for _, plr in ipairs(Players:GetPlayers()) do
    if plr.Character then
        createESP(plr.Character, plr)
    end

    plr.CharacterAdded:Connect(function(char)
        createESP(char, plr)
    end)
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        createESP(char, plr)
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr.Character and plr.Character:FindFirstChild("Head") then
        local esp = plr.Character.Head:FindFirstChild("ESP")
        if esp then esp:Destroy() end
    end
end)
else
    for i,v in pairs(Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Head") then
        local esp = v.Character.Head:FindFirstChild("ESP")
        if esp then esp:Destroy() end
    end
    end
        end
   end,
})

Sense.teamSettings.enemy.enabled = false
Sense.teamSettings.enemy.box = true
Sense.teamSettings.enemy.boxColor[1] = Color3.new(255,255,255)
Sense.Load()

local BoxESP = VisualsTab:CreateToggle({
   Name = "Box ESP",
   CurrentValue = false,
   Flag = "ESPBox",
   Callback = function(Value)
        Sense.teamSettings.enemy.enabled = not Sense.teamSettings.enemy.enabled
   end,
})

local CalloutToggleConnections = {}

local Callout = MiscTab:CreateToggle({
    Name = "Auto Notify Enemy Death HP",
    CurrentValue = false,
    Flag = "CalloutBox",
    Callback = function(Value)
        if Value then
            local function onCharacter(char)
                local Humanoid = char:WaitForChild("Humanoid")
                local conn = Humanoid.Died:Connect(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        local character = player.Character
                        local hum = character and character:FindFirstChild("Humanoid")
                        if hum then
                            local msg = player.Name .. " has " .. math.floor(hum.Health) .. " HP left!"
                            pcall(function()
                                Notify("Enemy HP", msg, 2.5, "layers")
                            end)
                        end
                    end
                end)
                table.insert(CalloutToggleConnections, conn)
            end

            if LocalPlayer.Character then
                onCharacter(LocalPlayer.Character)
            end
            local charConn = LocalPlayer.CharacterAdded:Connect(onCharacter)
            table.insert(CalloutToggleConnections, charConn)
        else
            for _, conn in ipairs(CalloutToggleConnections) do
                conn:Disconnect()
            end
            CalloutToggleConnections = {}
        end
    end,
})