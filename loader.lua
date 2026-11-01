-- MTwin HUB loader (public). Customers run:
--   script_key = "KEY"
--   loadstring(game:HttpGet("https://raw.githubusercontent.com/mammot41038-beep/MTwin-UI/main/loader.lua"))()
-- Waits until the game has loaded, then runs the hub's Luarmor loader. Luarmor's own loader
-- sometimes fails right after joining (":8: attempt to perform arithmetic (mul) on nil and
-- number"), or returns without starting it: when the hub has not started, it is tried again a
-- moment later, again and again (up to a minute apart). Each step is printed in the F9 console
-- (F9 only) as [MTwin HUB loader].
-- No key or code of the hub is in this file.
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
while not Players.LocalPlayer do task.wait() end
task.wait(2)

local G = getgenv and getgenv() or _G

-- the game's own print / warn: the lines go to the F9 console only, not the executor's window
local Env = getrenv and getrenv() or {}
local GamePrint = type(Env.print) == "function" and Env.print or print
local GameWarn = type(Env.warn) == "function" and Env.warn or warn

local function Log(Text)
	GamePrint("[MTwin HUB loader] " .. Text)
end

-- autoexec and a rejoin's queued loader can both start at once: the second one steps aside.
-- A copy that started over 45 s ago and is still trying is taken over instead (running it by
-- hand always works; the older copy stops at its next try)
local Busy = rawget(G, "MTwinLoaderBusy")

if type(Busy) == "number" and os.clock() - Busy < 45 then
	Log("another copy is starting the hub already")
	return
end

local Token = {}
G.MTwinLoaderBusy, G.MTwinLoaderToken = os.clock(), Token

local Url = "https://api.luarmor.net/files/v4/loaders/fd1cff7baff01ea99d9e46f7aee17803.lua"

-- the key, wherever this executor kept `script_key = ...`: where Luarmor's loader looks for it
pcall(function()
	local Key = rawget(G, "script_key") or (getfenv and rawget(getfenv(0), "script_key")) or rawget(_G, "script_key")
	if type(Key) == "string" and Key ~= "" then
		G.script_key = Key
		script_key = Key
	end
end)

-- nobody may be watching (24/7 runs): keep trying, a little slower each time (up to a minute)
local Try = 0

while true do
	-- a newer copy took over
	if G.MTwinLoaderToken ~= Token then return end

	Try += 1
	G.MTwinHubStarted = nil
	Log("starting (try " .. Try .. "), game " .. tostring(game.PlaceId))

	local Ok, Err = pcall(function()
		loadstring(game:HttpGet(Url))()
	end)

	-- the hub marks itself started at its first line. Luarmor can also fail without an error we
	-- can catch (in its own thread): give it a moment, and only a hub that never started is retried
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
