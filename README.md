# MTwin-UI

Public files for MTwin HUB. No keys and no game code live here.

| file | what it is |
|---|---|
| `loader.lua` | Customer loader |
| `uhfork/` | Obsidian UI library, from github.com/uhfork/Obsidian (MIT, see `uhfork/LICENSE`) |
| `leanandhigh/` | Obsidian UI library with farm stats, from github.com/leanandhigh/Obsidian (MIT, see `leanandhigh/LICENSE`) |
| `cascade/` | Cascade UI library (the new menus), MTwin HUB build of github.com/leanandhigh/Cascade (MIT, see `cascade/LICENSE`) |
| `fonts/` | MTwin Thai Looped: Noto Sans Thai Looped (Thai with heads) + Noto Sans (Latin) merged, for Thai menu text (SIL OFL 1.1, see `fonts/OFL.txt`) |
| `icons/` | Lucide icons for the menus, from github.com/mstudio45/lucide-roblox-direct (MIT, see `icons/LICENSE`) |

Customers run:

```lua
script_key = "KEY"
loadstring(game:HttpGet("https://raw.githubusercontent.com/mammot41038-beep/MTwin-UI/main/loader.lua"))()
```
