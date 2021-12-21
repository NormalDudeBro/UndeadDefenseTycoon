local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kiwi-i/wallys-ui-fork/master/lib.lua", true))()
library.options.underlinecolor = "rainbow"
local w = library:CreateWindow('Main')
w:Section('The Goods')
local autokilltoggle = w:Toggle("Autokill Toggle", {flag = "TheYes"})
spawn(
function()
  while wait() do
    if w.flags.TheYes then
      wait(0.01)
      local plr = game.Players.LocalPlayer
      for i,v in pairs(workspace.Zombies:GetChildren()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Head") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health ~= 0 then
          if not plr.Character:FindFirstChildOfClass("Tool") then
            for _,gun in pairs(plr.Backpack:GetChildren()) do
              if gun:IsA("Tool") and gun:FindFirstChild("Fire") then
                gun.Parent = plr.Character
                tool = gun
              end
            end
          else
            if plr.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Fire") then
              tool = plr.Character:FindFirstChildOfClass("Tool")
            end
          end
          local yes = {}
          for i = 1,10 do
            table.insert(yes,{[1] = v.Head,[2] = v.Head.Position,[3] = Vector3.new(0,0,0),[4] = 0})
          end
          tool.Fire:FireServer(plr.Character.HumanoidRootPart.Position, tool.Handle.Muzzle.WorldPosition, {[1] = Vector3.new(0, 0, 0)}, require(tool.Config).BulletData, yes)
        end
      end
    end
  end
end
)
local afktoggle = w:Toggle("Anti AFK toggle", {flag = "TheAFK"})
spawn(
function()
  while wait() do
    if w.flags.TheAFK then
      wait(600)
      local VirtualUser=game:service'VirtualUser'
      VirtualUser:CaptureController()
      VirtualUser:ClickButton2(Vector2.new())
    end
  end
end
)
local serverhop  = w:Button("Click me to join the smallest server!", function() --I DIDNT MAKE THIS EITHER CREDIT TO https://v3rmillion.net/showthread.php?tid=1107863
getgenv().AutoTeleport = true
getgenv().DontTeleportTheSameNumber = true --If you set this true it won't teleport to the server if it has the same number of players as your current server
getgenv().CopytoClipboard = true

if not game:IsLoaded() then
    print("Game is loading waiting... | Empty Server Finder")
    repeat
        wait()
    until game:IsLoaded()
    end

local maxplayers = math.huge
local serversmaxplayer;
local goodserver;
local gamelink = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

function serversearch()
    for _, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink)).data) do
        if type(v) == "table" and maxplayers > v.playing then
            serversmaxplayer = v.maxPlayers
            maxplayers = v.playing
            goodserver = v.id
        end
    end
    print("Currently checking the servers with max this number of players : " .. maxplayers .. " | Empty Server Finder")
end

function getservers()
    serversearch()
    for i,v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink))) do
        if i == "nextPageCursor" then
            if gamelink:find("&cursor=") then
                local a = gamelink:find("&cursor=")
                local b = gamelink:sub(a)
                gamelink = gamelink:gsub(b, "")
            end
            gamelink = gamelink .. "&cursor=" ..v
            getservers()
        end
    end
end

getservers()

    print("All of the servers are searched") 
	print("Server : " .. goodserver .. " Players : " .. maxplayers .. "/" .. serversmaxplayer .. " | Empty Server Finder")
    if CopytoClipboard then
    setclipboard(goodserver)
    end
    if AutoTeleport then
        if DontTeleportTheSameNumber then 
            if #game:GetService("Players"):GetPlayers() - 1 == maxplayers then
                return warn("It has same number of players (except you)")
            elseif goodserver == game.JobId then
                return warn("Your current server is the most empty server atm") 
            end
        end
        print("AutoTeleport is enabled. Teleporting to : " .. goodserver)
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, goodserver)
    end
end)
