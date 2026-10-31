-- MTwin HUB loader (public). Customers run:
--   script_key = "KEY"
--   loadstring(game:HttpGet("https://raw.githubusercontent.com/mammot41038-beep/MTwin-UI/main/loader.lua"))()
-- Waits until the game has loaded, then runs the hub's Luarmor loader. Luarmor's own loader
-- sometimes fails right after joining (":8: attempt to perform arithmetic (mul) on nil and
-- number"), or returns without starting it: when the hub has not started, it is tried again a
-- moment later (3 tries). Each step is printed in the F9 console as [MTwin HUB loader].
-- No key or code of the hub is in this file.
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
while not Players.LocalPlayer do task.wait() end
task.wait(2)

local G = getgenv and getgenv() or _G
local Url = "https://api.luarmor.net/files/v4/loaders/fd1cff7baff01ea99d9e46f7aee17803.lua"

-- the key, wherever this executor kept `script_key = ...`: where Luarmor's loader looks for it
pcall(function()
	local Key = rawget(G, "script_key") or (getfenv and rawget(getfenv(0), "script_key")) or rawget(_G, "script_key")
	if type(Key) == "string" and Key ~= "" then
		G.script_key = Key
		script_key = Key
	end
end)

local function Log(Text)
	print("[MTwin HUB loader] " .. Text)
end

for Try = 1, 3 do
	G.MTwinHubStarted = nil
	Log("starting (try " .. Try .. "/3), game " .. tostring(game.PlaceId))

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
		return
	end

	warn("[MTwin HUB loader] the hub did not start (try " .. Try .. "/3): " .. (Ok and "Luarmor returned without starting it" or tostring(Err)))
	if Try < 3 then task.wait(3 * Try) end
end

pcall(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "MTwin HUB", Text = "Could not start - run the loader again", Duration = 10,
	})
end)
