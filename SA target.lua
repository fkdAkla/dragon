local genv = getgenv()


local defaultSpawnDelay = 350
local defaultLocation = "Portal" --genv defined lower.
local defaultTpToLastPos = true
genv.tptolastpos = defaultTpToLastPos
genv.spawndelay = defaultSpawnDelay
genv.voice = "dio"
genv.tslength = 15
--fcs.hito("Bloodsuck", char["Right Arm"], targetChar["Right Arm"].CFrame, 100, 100)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local remote = game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input")

local player = game.Players.LocalPlayer
local function startTarget(once)
    genv.running = true
    while task.wait() do
        if not genv.running then return end
        if once then genv.running = false end
        
        repeat task.wait() until game.Lighting.TS.Value == false
        local target = genv.target
        if not target then continue end
        
        target = game.Players:FindFirstChild(target)
    
        local targetChar = target
        and
        target.Character
        and
        target.Character:FindFirstChild("HumanoidRootPart")
        and
        target.Character.Humanoid.Health > 0
        and
        target.Character
        
        if not targetChar then continue end
        
        repeat task.wait() until not target or (target.Character and target.Character:FindFirstChild("HumanoidRootPart") and not target.Character.HumanoidRootPart.Anchored)
        
        if not target then continue end
        local char = game.Players.LocalPlayer.Character
        
        char:PivotTo(targetChar:GetPivot() + Vector3.new(targetChar.Humanoid.MoveDirection))
        
        task.wait(0.2)
        
        repeat task.wait() until targetChar:FindFirstChild("Stand")
        
        remote:FireServer("Damage","Bloodsuck",nil,nil,targetChar.Humanoid,targetChar:GetPivot())
        
        task.wait(0.2)
        
        local myPivot = char:GetPivot()
        
        repeat
            task.wait()
            char:PivotTo(CFrame.new(myPivot.X, -498, myPivot.Z))
        until not char:FindFirstChild("HumanoidRootPart")
        task.wait(0.5)
        --replicatesignal(game.Players.LocalPlayer.Kill)
        if once then return end
        game.Players.LocalPlayer.CharacterAdded:Wait()
        task.wait(genv.spawndelay/1000) --0.35
    end
end

local strafing = false
local function startStrafe()
    local circle = 0
    local radius = 8
    if genv.c then genv.c:Disconnect() end
    genv.c = game:GetService("RunService").Heartbeat:Connect(function()
        circle += 0.5
        
        local target = game.Players:FindFirstChild(target)
        
        local tChar = target and target.Character
        if not tChar then return end
        workspace.CurrentCamera.CameraSubject = tChar
        local tHrp = tChar:FindFirstChild("HumanoidRootPart")
        
        local hum = tChar:FindFirstChild("Humanoid")
        
        if not hum or not tHrp then return end
        if hum.Health <= 0 then if genv.tptolastpos then player.Character:PivotTo(genv.lastpos) end return end
        
        local pivot = tHrp.CFrame * CFrame.new(0, -8, 0)
        local cfr = pivot * CFrame.new(math.sin(circle)*radius, 0, math.cos(circle)*radius)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(cfr.Position, pivot.Position)
    end)
end

local function tpTarget()
    if not genv.target then return end
    if genv.running then return end
    local target = game.Players:FindFirstChild(genv.target)
    if not target then return end
    target = target.Character

    local pivot = target.HumanoidRootPart.CFrame
    
    local cfr = pivot
    
    local player = game.Players.LocalPlayer
    
    player.Character.HumanoidRootPart.CFrame = cfr
    
    task.wait(0.2)
    
    remote:FireServer("Damage", "Bloodsuck", nil, nil, target.Humanoid, target:GetPivot())
    
    task.wait(0.2)
    
    player.Character.HumanoidRootPart.CFrame = genv.location or pivot
end

local Window = Rayfield:CreateWindow({
   Name = "NHO Technology",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image

local DropdownPlayers = Tab:CreateDropdown({
   Name = "Players",
   Options = {"None"},
   CurrentOption = {"None"},
   MultipleOptions = false,
   Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
       if Options[1] == "None" then genv.target = nil return end
       genv.target = Options[1]
   end,
})

local locs = {
    ["Farming zone"] = CFrame.new(-284.694275, 461.597198, -1486.00232, 0.455198199, 1.85057736e-09, 0.890390158, 4.58264822e-08, 1, -2.55064698e-08, -0.890390158, 5.24139452e-08, 0.455198199),
    Portal = CFrame.new(1150.23743, 583.259888, -664.438965, 0.743843019, 1.89297804e-08, 0.668354332, 1.44191077e-08, 1, -4.4370676e-08, -0.668354332, 4.264189e-08, 0.743843019)
}

genv.location = locs[defaultLocation]

local DropdownLocations = Tab:CreateDropdown({
   Name = "Location to TP",
   Options = {"None", "Farming zone", "Portal"},
   CurrentOption = {defaultLocation},
   MultipleOptions = false,
   Flag = "Dropdown2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
       genv.location = locs[Options[1]]
   end,
})

local DropdownTSVoice = Tab:CreateDropdown({
   Name = "Timestop voice",
   Options = {"dio", "diooh", "dioova", "shadowdio", "jotaro", "jotaroova", "sptw"},
   CurrentOption = genv.voice or "dio",
   MultipleOptions = false,
   Flag = "Dropdown2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
       genv.voice = Options[1]
   end,
})

Tab:CreateDivider()

local ButtonKill = Tab:CreateButton({
   Name = "Kill Target [VTW, Anubis(Strafe)]",
   Callback = function()
        if not genv.target then return end
        if genv.running then return end
       
        if player.Backpack:FindFirstChild("Anubis") then
            local target = game.Players:FindFirstChild(genv.target)
            if not target then return end
            target = target.Character
            for i = 1,20 do
                remote:FireServer("Damage", "Swing", nil, nil, target.Humanoid)
                remote:FireServer("Damage", "StrongSlash", nil, nil, target.Humanoid)
                remote:FireServer("Damage", "SpecialSlash", nil, nil, target.Humanoid)
                task.wait(0.1)
            end
        else
            startTarget(true)
        end
       
   end,
})

local buttonVTWFun = Tab:CreateButton({
   Name = "Fun thing vtw",
   Callback = function()
        if not genv.target then return end
        if genv.running then return end
        local target = game.Players:FindFirstChild(genv.target)
        if not target then return end
        target = target.Character

        local pivot = target.HumanoidRootPart.CFrame
        
        local cfr = pivot * CFrame.new(0, 0, 3)
        
        local player = game.Players.LocalPlayer
        
        player.Character.HumanoidRootPart.CFrame = CFrame.new(cfr.Position, pivot.Position)
        
        task.wait(0.2)
        
        remote:FireServer("Damage", "DonutPunch", nil, nil, target.Humanoid, target:GetPivot())
        
        task.wait(2)
        
        player.Character.HumanoidRootPart.CFrame = genv.location or pivot * CFrame.new(0,3000,0)
   end,
})

local buttonVTWTP = Tab:CreateButton({
   Name = "TP target [VTW]",
   Callback = function()
        tpTarget()
   end,
})

local ButtonTWOHMoves = Tab:CreateButton({
   Name = "Hit all moves [TWOH]",
   Callback = function()
        local target = genv.target and game.Players:FindFirstChild(genv.target)
        if not target then return end
        target = target.Character
        remote:FireServer("Damage","Overwrite",nil,nil,target.Humanoid,target:GetPivot())
    	
        remote:FireServer("Damage","HeavyPunch",nil,nil,target.Humanoid,target:GetPivot())
    
        remote:FireServer("Damage","Slam",nil,nil,target.Humanoid,target:GetPivot())
        remote:FireServer("Damage","Punch",nil,nil,target.Humanoid,target:GetPivot())
        
        task.delay(0.7,function()
            remote:FireServer("Damage","Punch",nil,nil,target.Humanoid,target:GetPivot())
        end)
    
        remote:FireServer("Alternate","Knife")
   end,
})

Tab:CreateDivider()

local SliderSpawnDelay = Tab:CreateSlider({
   Name = "Spawn Delay",
   Range = {200, 1000},
   Increment = 10,
   Suffix = "ms",
   CurrentValue = defaultSpawnDelay,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
       genv.spawndelay = Value
   end,
})

local SliderTSLength = Tab:CreateSlider({
   Name = "TS Length",
   Range = {1, 15},
   Increment = 1,
   Suffix = "s",
   CurrentValue = genv.tslength or 15,
   Flag = "Slider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
       genv.tslength = Value
   end,
})

local ToggleLoopKill = Tab:CreateToggle({
   Name = "Loop Kill [VTW]",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
       if Value then
           startTarget()
        else
            genv.running = false
       end
   end,
})


local ToggleStrafe = Tab:CreateToggle({
   Name = "Target Strafe",
   CurrentValue = false,
   Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
       strafing = Value
       if Value then
           genv.lastpos = player.Character:GetPivot()
           startStrafe()
        else
            if genv.c then genv.c:Disconnect() end
            if genv.tptolastpos then player.Character:PivotTo(genv.lastpos) end
            workspace.CurrentCamera.CameraSubject = player.Character
        end
   end,
})

local ToggleTpToLastPos = Tab:CreateToggle({
   Name = "Tp to last pos",
   CurrentValue = defaultTpToLastPos,
   Flag = "Toggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
       genv.tptolastpos = Value
   end,
})

local ToggleSelfHeal = Tab:CreateToggle({
   Name = "Self Heal [Crazy Diamond]",
   CurrentValue = false,
   Flag = "Toggle4", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
       if Value then
           genv.selfheal = true
           while genv.selfheal do
               task.wait(0.1)
               if not player.Backpack:FindFirstChild("CrazyDiamond") then continue end
               if not player.Character:FindFirstChild("Humanoid") then continue end
               remote:FireServer("Damage", "Punch", nil, nil, player.Character.Humanoid, player.Character:GetPivot(), true)
           end
           return
       end
       genv.selfheal = nil
   end,
})

Tab:CreateDivider()

local Keybindstrafe = Tab:CreateKeybind({
   Name = "Toggle Strafe",
   CurrentKeybind = "L",
   HoldToInteract = false,
   Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
       ToggleStrafe:Set(not strafing)
   end,
})

local KeybindTpTarget = Tab:CreateKeybind({
   Name = "TP target [VTW]",
   CurrentKeybind = "Comma",
   HoldToInteract = false,
   Flag = "Keybind2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
       tpTarget()
   end,
})

local KeybindLongTS = Tab:CreateKeybind({
   Name = "Custom timestop",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Flag = "Keybind3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
       game.ReplicatedStorage.Main.Timestop:FireServer(genv.tslength, genv.voice)
   end,
})

game.Players.PlayerAdded:Connect(function(plr)
    local newT = {"None"}
    for i, v in game.Players:GetPlayers() do
        if v == game.Players.LocalPlayer then continue end
        table.insert(newT, v.Name)
    end
    DropdownPlayers:Refresh(newT)
end)

game.Players.PlayerRemoving:Connect(function(plr)
    local newT = {"None"}
    for i, v in game.Players:GetPlayers() do
        if v == game.Players.LocalPlayer then continue end
        table.insert(newT, v.Name)
    end
    DropdownPlayers:Refresh(newT)
end)

local newT = {"None"}
for i, v in game.Players:GetPlayers() do
    if v == game.Players.LocalPlayer then continue end
    table.insert(newT, v.Name)
end
DropdownPlayers:Refresh(newT)
DropdownPlayers:Set({"None"})
--[[Taunt function: 0xdc6aee063451e696
Slam function: 0xed57bc2dfb4a2d16
Untimestop function: 0xef4f4f5c8ec1c1f6
Hito function: 0x0136874c7757cfc6
LaserEyes function: 0xac699ff4997c30b6
BarrageINPUT function: 0x208b4518bd7b6666
TSTeleport function: 0xc3d4118988799fc6
cam Camera
StandAppear function: 0x002591ceb6f62af6
BlockOff function: 0xb67c0c42f3ee27f6
Timestop function: 0x6ea175a76371e496
state function: 0x47356e44789653d6
Movement function: 0xa2e3fb5f8758a146
DustChange function: 0x71b8ad81f8257336
_G table: 0x6b67a1e9611929a6
hito function: 0x0b6fd52276aeac16 action,bodypart,hitboxcfr,maxrange,unknown,name
Donut function: 0x65fe94810bf88a26
Dodge function: 0x01b9d0f75aa80e56
Knife function: 0xa515101220c3aea6
Block function: 0x6716a3a4871b4f56
Pose function: 0x9cb8c929566784d6
shared table: 0xad0ae8134c67dc16
Bloodsuck function: 0x2345105d9c013146
Uppercut function: 0x957d2a53ab217dd6
Roadroller function: 0xab0a9b63f6e33e16
PunchOld function: 0xbc351bf232b339b6
HeavyPunch function: 0x111060193f581cb6
HitPosition function: 0xb1ab147ad24f0b16
BarrageOUTPUT function: 0x73fb3f7d3c95cb96
Kick function: 0xfe46cbc0d175b076
script VampireTW
Punch function: 0xe2567011b1594e96
Mouse Instance
]]
