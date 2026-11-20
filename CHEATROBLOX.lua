
-- [w] : by wleo : yoruka.id
-- s¡dzx̌12

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Fly = false,
    ESP = false,
    Chams = false,
    Aim = false,
    FlySpeed = 60,
    Jump = 50,
    Run = 16,
    FOV = 120,
    ESPColor = Color3.fromRGB(255, 50, 80),
    ChamsColor = Color3.fromRGB(50, 150, 255)
}

local gui = Instance.new("ScreenGui")
gui.Name = "s¡dzx̌12"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local main = create("Frame", {
    Size = UDim2.fromOffset(530, 410),
    Position = UDim2.new(.5,-265,.5,-205),
    BackgroundColor3 = Color3.fromRGB(13,13,19),
    BorderSizePixel = 0
}, gui)

create("UICorner",{CornerRadius=UDim.new(0,12)},main)

create("UIStroke",{
    Color=Color3.fromRGB(130,45,255),
    Thickness=1.5
},main)

local top = create("Frame",{
    Size=UDim2.new(1,0,0,48),
    BackgroundColor3=Color3.fromRGB(23,19,34),
    BorderSizePixel=0
},main)

create("TextLabel",{
    Size=UDim2.new(1,-60,1,0),
    Position=UDim2.fromOffset(15,0),
    BackgroundTransparency=1,
    Text="s¡dzx̌12",
    TextColor3=Color3.fromRGB(190,120,255),
    Font=Enum.Font.GothamBold,
    TextSize=22,
    TextXAlignment=Enum.TextXAlignment.Left
},top)

local close = create("TextButton",{
    Size=UDim2.fromOffset(38,32),
    Position=UDim2.new(1,-45,0,8),
    BackgroundColor3=Color3.fromRGB(120,35,55),
    Text="X",
    TextColor3=Color3.new(1,1,1),
    Font=Enum.Font.GothamBold,
    TextSize=15
},top)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local sidebar = create("Frame",{
    Position=UDim2.fromOffset(10,60),
    Size=UDim2.fromOffset(125,340),
    BackgroundColor3=Color3.fromRGB(20,20,29),
    BorderSizePixel=0
},main)

create("UICorner",{CornerRadius=UDim.new(0,8)},sidebar)

local content = create("ScrollingFrame",{
    Position=UDim2.fromOffset(145,60),
    Size=UDim2.fromOffset(375,340),
    BackgroundColor3=Color3.fromRGB(18,18,25),
    BorderSizePixel=0,
    ScrollBarThickness=3,
    CanvasSize=UDim2.new(0,0,0,900)
},main)

create("UICorner",{CornerRadius=UDim.new(0,8)},content)

local layout = create("UIListLayout",{
    Padding=UDim.new(0,7),
    SortOrder=Enum.SortOrder.LayoutOrder
},content)

local function label(text)
    create("TextLabel",{
        Size=UDim2.new(1,-16,0,27),
        BackgroundTransparency=1,
        Text=text,
        TextColor3=Color3.fromRGB(190,150,255),
        TextSize=13,
        Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left
    },content)
end

local function button(text,callback)
    local b=create("TextButton",{
        Size=UDim2.new(1,-16,0,35),
        BackgroundColor3=Color3.fromRGB(35,32,48),
        Text=text,
        TextColor3=Color3.new(1,1,1),
        TextSize=12,
        Font=Enum.Font.GothamMedium,
        AutoButtonColor=true
    },content)
    create("UICorner",{CornerRadius=UDim.new(0,6)},b)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function input(placeholder)
    local box=create("TextBox",{
        Size=UDim2.new(1,-16,0,35),
        BackgroundColor3=Color3.fromRGB(30,28,40),
        PlaceholderText=placeholder,
        Text="",
        TextColor3=Color3.new(1,1,1),
        PlaceholderColor3=Color3.fromRGB(130,130,140),
        Font=Enum.Font.Gotham,
        TextSize=12,
        ClearTextOnFocus=false
    },content)
    return box
end

local function toggle(name,callback)
    local state=false
    local b=button(name.." : OFF",function()
        state=not state
        b.Text=name.." : "..(state and "ON" or "OFF")
        b.BackgroundColor3=state and
            Color3.fromRGB(90,35,150) or
            Color3.fromRGB(35,32,48)
        callback(state)
    end)
    return b
end

-- MOVEMENT

label("MOVEMENT")

local flying=false
local flyConnection

toggle("FLY",function(value)
    flying=value

    local char=LP.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection=nil
    end

    if flying then
        local bv=Instance.new("BodyVelocity")
        bv.MaxForce=Vector3.new(1e6,1e6,1e6)
        bv.Parent=root

        flyConnection=RunService.RenderStepped:Connect(function()
            if not root.Parent then return end
            local dir=Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then
                dir+=Camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                dir-=Camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                dir-=Camera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                dir+=Camera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                dir+=Vector3.yAxis
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                dir-=Vector3.yAxis
            end

            bv.Velocity=dir.Magnitude>0 and
                dir.Unit*Config.FlySpeed or Vector3.zero
        end)

        task.spawn(function()
            repeat task.wait() until not flying
                or not root.Parent
            bv:Destroy()
        end)
    end
end)

label("JUMP / RUN")

local jumpBox=input("Jump level 1 - 9999")
button("SET JUMP",function()
    local n=tonumber(jumpBox.Text)
    if n then
        Config.Jump=math.clamp(n,1,9999)
        local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.UseJumpPower=true
            h.JumpPower=Config.Jump
        end
    end
end)

local runBox=input("Run level 1 - 9999")
button("SET RUN",function()
    local n=tonumber(runBox.Text)
    if n then
        Config.Run=math.clamp(n,1,9999)
        local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed=Config.Run end
    end
end)

-- TELEPORT

label("TELEPORT")

local tpBox=input("Username atau X,Y,Z")

button("TELEPORT",function()
    local char=LP.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local target=Players:FindFirstChild(tpBox.Text)

    if target and target.Character then
        local targetRoot=target.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            root.CFrame=targetRoot.CFrame*CFrame.new(0,0,4)
        end
    else
        local x,y,z=tpBox.Text:match(
            "^%s*(-?[%d%.]+)%s*,%s*(-?[%d%.]+)%s*,%s*(-?[%d%.]+)%s*$"
        )
        if x and y and z then
            root.CFrame=CFrame.new(tonumber(x),tonumber(y),tonumber(z))
        end
    end
end)

-- FOV

label("CAMERA / FOV")

local fovBox=input("FOV 30 - 120")
button("SET FOV",function()
    local n=tonumber(fovBox.Text)
    if n then
        Camera.FieldOfView=math.clamp(n,30,120)
    end
end)

-- ESP

label("ENEMY ESP")

local espObjects={}

local function clearESP()
    for obj in pairs(espObjects) do
        if obj then obj:Destroy() end
    end
    table.clear(espObjects)
end

local function isEnemy(model)
    return model:IsA("Model")
        and CollectionService:HasTag(model,"EnemyNPC")
end

toggle("ESP ENEMIES",function(state)
    Config.ESP=state
    clearESP()

    if not state then return end

    for _,obj in ipairs(CollectionService:GetTagged("EnemyNPC")) do
        if obj:IsA("Model") then
            local h=Instance.new("Highlight")
            h.FillColor=Config.ESPColor
            h.OutlineColor=Color3.new(1,1,1)
            h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
            h.Adornee=obj
            h.Parent=gui
            espObjects[h]=true
        end
    end
end)

-- FRIEND CHAMS

label("FRIEND CHAMS")

toggle("CHAMS FRIENDS",function(state)
    Config.Chams=state

    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then
            local ok,isFriend=pcall(function()
                return LP:IsFriendsWith(p.UserId)
            end)

            if ok and isFriend and p.Character then
                local h=p.Character:FindFirstChild("FriendChams")

                if state and not h then
                    h=Instance.new("Highlight")
                    h.Name="FriendChams"
                    h.FillColor=Config.ChamsColor
                    h.OutlineColor=Color3.new(1,1,1)
                    h.Adornee=p.Character
                    h.Parent=gui
                elseif not state and h then
                    h:Destroy()
                end
            end
        end
    end
end)

-- TRAINING TARGET LOCK

label("NPC TRAINING")

local targetLabel=create("TextLabel",{
    Size=UDim2.new(1,-16,0,30),
    BackgroundTransparency=1,
    Text="TARGET: NONE",
    TextColor3=Color3.new(1,1,1),
    Font=Enum.Font.GothamBold,
    TextSize=12
},content)

local function getTarget()
    local best=nil
    local distance=math.huge

    for _,npc in ipairs(CollectionService:GetTagged("EnemyNPC")) do
        local head=npc:FindFirstChild("Head")
        if head then
            local pos,onScreen=Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local center=Camera.ViewportSize/2
                local d=(Vector2.new(pos.X,pos.Y)-center).Magnitude
                if d<Config.FOV and d<distance then
                    distance=d
                    best=head
                end
            end
        end
    end
    return best
end

toggle("NPC AIM LOCK",function(state)
    Config.Aim=state
end)

RunService.RenderStepped:Connect(function()
    if Config.Aim then
        local target=getTarget()
        if target then
            targetLabel.Text="TARGET: "..target.Parent.Name
        else
            targetLabel.Text="TARGET: NONE"
        end
    end
end)

-- SIDEBAR

local function tab(name,y,callback)
    local b=create("TextButton",{
        Size=UDim2.new(1,-10,0,38),
        Position=UDim2.fromOffset(5,y),
        BackgroundColor3=Color3.fromRGB(34,29,47),
        Text=name,
        TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.GothamBold,
        TextSize=11
    },sidebar)

    b.MouseButton1Click:Connect(callback)
end

tab("MOVEMENT",8,function()
    content.CanvasPosition=Vector2.new(0,0)
end)

tab("TELEPORT",52,function()
    content.CanvasPosition=Vector2.new(0,250)
end)

tab("VISUALS",96,function()
    content.CanvasPosition=Vector2.new(0,480)
end)

tab("TRAINING",140,function()
    content.CanvasPosition=Vector2.new(0,700)
end)

-- DRAG UI

local dragging=false
local dragStart,startPos

top.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1
    or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=i.Position
        startPos=main.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and (
        i.UserInputType==Enum.UserInputType.MouseMovement
        or i.UserInputType==Enum.UserInputType.Touch
    ) then
        local delta=i.Position-dragStart
        main.Position=UDim2.new(
            startPos.X.Scale,startPos.X.Offset+delta.X,
            startPos.Y.Scale,startPos.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1
    or i.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

print("[s¡dzx̌12] Loaded")
