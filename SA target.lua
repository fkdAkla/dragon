local genv = getgenv()

--fcs.hito("Bloodsuck", char["Right Arm"], targetChar["Right Arm"].CFrame, 100, 100)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

genv.running = true

local function startTarget(once)
    genv.running = true
    while task.wait() do
        if not genv.running then return end
        if once then genv.running = false end
        local target = genv.target
        
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
        
        local char = game.Players.LocalPlayer.Character
        
        char:PivotTo(targetChar:GetPivot())
        
        task.wait(0.25)
        game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(
        "Damage",
        "Bloodsuck",
        nil,
        nil,
        targetChar.Humanoid,
        targetChar:GetPivot()
    )
        task.wait(0.25)
        
        local myPivot = char:GetPivot()
        
        game.Players.LocalPlayer.Character:PivotTo(CFrame.new(myPivot.X, -498.6, myPivot.Z))
        task.wait(0.1)
        replicatesignal(game.Players.LocalPlayer.Kill)
        game.Players.LocalPlayer.CharacterAdded:Wait()
        task.wait(0.35)
    end
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
      Enabled = true,
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

local Tab = Window:CreateTab("Target", 4483362458) -- Title, Image

local Dropdown = Tab:CreateDropdown({
   Name = "Players",
   Options = {"None"},
   CurrentOption = {"Option 1"},
   MultipleOptions = false,
   Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
       if Options[1] == "None" then genv.target = nil return end
       genv.target = Options[1]
   end,
})

local Button = Tab:CreateButton({
   Name = "Kill Target",
   Callback = function()
       if not genv.target then return end
       if genv.running then return end
       
       startTarget(true)
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Loop Kill",
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

game.Players.PlayerAdded:Connect(function(plr)
    local newT = {"None"}
    for i, v in game.Players:GetPlayers() do
        if plr == game.Players.LocalPlayer then continue end
        table.insert(newT, v.Name)
    end
    Dropdown:Refresh(newT)
end)

game.Players.PlayerRemoving:Connect(function(plr)
    local newT = {"None"}
    for i, v in game.Players:GetPlayers() do
        if plr == game.Players.LocalPlayer then continue end
        table.insert(newT, v.Name)
    end
    Dropdown:Refresh(newT)
end

local newT = {"None"}
for i, v in game.Players:GetPlayers() do
    if plr == game.Players.LocalPlayer then continue end
    table.insert(newT, v.Name)
end)
Dropdown:Refresh(newT)
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
