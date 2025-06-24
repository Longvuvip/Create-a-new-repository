--[[ LongDepTrai - Anime Obby X Auto Setup Script
📦 Tạo map 5 tầng kiểu Anime Tow
🧍‍♂️ Nhân vật chờ + chọn nhân vật
🥇 Win để mở khóa
🚫 Anti fly/speed hack
✅ PC & mobile hỗ trợ tốt
]]--

local Http = game:HttpGet
local Load = loadstring

-- Tạo các script chính
local function MakeScript(parent, name, source)
	local s = Instance.new("Script")
	s.Name = name
	s.Source = source
	s.Parent = parent
end

local function MakeLocalScript(parent, name, source)
	local s = Instance.new("LocalScript")
	s.Name = name
	s.Source = source
	s.Parent = parent
end

-- Tạo leaderstats
MakeScript(game:GetService("ServerScriptService"), "Leaderstats", [==[
game.Players.PlayerAdded:Connect(function(player)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player

	local wins = Instance.new("IntValue")
	wins.Name = "Wins"
	wins.Value = 0
	wins.Parent = stats
end)
]==])

-- Script cộng Win khi chạm WinPad
MakeScript(game:GetService("ServerScriptService"), "ObbyWinHandler", [==[
local WinPad = workspace:WaitForChild("WinPad")

WinPad.Touched:Connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player and not player:FindFirstChild("JustWon") then
		local tag = Instance.new("BoolValue")
		tag.Name = "JustWon"
		tag.Parent = player
		local stats = player:FindFirstChild("leaderstats")
		if stats then
			stats.Wins.Value += 1
		end
		wait(3)
		player:LoadCharacter()
	end
end)
]==])

-- Anti Exploit
MakeScript(game:GetService("ServerScriptService"), "AntiExploit", [==[
game:GetService("RunService").Stepped:Connect(function()
	for _, player in pairs(game.Players:GetPlayers()) do
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
			if char.HumanoidRootPart.Velocity.Y > 120 or char.Humanoid.WalkSpeed > 32 then
				player:Kick("Exploit detected.")
			end
		end
	end
end)
]==])

-- RemoteEvent + nhân vật model
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local charEvent = Instance.new("RemoteEvent", ReplicatedStorage)
charEvent.Name = "SelectCharacter"

local charFolder = Instance.new("Folder", ReplicatedStorage)
charFolder.Name = "Characters"

-- Dummy nhân vật placeholder
for _, name in pairs({"Luffy", "Naruto", "Goku", "Saitama"}) do
	local dummy = Instance.new("Model", charFolder)
	dummy.Name = name
	local hum = Instance.new("Humanoid", dummy)
	local part = Instance.new("Part", dummy)
	part.Name = "HumanoidRootPart"
	part.Anchored = true
end

-- Chọn nhân vật
MakeScript(game:GetService("ServerScriptService"), "CharacterSelectHandler", [==[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharactersFolder = ReplicatedStorage:WaitForChild("Characters")
local SelectCharacter = ReplicatedStorage:WaitForChild("SelectCharacter")

SelectCharacter.OnServerEvent:Connect(function(player, charName)
	local stats = player:FindFirstChild("leaderstats")
	if not stats then return end

	local wins = stats:FindFirstChild("Wins").Value
	local requiredWins = {
		["Luffy"] = 0,
		["Naruto"] = 5,
		["Goku"] = 10,
		["Saitama"] = 20,
	}

	if wins >= (requiredWins[charName] or 0) then
		local charModel = CharactersFolder:FindFirstChild(charName)
		if charModel then
			local clone = charModel:Clone()
			player.Character = clone
			clone.Parent = workspace
			clone:MoveTo(workspace.SpawnLocation.Position)
		end
	end
end)
]==])

-- UI chọn nhân vật
local gui = Instance.new("ScreenGui", game:GetService("StarterGui"))
gui.Name = "CharacterUI"

local function makeButton(name, pos)
	local btn = Instance.new("TextButton", gui)
	btn.Name = name.."Button"
	btn.Size = UDim2.new(0, 120, 0, 40)
	btn.Position = UDim2.new(0, pos, 0, 50)
	btn.Text = name
	return btn
end

local buttons = {
	makeButton("Luffy", 20),
	makeButton("Naruto", 160),
	makeButton("Goku", 300),
	makeButton("Saitama", 440)
}

-- Gửi request chọn nhân vật
MakeLocalScript(gui, "CharacterLocal", [==[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SelectCharacter = ReplicatedStorage:WaitForChild("SelectCharacter")

script.Parent.LuffyButton.MouseButton1Click:Connect(function()
	SelectCharacter:FireServer("Luffy")
end)

script.Parent.NarutoButton.MouseButton1Click:Connect(function()
	SelectCharacter:FireServer("Naruto")
end)

script.Parent.GokuButton.MouseButton1Click:Connect(function()
	SelectCharacter:FireServer("Goku")
end)

script.Parent.SaitamaButton.MouseButton1Click:Connect(function()
	SelectCharacter:FireServer("Saitama")
end)
]==])

-- Tạo map obby đơn giản
local spacing = 60
local themes = {
	{color = BrickColor.Red(), name = "Luffy"},
	{color = BrickColor.Orange(), name = "Naruto"},
	{color = BrickColor.Yellow(), name = "Goku"},
	{color = BrickColor.Blue(), name = "Saitama"},
	{color = BrickColor.White(), name = "Boss"}
}

for i, theme in ipairs(themes) do
	local floor = Instance.new("Part")
	floor.Anchored = true
	floor.Size = Vector3.new(60, 2, 60)
	floor.Position = Vector3.new(0, i * spacing, 0)
	floor.BrickColor = theme.color
	floor.Name = "Floor_" .. theme.name
	floor.Parent = workspace
end

-- WinPad cuối map
local winPart = Instance.new("Part")
winPart.Name = "WinPad"
winPart.Size = Vector3.new(10,1,10)
winPart.Position = Vector3.new(0, (#themes + 1) * spacing, 0)
winPart.Anchored = true
winPart.BrickColor = BrickColor.Green()
winPart.Parent = workspace
