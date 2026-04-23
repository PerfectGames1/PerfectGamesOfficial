local tweenService = game:GetService("TweenService")  -- variable for creating an animation for the user interface

local mainFolder = workspace.Obby
local obstacles = mainFolder.Obstacles -- this is to store the variable of the obstacles

game.Players.PlayerAdded:Connect(function(plr) -- this is to get the player once they join
	local folder = Instance.new("Folder") -- this is to make the leaderstats folder
	folder.Name = "leaderstats"  -- leaderstats as the name of the folder
	folder.Parent = plr -- the parent is the player
	
	local level = Instance.new("NumberValue") -- to store the level as a value
	level.Parent = folder
	level.Name = "Level"
	
	local rank = Instance.new("StringValue") -- to store the rank
	rank.Parent = folder
	rank.Name = "Rank"
	
	local touched1 = false
	
	local touched2 = false
	
	local function onTouch1() -- creating a function for when checkpoint is hit
		if touched1 == false then
			touched1 = true
			print("yeah touched1")
			obstacles["Level 1"].Checkpoint1.CanTouch = false -- disables the checkpoint so the player doesnt gain infinite levels
					
			level.Value = level.Value +1 
		end
	end
	obstacles["Level 1"].Checkpoint1.Touched:Connect(onTouch1) -- when the checkpoint is touched, it fires the function
	
	local function onTouch2() -- creating a function for when checkpoint is hit
		if touched2 == false then
			touched2 = true
			print("yeah touched2")
			obstacles["Level 2"].Checkpoint2.CanTouch = false -- disables the checkpoint so the player doesnt gain infinite levels

			level.Value = level.Value +1
			print("yeah")
			plr.Character.HumanoidRootPart.CFrame = obstacles["Level 3"].TpPlayer.CFrame
		end
	end
	obstacles["Level 2"].Checkpoint2.Touched:Connect(onTouch2) -- when the checkpoint is touched, it fires the function
	
	local screen = plr.PlayerGui:WaitForChild("MainUI")
	local holder = screen.holder
	
	local btn = screen.holder2.RankOpen
	local UIScale = holder.frame2.UIScale
	
	local frame2 = holder.frame2
	local scrolling = frame2.ScrollingFrame -- variables to hold the user interface
	
	local function rank1Clicked()
		if level.Value >= 1 then
			rank.Value = "BASIC"
			level.Value = level.Value -1
			screen.holder3.Cover.Visible = true
			tweenService:Create(screen.holder3.Cover, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {BackgroundTransparency = 0}):Play()
			tweenService:Create(screen.holder3.Cover.UIScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Scale = 10}):Play()
			task.wait(4)
			plr.Character.HumanoidRootPart.CFrame = mainFolder.RebirthTeleport.CFrame
			task.wait(1)
			tweenService:Create(screen.holder3.Cover, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {BackgroundTransparency = 1}):Play()
			tweenService:Create(screen.holder3.Cover.UIScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Scale = 0}):Play()
			if touched1 == true then
				touched1 = false
				touched2 = false
				obstacles["Level 1"].Checkpoint1.CanTouch = true -- enables the checkpoint so the player can play again
				obstacles["Level 2"].Checkpoint2.CanTouch = true
				level.Value = 0
			end
			task.wait(.5)
			screen.holder3.Cover.Visible = false
		end
	end
	scrolling.Rank1.MouseButton1Click:Connect(rank1Clicked)
	
	local function rank2Clicked()
		if level.Value >= 2 then
			rank.Value = "ROOKIE"
			level.Value = level.Value -2
			screen.holder3.Cover.Visible = true
			tweenService:Create(screen.holder3.Cover, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {BackgroundTransparency = 0}):Play()
			tweenService:Create(screen.holder3.Cover.UIScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Scale = 10}):Play()
			task.wait(4)
			plr.Character.HumanoidRootPart.CFrame = mainFolder.RebirthTeleport.CFrame
			task.wait(1)
			tweenService:Create(screen.holder3.Cover, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {BackgroundTransparency = 1}):Play()
			tweenService:Create(screen.holder3.Cover.UIScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Scale = 0}):Play()
			if touched1 == true then
				touched1 = false
				touched2 = false
				obstacles["Level 1"].Checkpoint1.CanTouch = true -- enables the checkpoint so the player can play again
				obstacles["Level 2"].Checkpoint2.CanTouch = true
				level.Value = 0
			end
			task.wait(.5)
			screen.holder3.Cover.Visible = false
		end
	end
	scrolling.Rank2.MouseButton1Click:Connect(rank2Clicked)
	
	local function rank3Clicked()
		if level.Value >= 3 then
			rank.Value = "AVERAGE"
			level.Value = level.Value -3
			screen.holder3.Cover.Visible = true
			tweenService:Create(screen.holder3.Cover, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {BackgroundTransparency = 0}):Play()
			tweenService:Create(screen.holder3.Cover.UIScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Scale = 10}):Play()
			task.wait(4)
			plr.Character.HumanoidRootPart.CFrame = mainFolder.RebirthTeleport.CFrame
			task.wait(1)
			tweenService:Create(screen.holder3.Cover, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {BackgroundTransparency = 1}):Play()
			tweenService:Create(screen.holder3.Cover.UIScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Scale = 0}):Play()
			if touched1 == true then
				touched1 = false
				touched2 = false
				obstacles["Level 1"].Checkpoint1.CanTouch = true -- enables the checkpoint so the player can play again
				obstacles["Level 2"].Checkpoint2.CanTouch = true
				level.Value = 0
			end
			task.wait(.5)
			screen.holder3.Cover.Visible = false
		end
	end
	scrolling.Rank3.MouseButton1Click:Connect(rank3Clicked)
	
	local function rank4Clicked()
		if level.Value >= 4 then
			rank.Value = "SWEAT"
			level.Value = level.Value -4
			screen.holder3.Cover.Visible = true
			tweenService:Create(screen.holder3.Cover, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {BackgroundTransparency = 0}):Play()
			tweenService:Create(screen.holder3.Cover.UIScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Scale = 10}):Play()
			task.wait(4)
			plr.Character.HumanoidRootPart.CFrame = mainFolder.RebirthTeleport.CFrame
			task.wait(1)
			tweenService:Create(screen.holder3.Cover, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {BackgroundTransparency = 1}):Play()
			tweenService:Create(screen.holder3.Cover.UIScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Scale = 0}):Play()
			if touched1 == true then
				touched1 = false
				touched2 = false
				obstacles["Level 1"].Checkpoint1.CanTouch = true -- enables the checkpoint so the player can play again
				obstacles["Level 2"].Checkpoint2.CanTouch = true
				level.Value = 0
			end
			task.wait(.5)
			screen.holder3.Cover.Visible = false
		end
	end
	scrolling.Rank4.MouseButton1Click:Connect(rank4Clicked)
	
	local function rank5Clicked()
		if level.Value >= 5 then
			rank.Value = "MASTER"
			level.Value = level.Value -5
			screen.holder3.Cover.Visible = true
			tweenService:Create(screen.holder3.Cover, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {BackgroundTransparency = 0}):Play()
			tweenService:Create(screen.holder3.Cover.UIScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Scale = 10}):Play()
			task.wait(4)
			plr.Character.HumanoidRootPart.CFrame = mainFolder.RebirthTeleport.CFrame
			task.wait(1)
			tweenService:Create(screen.holder3.Cover, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {BackgroundTransparency = 1}):Play()
			tweenService:Create(screen.holder3.Cover.UIScale, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Scale = 0}):Play()
			if touched1 == true then
				touched1 = false
				touched2 = false
				obstacles["Level 1"].Checkpoint1.CanTouch = true -- enables the checkpoint so the player can play again
				obstacles["Level 2"].Checkpoint2.CanTouch = true
				level.Value = 0
			end
			task.wait(.5)
			screen.holder3.Cover.Visible = false
		end
	end
	scrolling.Rank5.MouseButton1Click:Connect(rank5Clicked)
	
	local function clickedRank()
		for _, allInterface in pairs(plr.PlayerGui.MainUI:GetChildren()) do 
			if allInterface:IsA("GuiButton") then
				allInterface.Visible = false
			end
		end
		holder.Visible = true
		tweenService:Create(UIScale, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false), {Scale = 1}):Play() -- this plays the user interface animation
	end
	btn.MouseButton1Click:Connect(clickedRank)
	
	local function close()
		for _, allInterface in pairs(plr.PlayerGui.MainUI:GetChildren()) do
			if allInterface:IsA("GuiButton") then
				allInterface.Visible = true
			end
		end
		tweenService:Create(UIScale, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false), {Scale = 0}):Play() -- this closes the user interface
		task.wait(.2)
		holder.Visible = false
	end
	holder.frame2.Close.MouseButton1Click:Connect(close)
	
	local function hover()
		tweenService:Create(screen.holder2.RankOpen.UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false), {Scale = 1.2}):Play()
	end
	screen.holder2.RankOpen.MouseEnter:Connect(hover)
	
	local function unhover()
		tweenService:Create(btn.UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false), {Scale = 1}):Play()
	end
	btn.MouseLeave:Connect(unhover)
end)
local function disappearTouch()
	obstacles["Level 2"].One.CanTouch = false
	tweenService:Create(obstacles["Level 2"].One, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Transparency = 1}):Play()
	task.wait(2)
	obstacles["Level 2"].One.CanCollide = false
	task.wait(3)
	tweenService:Create(obstacles["Level 2"].One, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Transparency = 0}):Play()
	obstacles["Level 2"].One.CanCollide = true
	obstacles["Level 2"].One.CanTouch = true
end
obstacles["Level 2"].One.Touched:Connect(disappearTouch)

local function disappearTouch2()
	obstacles["Level 2"].Two.CanTouch = false
	tweenService:Create(obstacles["Level 2"].Two, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Transparency = 1}):Play()
	task.wait(2)
	obstacles["Level 2"].Two.CanCollide = false
	task.wait(3)
	tweenService:Create(obstacles["Level 2"].Two, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Transparency = 0}):Play()
	obstacles["Level 2"].Two.CanCollide = true
	obstacles["Level 2"].Two.CanTouch = true
end
obstacles["Level 2"].Two.Touched:Connect(disappearTouch2)

local function disappearTouch3()
	obstacles["Level 2"].Three.CanTouch = false
	tweenService:Create(obstacles["Level 2"].Three, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Transparency = 1}):Play()
	task.wait(2)
	obstacles["Level 2"].Three.CanCollide = false
	task.wait(3)
	tweenService:Create(obstacles["Level 2"].Three, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Transparency = 0}):Play()
	obstacles["Level 2"].Three.CanCollide = true
	obstacles["Level 2"].Three.CanTouch = true
end
obstacles["Level 2"].Three.Touched:Connect(disappearTouch3)

local function disappearTouch4()
	obstacles["Level 2"].Four.CanTouch = false
	tweenService:Create(obstacles["Level 2"].Four, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Transparency = 1}):Play()
	task.wait(2)
	obstacles["Level 2"].Four.CanCollide = false
	task.wait(3)
	tweenService:Create(obstacles["Level 2"].Four, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Transparency = 0}):Play()
	obstacles["Level 2"].Four.CanCollide = true
	obstacles["Level 2"].Four.CanTouch = true
end
obstacles["Level 2"].Four.Touched:Connect(disappearTouch4)
