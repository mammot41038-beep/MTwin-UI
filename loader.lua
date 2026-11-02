if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
while not Players.LocalPlayer do task.wait() end
task.wait(2)

local G = getgenv and getgenv() or _G

local Env = getrenv and getrenv() or {}
local GamePrint = type(Env.print) == "function" and Env.print or print
local GameWarn = type(Env.warn) == "function" and Env.warn or warn

local function Log(Text)
	GamePrint("[MTwin HUB loader] " .. Text)
end

local Busy = rawget(G, "MTwinLoaderBusy")

if type(Busy) == "number" and os.clock() - Busy < 45 then
	Log("another copy is starting the hub already")
	return
end

local Token = {}
G.MTwinLoaderBusy, G.MTwinLoaderToken = os.clock(), Token

local Url = "https://api.luarmor.net/files/v4/loaders/fd1cff7baff01ea99d9e46f7aee17803.lua"

pcall(function()
	local Key = rawget(G, "script_key") or (getfenv and rawget(getfenv(0), "script_key")) or rawget(_G, "script_key")
	if type(Key) == "string" and Key ~= "" then
		G.script_key = Key
		script_key = Key
	end
end)

local Try = 0

while true do
	if G.MTwinLoaderToken ~= Token then return end

	Try += 1
	G.MTwinHubStarted = nil
	Log("starting (try " .. Try .. "), game " .. tostring(game.PlaceId))

	local Ok, Err = pcall(function()
		loadstring(game:HttpGet(Url))()
	end)

	if Ok and not G.MTwinHubStarted then
		local Waited = 0
		while not G.MTwinHubStarted and Waited < 20 do Waited += task.wait(0.5) end
	end

	if G.MTwinHubStarted then
		Log("hub started")
		if G.MTwinLoaderToken == Token then G.MTwinLoaderBusy = nil end
		return
	end

	GameWarn("[MTwin HUB loader] the hub did not start (try " .. Try .. "): " .. (Ok and "Luarmor returned without starting it" or tostring(Err)))

	if Try == 3 then
		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "MTwin HUB", Text = "Could not start yet - still trying by itself", Duration = 10,
			})
		end)
	end

	task.wait(math.min(5 * 2 ^ (math.min(Try, 5) - 1), 60))
end
