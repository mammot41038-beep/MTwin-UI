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
	[79389059854988] = "https://api.luarmor.net/files/v4/loaders/a2b34aecda55a66d3fb16954c5c4a849.lua", -- My Anime Mine
	[142823291] = "https://api.luarmor.net/files/v4/loaders/a2b34aecda55a66d3fb16954c5c4a849.lua", -- Murder Mystery 2
	[113290951185459] = "https://api.luarmor.net/files/v4/loaders/ea5bcd6a6dc4122a0f7c06bf0c498154.lua", -- Anime Dice
	[8304191830] = "https://api.luarmor.net/files/v4/loaders/ea5bcd6a6dc4122a0f7c06bf0c498154.lua", -- Anime Adventures
	[14229839966] = "https://api.luarmor.net/files/v4/loaders/ea5bcd6a6dc4122a0f7c06bf0c498154.lua", -- Anime Adventures
	[14918509670] = "https://api.luarmor.net/files/v4/loaders/ea5bcd6a6dc4122a0f7c06bf0c498154.lua", -- Anime Adventures
	[8349889591] = "https://api.luarmor.net/files/v4/loaders/ea5bcd6a6dc4122a0f7c06bf0c498154.lua", -- Anime Adventures
	[10098525303] = "https://api.luarmor.net/files/v4/loaders/ea5bcd6a6dc4122a0f7c06bf0c498154.lua", -- Anime Adventures
	[14229762361] = "https://api.luarmor.net/files/v4/loaders/ea5bcd6a6dc4122a0f7c06bf0c498154.lua", -- Anime Adventures
	[79546208627805] = "https://api.luarmor.net/files/v4/loaders/81283a746e3ce8771a8a09a8c621545c.lua", -- 99 Nights in the Forest
	[126509999114328] = "https://api.luarmor.net/files/v4/loaders/81283a746e3ce8771a8a09a8c621545c.lua", -- 99 Nights in the Forest
	[132929771812494] = "https://api.luarmor.net/files/v4/loaders/81283a746e3ce8771a8a09a8c621545c.lua", -- Cameraman Tower Defense
	[114068177100380] = "https://api.luarmor.net/files/v4/loaders/81283a746e3ce8771a8a09a8c621545c.lua", -- Cameraman Tower Defense
	[114326934417838] = "https://api.luarmor.net/files/v4/loaders/ca60b5435fd330df725341db75e01792.lua", -- Break and Steal an Egg
	[97617452700163] = "https://api.luarmor.net/files/v4/loaders/6e5cca0d3b340f2214eb50c373b9df3b.lua", -- +1 Anime Eyes
	[137151641329864] = "https://api.luarmor.net/files/v4/loaders/6e5cca0d3b340f2214eb50c373b9df3b.lua", -- RoWorld
	[120219252362013] = "https://api.luarmor.net/files/v4/loaders/6e5cca0d3b340f2214eb50c373b9df3b.lua", -- Throw Food For Animals
	[72858262610964] = "https://api.luarmor.net/files/v4/loaders/ed0beadfb9c764375a8c297aefc4efb4.lua", -- Tap Simulator REBORN
	[16205713724] = "https://api.luarmor.net/files/v4/loaders/7eab7d5aae33a051aff8952c79bc0519.lua", -- Slayers 2
	[136406881576517] = "https://api.luarmor.net/files/v4/loaders/7eab7d5aae33a051aff8952c79bc0519.lua", -- Slayers 2
	[75556147183481] = "https://api.luarmor.net/files/v4/loaders/7eab7d5aae33a051aff8952c79bc0519.lua", -- Slayers 2
}

local Universes = {
	[10775182046] = "https://api.luarmor.net/files/v4/loaders/ca60b5435fd330df725341db75e01792.lua", -- Throw a Seed
	[10778033190] = "https://api.luarmor.net/files/v4/loaders/6e5cca0d3b340f2214eb50c373b9df3b.lua", -- Anime Champions X
	[10771053183] = "https://api.luarmor.net/files/v4/loaders/ed0beadfb9c764375a8c297aefc4efb4.lua", -- Net a Fish!
	[5595353122] = "https://api.luarmor.net/files/v4/loaders/7eab7d5aae33a051aff8952c79bc0519.lua", -- Slayers 2
}

local Url = Places[game.PlaceId] or Universes[game.GameId]
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
