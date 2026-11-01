# MTwin-UI

Public files for MTwin HUB. No keys and no game code live here.

| file | what it is |
|---|---|
| `loader.lua` | Customer loader: waits for the game, then runs the hub's Luarmor loader (tries again if Luarmor fails before the hub starts) |
| `uhfork/` | Obsidian UI library, from github.com/uhfork/Obsidian (MIT, see `uhfork/LICENSE`) |
| `leanandhigh/` | Obsidian UI library with farm stats, from github.com/leanandhigh/Obsidian (MIT, see `leanandhigh/LICENSE`) |
| `icons/` | Lucide icons for the menus, pinned copy of github.com/mstudio45/lucide-roblox-direct (MIT, see `icons/LICENSE`); sprite sheets are kept in `MTwinHub/icons/`, not the folder other scripts share |

Customers run:

```lua
script_key = "KEY"
loadstring(game:HttpGet("https://raw.githubusercontent.com/mammot41038-beep/MTwin-UI/main/loader.lua"))()
```
