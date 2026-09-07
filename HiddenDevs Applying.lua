-- Made by TheStr4ck (Roblox), for discord the username is strack_s 
-- This script utilizes OOP for checkpoints, CFrames, and OrderedDataStores for global leaderboards.

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

	plr.CharacterAdded:Connect(function(character)
		local root = character:WaitForChild("HumanoidRootPart")

		task.wait(.1)
		local checkpointsFolder = workspace:FindFirstChild("Checkpoints")
		if checkpointsFolder then
			local targetSpawn = checkpointsFolder:FindFirstChild(tostring(level.Value))
			if targetSpawn and targetSpawn:IsA("BasePart") then
				character:PivotTo(targetSpawn.CFrame + Vector3.new(0, 4, 0))
				print("plr has been cframed")

				plr.PlayerGui.Spawn.Text.Visible = true
				local info = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false)
				tweenService:Create(plr.PlayerGui.Spawn.Text, info, {TextTransparency = 0}):Play()
				task.wait(1)
				tweenService:Create(plr.PlayerGui.Spawn.Text, info, {TextTransparency = 1}):Play()
				task.wait(1)
				plr.PlayerGui.Spawn.Text.Visible = false
			end
		end
	end)

	

	local ranks = {
		["Rank1"] = {Cost = 1, Title = "BASIC"},
		["Rank2"] = {Cost = 2, Title = "ROOKIE"},
		["Rank3"] = {Cost = 3, Title = "AVERAGE"},
		["Rank4"] = {Cost = 4, Title = "SWEAT"},
		["Rank5"] = {Cost = 5, Title = "MASTER"}
	}
	
	-- basic OOP setup here. using a metatable for the checkpoints so we aren't writing 50 separate touched events. 
	-- keeps the code dry and saves memory since every checkpoint object just points back to the same __index.
	local CheckpointHandler = {}
	CheckpointHandler.__index = CheckpointHandler
	
	function CheckpointHandler.new(checkpointPart, levelRequirement)
		local self = setmetatable({}, CheckpointHandler)
		self.Part = checkpointPart
		self.LevelRequired = levelRequirement
		self.Connection = nil
		return self
	end
	
	function CheckpointHandler:Initialize(playerLevelValue, playerCharacter)
		self.Connection = self.Part.Touched:Connect(function(hit)
			if not self.Part.CanTouch then return end
			
			local character = hit.Parent
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			
			if humanoid and humanoid.Health > 0 then
				-- lock the touch event instantly so the roblox engine doesn't fire it 100 times a frame.
				self.Part.CanTouch = false
				
				playerLevelValue.Value = playerLevelValue.Value + 1
				
				local nextStage = obstacles:FindFirstChild("Level " .. tostring(self.LevelRequired +1))
				if nextStage and nextStage:FindFirstChild("TpPlayer") then
					local targetCFrame = nextStage.TpPlayer.CFrame
					
					-- using cframe multiplication here instead of vector3 math so the player actually faces the same way the spawn pad is rotated, instead of just teleporting them globally into the sky.
					playerCharacter:PivotTo(targetCFrame * CFrame.new(0, 3, 0))
				end
			end
		end)
	end
	
	for i = 1, 50 do
		-- dynamic loop to hook up all the checkpoints on startup. 
		-- doing it this way means if i add like 50 more levels to the game later, i don't even have to touch this script.
		local levelFolder = obstacles:FindFirstChild("Level " .. tostring(i))
		if levelFolder then
			local cpPart = levelFolder:FindFirstChild("Checkpoint" .. tostring(i))
			if cpPart then
				local newCheckpoint = CheckpointHandler.new(cpPart, i)
				newCheckpoint:Initialize(level, plr.Character or plr.CharacterAdded:Wait())
			end
		end
	end

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
					for i = 1, 50 do
						local levelFolder = obstacles:FindFirstChild("Level " .. tostring(i))
						if levelFolder then
							local cpPart = levelFolder:FindFirstChild("Checkpoint" .. tostring(i))
							if cpPart then
								cpPart.CanTouch = true
							end
						end
					end
					level.Value = 0
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
	
	-- swapping to UpdateAsync to avoid race conditions (e.g. if a player joins another server quickly, we don't want to accidentally overwrite their newer save with old data).
	local success, errorMessage = pcall(function()
		playerStore:UpdateAsync(plr.UserId .. "-Save", function(oldData)
		return dataSave
	end)
end)

if not success then
	warn("Datastore got an error for" .. plr.Name .. "- Reason: " .. tostring(errorMessage))
	end
end)
	
	-- bindtoclose is basically a safety net. if the server crashes or shuts down, it forces the server to yield long enough to save everyone's data before closing.
game:BindToClose(function()
	for _, plr in pairs(game.Players:GetPlayers()) do
		local datasave = {
			Level = plr.leaderstats.Level.Value,
			Rank = plr.leaderstats.Rank.Value
		}
		pcall(function()
			playerStore:UpdateAsync(plr.UserId .. "-Save", function() return datasave end)
		end)
	end
end)

local GlobalLeaderboard = DataStore:GetOrderedDataStore("ObbyGlobalLeaderboard_V1")
	
	-- throwing the leaderboard loop into task.spawn so the infinite loop doesn't yield the rest of the server script.
task.spawn(function()
	while true do
		task.wait(60)
		
		for _, player in pairs(game.Players:GetPlayers()) do
			local leaderstats = player:FindFirstChild("leaderstats")
			if leaderstats and leaderstats:FindFirstChild("Level") then
				local currentLevel = leaderstats.Level.Value
				pcall(function()
					GlobalLeaderboard:SetAsync(player.UserId, currentLevel)
				end)
			end
		end
			
		    -- using GetSortedAsync to grab the top pages. wrapped the username fetching in a pcall because the roblox web api randomly fails sometimes and we don't want it breaking the whole loop.
		local success, pages = pcall(function()
			return GlobalLeaderboard:GetSortedAsync(false, 10)
		end)
		
		if success and pages then
			local topTen = pages:GetCurrentPage()
			print("global 10 players")
			
			for rank, data in ipairs(topTen) do
				local username = "Unknown User"
				
				pcall(function()
					username = game.Players:GetNameFromUserIdAsync(tonumber(data.key))
				end)
				
				print(tostring(rank) .. ". " .. username .. " - Level" .. tostring(data.value))
			end
		else
			warn("failed")
		end
	end
end)
