if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
while not Players.LocalPlayer do task.wait() end
task.wait(2)

local G = getgenv and getgenv() or _G
local Me = Players.LocalPlayer

local Env = getrenv and getrenv() or {}
local GamePrint = type(Env.print) == "function" and Env.print or print
local GameWarn = type(Env.warn) == "function" and Env.warn or warn

local function Log(Text)
	GamePrint("[MTwin HUB loader] " .. Text)
end

local function Notify(Text, Time)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", { Title = "MTwin HUB", Text = Text, Duration = Time or 10 })
	end)
end

local Self = "https://raw.githubusercontent.com/mammot41038-beep/MTwin-UI/main/loader.lua"

local Places = {
	[79389059854988] = "https://api.luarmor.net/files/v4/loaders/8fbd3c15e602fca69858ae963eb61375.lua", -- My Anime Mine
	[8304191830] = "https://api.luarmor.net/files/v4/loaders/8fbd3c15e602fca69858ae963eb61375.lua", -- Anime Adventures
	[14229839966] = "https://api.luarmor.net/files/v4/loaders/8fbd3c15e602fca69858ae963eb61375.lua", -- Anime Adventures
	[14918509670] = "https://api.luarmor.net/files/v4/loaders/8fbd3c15e602fca69858ae963eb61375.lua", -- Anime Adventures
	[8349889591] = "https://api.luarmor.net/files/v4/loaders/8fbd3c15e602fca69858ae963eb61375.lua", -- Anime Adventures
	[10098525303] = "https://api.luarmor.net/files/v4/loaders/8fbd3c15e602fca69858ae963eb61375.lua", -- Anime Adventures
	[14229762361] = "https://api.luarmor.net/files/v4/loaders/8fbd3c15e602fca69858ae963eb61375.lua", -- Anime Adventures
	[114326934417838] = "https://api.luarmor.net/files/v4/loaders/ace673399f74082818e13b3a038e796b.lua", -- Break and Steal an Egg
	[97617452700163] = "https://api.luarmor.net/files/v4/loaders/ace673399f74082818e13b3a038e796b.lua", -- +1 Anime Eyes
	[120219252362013] = "https://api.luarmor.net/files/v4/loaders/ace673399f74082818e13b3a038e796b.lua", -- Throw Food For Animals
	[79546208627805] = "https://api.luarmor.net/files/v4/loaders/2b05127902f94b4c0b6458a40c852dc1.lua", -- 99 Nights in the Forest
	[126509999114328] = "https://api.luarmor.net/files/v4/loaders/2b05127902f94b4c0b6458a40c852dc1.lua", -- 99 Nights in the Forest
	[142823291] = "https://api.luarmor.net/files/v4/loaders/2b05127902f94b4c0b6458a40c852dc1.lua", -- Murder Mystery 2
	[113290951185459] = "https://api.luarmor.net/files/v4/loaders/bcb1fb290cb506ca730fd30ca4ed3559.lua", -- Anime Dice
	[72858262610964] = "https://api.luarmor.net/files/v4/loaders/bcb1fb290cb506ca730fd30ca4ed3559.lua", -- Tap Simulator REBORN
	[137151641329864] = "https://api.luarmor.net/files/v4/loaders/bcb1fb290cb506ca730fd30ca4ed3559.lua", -- RoWorld
}

local Url = Places[game.PlaceId]
if not Url then
	Log("game " .. tostring(game.PlaceId) .. " is not supported")
	Notify("This game is not supported (PlaceId " .. tostring(game.PlaceId) .. ")")
	return
end

local Busy = rawget(G, "MTwinLoaderBusy")

if type(Busy) == "number" and os.clock() - Busy < 45 then
	Log("another copy is starting the hub already")
	return
end

local Token = {}
G.MTwinLoaderBusy, G.MTwinLoaderToken = os.clock(), Token

pcall(function()
	local Key = rawget(G, "script_key") or (getfenv and rawget(getfenv(0), "script_key")) or rawget(_G, "script_key")
	if type(Key) == "string" and Key ~= "" then
		G.script_key = Key
		script_key = Key
	end
end)

do
	local Waited = 0
	while not Me.Character and Waited < 20 do Waited += task.wait(0.25) end
	while time() < 10 and Waited < 30 do Waited += task.wait(0.25) end
end

local Suffix = "Hub_" .. tostring(Me.UserId)
local function GameUp()
	for Key, Value in pairs(G) do
		if type(Key) == "string" and string.sub(Key, -#Suffix) == Suffix and type(Value) == "table" then return true end
	end
	return false
end

local function Rejoin()
	local Key = rawget(G, "script_key")
	local Queue = queue_on_teleport or (syn and syn.queue_on_teleport)
	if type(Key) ~= "string" or Key == "" or not Queue then return end
	Log("the game script keeps failing: rejoining")
	G.MTwinLoaderBusy = nil
	pcall(Queue, string.format("script_key = %q\nloadstring(game:HttpGet(%q))()", Key, Self))
	pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, Me) end)
end

local Try = 0

while true do
	if G.MTwinLoaderToken ~= Token then return end

	Try += 1
	G.MTwinHubStarted = nil
	Log("starting (try " .. Try .. "), game " .. tostring(game.PlaceId))

	local Ok, Err = pcall(function()
		loadstring(game:HttpGet(Url))()
	end)

	local Waited = 0
	while not GameUp() and Waited < 20 do Waited += task.wait(0.5) end

	if GameUp() then
		Log("hub started")
		if G.MTwinLoaderToken == Token then G.MTwinLoaderBusy = nil end
		return
	end

	GameWarn("[MTwin HUB loader] the hub did not start (try " .. Try .. "): "
		.. (Ok and (G.MTwinHubStarted and "the game script stopped early" or "Luarmor returned without starting it") or tostring(Err)))

	if Try == 3 then Notify("Could not start yet - still trying by itself") end
	if Try % 10 == 0 then Rejoin() end

	task.wait(math.min(5 * 2 ^ (math.min(Try, 5) - 1), 60))
end
