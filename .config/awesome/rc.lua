--[[ =============================================================

   █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
  ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
  ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗  
  ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝ 
  ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
  ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

 Config File				 Edited by: Ricardo Gomez
=============================================================== --]]

-- ============================
--          Libraries
-- ============================
-- If LuaRocks is installed, make sure that packages installed through it are found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Set keys
root.keys(require('keys'))


-- ============================
--        Error Handling
-- ============================
-- Check if awesome encountered an error during startup and fell back to another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical, title = "Oops, there were errors during startup!", text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical, title = "Oops, an error happened!", text = tostring(err) })
        in_error = false
    end)
end


-- ============================
--     Variable Definitions
-- ============================
-- Themes
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/default/theme.lua")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

-- ============================
--       Tags & Wallpapers
-- ============================

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)    

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])

end)


-- ============================
--        Mouse Bindings
-- ============================
root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))


-- ============================
--            Rules
-- ============================
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
--		except_any = { class = { "xfce4-panel", } },
		
		properties = {
			screen = awful.screen.preferred,
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen
		},

	},

	-- Floating clients
	{ rule_any = { class = { "Firefox", } }, 
		properties = { floating = true },
	},

	-- Maximized clients
	{ rule_any = { name = { "Vifm", "Moc", "rTorrent" }, class = { "Firefox", "Zathura", } },
		properties = { maximized = true, },	
	},
}


-- ============================
--          Signals
-- ============================
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    
    --c.shape = function(cr,w,h)
    --      gears.shape.rounded_rect(cr,w,h,16)
    --end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- ============================
--          Autostartup
-- ============================
-- Compositor
awful.spawn.with_shell("picom -b")

-- Launch xfce4 Panel
--awful.spawn.with_shell("~/.local/share/xfce4-panel-profiles/launch.sh")

-- Launch Polybar
awful.spawn.with_shell("~/.config/polybar/launch.sh")
