local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kiwi-i/wallys-ui-fork/master/lib.lua", true))()
library.options.underlinecolor = "rainbow"
local w = library:CreateWindow('Main')
w:Section('The Goods')
local Toggle = w:Toggle("Autokill Toggle", {flag = "TheYes"})
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
local Toggle = w:Toggle("Anti AFK toggle", {flag = "TheAFK"})
spawn(
function()
  while wait() do
    if w.flags.TheAFK then
      while wait(600) do
        local VirtualUser=game:service'VirtualUser'
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
      end
    end
  end
end
)
