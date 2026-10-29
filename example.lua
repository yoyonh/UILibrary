-- ZeninUI example: demonstrates every element and the main window features.
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/egorovsankin988-create/Library/refs/heads/main/library.lua"))()

local Window = Library:CreateWindow({
	Title = "Zenin Demo",
	Logo = "Z",
	Theme = "Dark",
	Accent = Color3.fromRGB(255, 89, 89),
	ToggleKey = Enum.KeyCode.RightShift,
	ConfigFolder = "ZeninDemo",
	Animation = true, -- open/close fade + scale animation (set false to disable)
	-- On-screen keyboard on phones/tablets (PC always keeps the normal keyboard). false = off.
	-- It stays inactive while the key prompt is on screen and switches on once the menu is built.
	-- Opens full-width; its minimise button turns it into a small draggable panel.
	CustomKeyboard = true,
	-- Optional fine-tuning (same table as Library.Keyboard:Configure{}); everything scales from
	-- one row height, so the proportions hold on every screen size and in compact mode.
	Keyboard = {
		-- Mode = "Auto",        -- "Auto" (touch-only devices) | "Always" (also PC) | "Off"
		-- Compact = false,      -- start as the small draggable panel
		-- Scale = 1,            -- size multiplier
		-- Dock = "Bottom",      -- or "Top"
		-- Width = 1,            -- docked width as a fraction of the screen
		-- Height = 0.56,        -- docked height as a fraction of the screen (capped by KeyAspect)
		-- Layout = "Default",   -- "Default" | "Simple" | "Numeric" | your own (Library.Keyboard:AddLayout)
		-- Tools = {"undo", "redo", "select", "all", "home", "end"}, -- toolbar; false hides it
		-- Padding = 0.15, Gap = 0.1, KeyRadius = 0.18, TextScale = 1,
		-- RepeatDelay = 0.4, RepeatRate = 0.05, CloseOnEnter = true, CapitalizeFirst = false,
		-- Colors = {Panel = Color3.fromRGB(10, 10, 10), Enter = Color3.fromRGB(255, 89, 89)},
	},
	Configs = true,
	-- Floating list of keybinds. Tap/click a row to trigger it, which is how binds work on phones.
	-- On touch-only devices, tapping a keybind's key button also triggers it (there are no keys to bind).
	KeybindList = {
		Visible = true,
		ShowInactive = true,   -- false = only show binds that are currently on
		-- Position = UDim2.fromOffset(8, 42),
	},
	Watermark = {
		Title = "Zenin Demo",
		Site = "zenin.gg",
		Modes = {"Time", "FPS", "Ping"},
	},

	-- Shown before the menu; remove this block to disable it.
	KeySystem = {
		Title = "Zenin Demo",
		Note = "Keys: zenin-demo (lifetime) or zenin-trial (2 min)",
		Keys = {
			"zenin-demo",                         -- never expires
			["zenin-trial"] = os.time() + 120,    -- expires at this unix time
			-- ["vip-key"] = {Duration = 86400, Hwid = "device-id", Users = {12345}, Note = "VIP"},
		},
		-- Keys that never appear in plain text: store Library.Sha256("the-key") instead.
		-- Hashes = {"<sha256 hex>", ["<sha256 hex>"] = {Expires = 1735689600}},
		-- Duration = 3600, -- optional: every key expires this many seconds after it was entered
		-- CaseSensitive = false, StripSpaces = true, Pattern = "^zenin%-[%w]+$", MinLength = 6,
		-- Whitelist = {12345, "Username", "hwid"}, -- skip the prompt entirely for these
		-- Blacklist = {67890},                      -- never accept anything from these
		-- BindHwid = true,  -- the saved key file is signed and only valid on the device it was saved on
		-- Texts = {Note = "Enter your key", Verify = "Unlock", TooMany = "Wait %ds"}, -- any prompt string
		-- ErrorFlash = true, -- red border flash on a wrong key (no shaking)

		-- Your own server-side check (optional). Return true to accept (optionally with the unix
		-- expiry time), or false plus a message. It is re-run every CheckInterval seconds, so
		-- revoking or expiring a key on the server closes the menu within that time.
		-- Verify = function(key, hwid, player)
		-- 	local res = request({Url = "https://your.server/verify?key=" .. key .. "&hwid=" .. hwid, Method = "GET"})
		-- 	local data = game:GetService("HttpService"):JSONDecode(res.Body)
		-- 	return data.valid == true, data.valid and data.expires or data.message
		-- end,
		-- Or just a URL; the response can be "valid" or JSON {"valid": true, "expires": 1735689600}.
		-- Url = "https://your.server/verify?key={key}&hwid={hwid}",
		-- CheckInterval = 60,  -- seconds between live re-checks (default 60 with Url/Verify)

		GetKeyLink = "https://example.com/get-key",
		SaveKey = true,
		MaxAttempts = 5,
		Cooldown = 30,
		OnSuccess = function(key, info) print("Key accepted:", key, info.Source, info.Expires and ("expires " .. os.date("%c", info.Expires)) or "lifetime") end,
		-- OnFail = function(key, message, attempts) end, OnLocked = function(seconds) end,
		-- When the key expires or is revoked: the menu closes, every element returns to its default
		-- (callbacks fire, so features switch off), keybinds are released, the watermark is hidden,
		-- and the key is asked again. ResetOnExpire = false keeps element values instead.
		OnExpire = function(reason) print("Key expired:", reason) end,
	},
})

local function Notify(text)
	Window:Notify({Title = "Zenin Demo", Content = text, Duration = 3})
end

------------------------------------------------------------------------
-- Tab 1: basic controls
------------------------------------------------------------------------
local Main = Window:AddTab({Name = "Main", Icon = "home"})

local Toggles = Main:AddSection({Name = "Toggles & Sliders", Side = "Left"})

local Enabled = Toggles:AddToggle({
	Name = "Enabled",
	Flag = "Enabled",
	Default = false,
	Callback = function(v) print("Enabled:", v) end,
})

local Speed = Toggles:AddSlider({
	Name = "Speed",
	Flag = "Speed",
	Min = 16, Max = 200, Default = 16, Step = 1,
	Suffix = " studs",
	Callback = function(v) print("Speed:", v) end,
})
Speed:DependsOn(Enabled) -- greyed out until "Enabled" is on

Toggles:AddSlider({
	Name = "Smoothness",
	Flag = "Smoothness",
	Min = 0, Max = 1, Default = 0.5, Step = 0.05,
	Callback = function(v) print("Smoothness:", v) end,
})

-- Element settings panel (gear icon next to the toggle)
local Esp = Toggles:AddToggle({Name = "ESP", Flag = "Esp", Default = true})
local EspSettings = Esp:AddSettings({Title = "ESP Settings"})
EspSettings:AddToggle({Name = "Boxes", Flag = "EspBoxes", Default = true})
EspSettings:AddToggle({Name = "Names", Flag = "EspNames", Default = false})
EspSettings:AddSlider({Name = "Max Distance", Flag = "EspDistance", Min = 50, Max = 2000, Default = 500, Suffix = "m"})
EspSettings:AddColorPicker({Name = "Box Color", Flag = "EspColor", Default = Color3.fromRGB(255, 89, 89)})

local Dropdowns = Main:AddSection({Name = "Dropdowns", Side = "Right"})

local Mode = Dropdowns:AddDropdown({
	Name = "Mode",
	Flag = "Mode",
	Options = {"Legit", "Rage", "Custom"},
	Default = "Legit",
	Callback = function(v) print("Mode:", v) end,
})

Dropdowns:AddMultiDropdown({
	Name = "Targets",
	Flag = "Targets",
	Options = {"Head", "Torso", "Arms", "Legs"},
	Default = {"Head", "Torso"},
	Callback = function(list) print("Targets:", table.concat(list, ", ")) end,
})

Dropdowns:AddDropdown({
	Name = "Player",
	Flag = "Player",
	Options = {},
	Placeholder = "Pick a player",
	MaxVisible = 6,
})

Dropdowns:AddButton({
	Name = "Refresh Players",
	Callback = function()
		local names = {}
		for _, p in ipairs(game:GetService("Players"):GetPlayers()) do table.insert(names, p.Name) end
		Library.Options.Player:SetOptions(names)
		return "Found " .. #names -- returned text flashes on the button
	end,
})

Mode:OnChanged(function(v) Notify("Mode changed to " .. tostring(v)) end)

------------------------------------------------------------------------
-- Tab 2: input, keybinds, colors
------------------------------------------------------------------------
local Misc = Window:AddTab({Name = "Misc", Icon = "sliders-horizontal"})

local Inputs = Misc:AddSection({Name = "Inputs", Side = "Left"})

Inputs:AddInput({
	Name = "Nickname",
	Flag = "Nickname",
	Placeholder = "Type here...",
	MaxLength = 20,
	Callback = function(v) print("Nickname:", v) end,
})

Inputs:AddInput({
	Name = "Live Search",
	Flag = "Search",
	Placeholder = "Updates as you type",
	Finished = false,
	Callback = function(v) print("Search:", v) end,
})

Inputs:AddTextbox({
	Name = "Walk Speed",
	Flag = "WalkSpeed",
	Numeric = true, Min = 0, Max = 500, Default = 16,
	Callback = function(v) print("WalkSpeed:", v) end,
})

Inputs:AddDivider("Keybinds")

-- Keybinds: click the key to rebind (supports Ctrl/Shift/Alt combos, Esc cancels,
-- Backspace clears), click the small "toggle"/"hold" chip to switch mode, right-click the key
-- for a menu (mode, change, clear, reset). On phones, tap the key to use the bind.
Inputs:AddKeybind({
	Name = "Fly (toggle)",
	Flag = "FlyKey",
	Default = Enum.KeyCode.F,
	Mode = "Toggle",
	Callback = function(active) print("Fly:", active) end,
})

Inputs:AddKeybind({
	Name = "Zoom (hold)",
	Flag = "ZoomKey",
	Default = Enum.UserInputType.MouseButton2,
	Mode = "Hold",
	Callback = function(held) print("Zoom held:", held) end,
})

Inputs:AddKeybind({
	Name = "Teleport (combo)",
	Flag = "TeleportKey",
	Default = "Ctrl+T",          -- also accepts {Key = "T", Mods = {"Ctrl"}}
	Mode = "Press",
	NoDuplicates = true,          -- refuse keys already used by another keybind
	Blacklist = {"W", "A", "S", "D", "Space"},
	Callback = function() print("Teleport!") end,
})

Inputs:AddKeybind({
	Name = "Hidden from list",
	Flag = "SecretKey",
	Default = Enum.KeyCode.K,
	ShowInList = false,
})

Inputs:AddKeybind({
	Name = "Panic (press)",
	Flag = "PanicKey",
	Default = "P",
	Mode = "Press",
	Callback = function() Window:Hide() end,
	ChangedCallback = function(key, mods) print("Panic key is now", key and key.Name or "None") end,
})

local Colors = Misc:AddSection({Name = "Colors", Side = "Right"})

Colors:AddColorPicker({
	Name = "Highlight",
	Flag = "Highlight",
	Default = Color3.fromRGB(104, 122, 232),
	Callback = function(color, alpha) print("Highlight:", color, alpha) end,
})

Colors:AddColorPicker({
	Name = "Gradient",
	Flag = "Gradient",
	Default = {"#FF5959", "#FFC659", "#59FF8A"}, -- up to 4 colors, hex or Color3
	Alpha = {1, 0.8, 0.5},
	Callback = function(colors, alphas) print("Gradient colors:", #colors) end,
})

Colors:AddColorPicker({
	Name = "Glass (transparent)",
	Flag = "Glass",
	Default = Color3.new(1, 1, 1),
	Alpha = 0,
})

Colors:AddButton({
	Name = "Randomize Highlight",
	Callback = function()
		Library.Options.Highlight:Set(Color3.fromHSV(math.random(), 0.7, 1), 1)
	end,
})

------------------------------------------------------------------------
-- Tab 3: segmented, range slider, stepper, progress bar
------------------------------------------------------------------------
local Extra = Window:AddTab({Name = "Extra", Icon = "layers"})

local Choices = Extra:AddSection({Name = "Choices", Side = "Left"})

Choices:AddSegmented({
	Name = "Quality",
	Flag = "Quality",
	Options = {"Low", "Medium", "High"},
	Default = "Medium",
	Callback = function(v) print("Quality:", v) end,
})

Choices:AddSegmented({
	Flag = "Side",
	Options = {"Left", "Right"},
	Default = "Left",
})

local Numbers = Extra:AddSection({Name = "Numbers", Side = "Right"})

Numbers:AddRangeSlider({
	Name = "FOV Range",
	Flag = "FovRange",
	Min = 30, Max = 120, Default = {60, 90}, Step = 1,
	Suffix = "°",
	Callback = function(v) print("FOV range:", v[1], v[2]) end,
})

Numbers:AddStepper({
	Name = "Amount",
	Flag = "Amount",
	Min = 1, Max = 99, Default = 5, Step = 1,
	Callback = function(v) print("Amount:", v) end,
})

Numbers:AddStepper({
	Name = "Delay",
	Flag = "Delay",
	Min = 0, Max = 5, Default = 0.5, Step = 0.1,
	Suffix = "s",
})

local Progress = Numbers:AddProgressBar({Name = "Task Progress", Max = 100, Default = 0})
local Xp = Numbers:AddProgressBar({Name = "XP", Max = 1500, Default = 900, ShowValue = true})

Numbers:AddButton({
	Name = "Run Task",
	Callback = function()
		Progress:Set(0, true)
		task.spawn(function()
			for i = 1, 10 do
				task.wait(0.15)
				Progress:Set(i * 10)
			end
			Xp:Increment(100)
			Notify("Task finished")
		end)
		return "Running..."
	end,
})

------------------------------------------------------------------------
-- Tab 4: sub-tabs, text and card buttons
------------------------------------------------------------------------
local Info = Window:AddTab({Name = "Info", Icon = "info"})
local About = Info:AddSubTab({Name = "About", Icon = "book-open"})
local Actions = Info:AddSubTab({Name = "Actions", Icon = "zap"})

local Text = About:AddSection({Name = "Text", Side = "Left"})
Text:AddLabel("A plain label. Labels wrap automatically when the text is long.")
Text:AddLabel({Text = "Colored, centered label", Color = Color3.fromRGB(88, 200, 120), Center = true})
Text:AddDivider()
Text:AddParagraph({
	Title = "Paragraph",
	Content = "Paragraphs have a title and a body. Use them for instructions, changelogs or credits.",
})
local Status = Text:AddParagraph({Title = "Status", Content = "Waiting..."})

local Cards = Actions:AddSection({Name = "Card Buttons", Side = "Left"})
Cards:AddCardButton({
	Name = "Rejoin",
	Description = "Reconnect to this server",
	Icon = "refresh-cw",
	ButtonText = "Rejoin",
	Callback = function()
		Status:SetContent("Rejoin clicked at " .. os.date("%X"))
		return "Done"
	end,
})
Cards:AddButton({
	Name = "Copy Job ID",
	Description = "Copies the server id",
	Icon = "copy",
	ButtonText = "Copy",
	Callback = function()
		if setclipboard then setclipboard(game.JobId) end
		return "Copied"
	end,
})

local Window2 = Actions:AddSection({Name = "Window", Side = "Right"})
Window2:AddButton({Name = "Send Notification", Callback = function() Notify("Hello from the demo!") end})
Window2:AddButton({Name = "Light Theme", Callback = function() Window:SetTheme("Light") end})
Window2:AddButton({Name = "Dark Theme", Callback = function() Window:SetTheme("Dark") end})
Window2:AddButton({Name = "Random Accent", Callback = function()
	Window:SetAccent(Color3.fromHSV(math.random(), 0.65, 1), 1)
end})
Window2:AddButton({Name = "Hide for 2s (animated)", Callback = function()
	Window:Hide()
	task.delay(2, function() Window:Show() end)
end})
Window2:AddButton({Name = "Key Info", Callback = function()
	local info = Window:GetKeyInfo()
	if not info then return "No key system" end
	Notify(info.Remaining and ("Key expires in " .. Library.FormatDuration(info.Remaining)) or "Lifetime key")
end})
Window2:AddButton({Name = "Expire Key Now", Callback = function() Window:ExpireKey("Key expired (demo)") end})
Window2:AddButton({Name = "Unload", Callback = function() Library:Unload() end})

-- On-screen keyboard API (phones/tablets). Everything here also works through
-- CreateWindow({Keyboard = {...}}).
local KB = Actions:AddSection({Name = "Keyboard", Side = "Right"})
KB:AddToggle({Name = "Compact Keyboard", Default = false, Callback = function(v) Library.Keyboard:SetCompact(v) end})
KB:AddDropdown({
	Name = "Layout", Options = Library.Keyboard:GetLayouts(), Default = "Default",
	Callback = function(name) Library.Keyboard:SetLayout(name) end,
})
KB:AddSlider({Name = "Keyboard Scale", Min = 0.6, Max = 1.6, Default = 1, Step = 0.05, Callback = function(v) Library.Keyboard:SetScale(v) end})
KB:AddButton({Name = "Dock Top / Bottom", Callback = function()
	local cfg = Library.Keyboard:Get()
	Library.Keyboard:SetDock(cfg.Dock == "Top" and "Bottom" or "Top")
end})
-- Custom layout with a custom action key and a text key.
Library.Keyboard:AddAction("clear-all", function(kb) kb:Clear() end)
Library.Keyboard:AddLayout("Email", {
	Width = 0.8,
	Rows = {
		Library.Keyboard:Keys("qwertyuiop"),
		{{gap = 0.5}, "a", "s", "d", "f", "g", "h", "j", "k", "l", {gap = 0.5}},
		{{act = "shift", w = 1.5}, "z", "x", "c", "v", "b", "n", "m", {act = "back", w = 1.5}},
		{{act = "layout", to = "Numeric", w = 1.5, label = "123"}, {text = "@"}, {text = "@gmail.com", w = 2.5}, {act = "space", w = 2.5}, {text = "."}, {act = "custom", id = "clear-all", label = "Clear", w = 1.5}, {act = "enter", w = 1.5}},
	},
})
-- Hooks: return false from OnKey to swallow a key. Each hook returns a function that removes it.
Library.Keyboard:OnKey(function(spec) if spec.act == "enter" then print("Enter pressed on the on-screen keyboard") end end)
Library.Keyboard:OnChange(function(text) Status:SetContent("Typing: " .. text) end)
-- Per input: Keyboard = false keeps the device keyboard, KeyboardLayout picks the starting layout.
Inputs:AddInput({Name = "Email", Placeholder = "name@mail.com", KeyboardLayout = "Email", Callback = function(v) print("Email:", v) end})

------------------------------------------------------------------------
-- Extras: settings page section, header button, custom theme
------------------------------------------------------------------------
Library:AddTheme("Midnight", {
	WindowBg = Color3.fromRGB(10, 12, 20),
	BarBg = Color3.fromRGB(14, 16, 26),
	CardBg = Color3.fromRGB(14, 16, 26),
	DropdownBg = Color3.fromRGB(20, 22, 34),
})

local Extra = Window:AddSettingsSection({Name = "Demo", Side = "Right"})
Extra:AddToggle({
	Name = "Show Watermark",
	Default = true,
	Callback = function(v) Window.Watermark:SetVisible(v) end,
})

Window:AddHeaderButton({
	Icon = "bell",
	Callback = function() Notify("Header button clicked") end,
})

Window:OnUnload(function() print("Zenin Demo unloaded") end)

-- Anything given to the window is cleaned up on Unload, or automatically when the script is re-run.
Window:GiveTask(game:GetService("Players").PlayerAdded:Connect(function(plr)
	Notify(plr.Name .. " joined")
end))
-- Standalone maids for your own systems: Library.Maid.new(), :Give(), :Connect(), :Spawn(), :Delay(), :Child(), :Clean()

Notify("Loaded! Press RightShift to toggle the menu.")
