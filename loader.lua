-- MTwin HUB loader (public). Customers run:
--   script_key = "KEY"
--   loadstring(game:HttpGet("https://raw.githubusercontent.com/mammot41038-beep/MTwin-UI/main/loader.lua"))()
-- Waits until the game has loaded, then runs the hub's Luarmor loader. Luarmor's own loader
-- sometimes fails right after joining (":8: attempt to perform arithmetic (mul) on nil and
-- number"): when that happens before the hub has started, it is tried again a moment later.
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

for Try = 1, 3 do
	G.MTwinHubStarted = nil

	local Ok, Err = pcall(function()
		loadstring(game:HttpGet(Url))()
	end)

	-- done, or the hub itself is running (an error after that is the game script's, not Luarmor's)
	if Ok or G.MTwinHubStarted then return end

	warn("[MTwin HUB] loader failed (try " .. Try .. "/3): " .. tostring(Err))
	if Try < 3 then task.wait(3 * Try) end
end

pcall(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "MTwin HUB", Text = "Could not start - run the loader again", Duration = 10,
	})
end)
