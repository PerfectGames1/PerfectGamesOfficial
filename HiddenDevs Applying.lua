local tweenService = game:GetService("TweenService")  -- variable for creating an animation for the user interface

local mainFolder = workspace.Obby
local obstacles = mainFolder.Obstacles -- this is to store the variable of the obstacles

local DataStore = game:GetService("DataStoreService")
local playerStore = DataStore:GetDataStore("ObbyData_V1")

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
	
	local savedData
	local success, errorMessage = pcall(function()
		savedData = playerStore:GetAsync(plr.UserId .. "-Save")
	end)
	
	if success and savedData then
		level.Value = savedData.Level
		rank.Value = savedData.Rank
		print("data has been loaded")
	else
		level.Value = 0
		rank.Value = "NONE"
		if not success then
			plr:Kick("Your data did not save correctly, please attempt a rejoin.")
		end
	end
	
	local touched1 = false
	
	local touched2 = false
	
	local ranks = {
		["Rank1"] = {Cost = 1, Title = "BASIC"},
		["Rank2"] = {Cost = 2, Title = "ROOKIE"},
		["Rank3"] = {Cost = 3, Title = "AVERAGE"},
		["Rank4"] = {Cost = 4, Title = "SWEAT"},
		["Rank5"] = {Cost = 5, Title = "MASTER"}
	}
	
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
	
	for _, UiButtons in pairs(scrolling:GetChildren()) do
		if UiButtons:IsA("GuiButton") and ranks[UiButtons.Name] then
			UiButtons.MouseButton1Click:Connect(function()
				local rankData = ranks[UiButtons.Name]
				if level.Value >= rankData.Cost then
					
					rank.Value = UiButtons.Name
					level.Value = level.Value - rankData.Cost
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
			end)
		end
	end
	
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
	
	screen.TwoXSpeed.MouseButton1Click:Connect(function()
		if plr.leaderstats.Level.Value >= screen.TwoXSpeed.Cost.Value then
			plr.Character.Humanoid.WalkSpeed = plr.Character.Humanoid.WalkSpeed +16
			plr.leaderstats.Level.Value = plr.leaderstats.Level.Value - screen.TwoXSpeed.Cost.Value
		end
	end)
	
	screen.TwoXSpeedAll.MouseButton1Click:Connect(function()
		if plr.leaderstats.Level.Value >= screen.TwoXSpeedAll.Cost.Value then
			for _, allPlayers in pairs(game.Players:GetPlayers()) do
				allPlayers.Character.Humanoid.WalkSpeed = allPlayers.Character.Humanoid.WalkSpeed +16
			end
			plr.leaderstats.Level.Value = plr.leaderstats.Level.Value - screen.TwoXSpeedAll.Cost.Value
		end
	end)
	
	screen.TwoXJump.MouseButton1Click:Connect(function()
		if plr.leaderstats.Level.Value >= screen.TwoXJump.Cost.Value then
			for _, allPlayers in pairs(game.Players:GetPlayers()) do
				allPlayers.Character.Humanoid.JumpPower = allPlayers.Character.Humanoid.JumpPower +50
			end
			plr.leaderstats.Level.Value = plr.leaderstats.Level.Value - screen.TwoXJump.Cost.Value
		end
	end)
end)
task.wait(3)
local obstacles = {
	["One"] = true,
	["Two"] = true,
	["Three"] = true,
	["Four"] = true,
	["Five"] = true, 
	["Six"] = true,
	["Seven"] = true,
	["Eight"] = true
}

for _, allParts in pairs(workspace.Obby.Obstacles:GetChildren()) do
	if allParts:IsA("BasePart") and obstacles[allParts.Name] then
		allParts.Touched:Connect(function()
			if allParts.CanTouch == true then
			allParts.CanTouch = false
			tweenService:Create(allParts, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Transparency = 1}):Play()
			task.wait(2)
			allParts.CanCollide = false
			task.wait(3)
			tweenService:Create(allParts, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {Transparency = 0}):Play()
			allParts.CanCollide = true
			allParts.CanTouch = true
			end
		end)
	end
end

game.Players.PlayerRemoving:Connect(function(plr)
	local dataSave = {
		Level = plr.leaderstats.Level.Value,
		Rank = plr.leaderstats.Rank.Value
	}
	
	local success, errorMessage = pcall(function()
		playerStore:SetAsync(plr.UserId .. "-Save", dataSave)
	end)
	
	if success then
		print("your data has been saved")
	else
		warn("there has been an error saving data, maybe error inside output or missing leaderstats?" .. errorMessage)
	end
end)
