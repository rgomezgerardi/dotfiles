-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Default modkey.
modkey = "Mod4"

-- Default Programs
Terminal = "termite"
Browser = "firefox"
FileManager = Terminal .. " -e " .. "vifm"
Launcher = "rofi -show drun"
DownloadManager = "home/ruth/Scripts/freedownloadmanager.sh"
ScreenCapture = "scrot -e 'mv $f /media/files/Ricardo/Downloads/ 2>/dev/null'"
MenuEmojis = "ibus emoji"

-- ============================
--        Key Bindings
-- ============================
globalkeys = gears.table.join(
    -- Awesome        
    awful.key({ modkey,           }, "F1",      hotkeys_popup.show_help,
              {description = "Show Help", group="Awesome"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "Reload Awesome", group = "Awesome"}),

    awful.key({ modkey, "Control"   }, "q", awesome.quit,
              {description = "Quit Awesome", group = "Awesome"}),


    -- Launcher
    awful.key({ modkey,           }, "x", function () awful.spawn(Terminal) end,
              {description = "Terminal", group = "Launcher"}),

    awful.key({ modkey,           }, "z", function () awful.spawn(Browser) end,
              {description = "Browser", group = "Launcher"}),

    awful.key({ modkey,           }, "c", function () awful.spawn(FileManager) end,
              {description = "File Manager", group = "Launcher"}),

    awful.key({ modkey,           }, "r", function () awful.spawn(Launcher) end,
              {description = "Open Program", group = "Launcher"}),

    awful.key({ modkey,           }, "t", function () awful.spawn(DownloadManager) end,
              {description = "Download Manager", group = "Launcher"}),
    
    awful.key({		           }, "Print", function () awful.spawn(ScreenCapture, false) end,
              {description = "Take a Screenshot", group = "Launcher"}),
	      
    awful.key({ modkey,           }, "e", function () awful.spawn(MenuEmojis) end,
              {description = "Open the Emojis Menu", group = "Launcher"}),
 

    -- Layout
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "Increase Master Width Factor", group = "Layout"}),

    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "Decrease Master Width Factor", group = "Layout"}),

    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),

    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),

    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),

    awful.key({ modkey,           }, "space", function () awful.layout.inc( 2)                end,
              {description = "select next", group = "layout"}),

    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),


     -- Tag
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "View Previous", group = "Tag"}),

    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "View Next", group = "Tag"}),
	      
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "Go Back", group = "Tag"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 3 do
    globalkeys = gears.table.join( globalkeys,
    
        -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, function () local screen = awful.screen.focused() local tag = screen.tags[i] if tag then tag:view_only() end end,
              {description = "View Tag #"..i, group = "Tag"}),

        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9, function () local screen = awful.screen.focused() local tag = screen.tags[i] if tag then awful.tag.viewtoggle(tag) end end,
        	  {description = "Toggle Tag #" .. i, group = "Tag"}),

        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function () if client.focus then local tag = client.focus.screen.tags[i] if tag then client.focus:move_to_tag(tag) end end end,
        	  {description = "Move Focused Client to Tag #"..i, group = "Tag"}),

        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function () if client.focus then local tag = client.focus.screen.tags[i] if tag then client.focus:toggle_tag(tag) end end end,
        	  {description = "Toggle Focused Client on Tag #" .. i, group = "Tag"})
    )
end

clientkeys = gears.table.join(
    -- Client
    awful.key({ modkey,           }, "d", function () awful.client.focus.byidx( 1) end,
	      {description = "Focus Next", group = "Client"}),
    
    awful.key({ modkey,           }, "a", function () awful.client.focus.byidx(-1) end,
              {description = "Focus Previous", group = "Client"}),

    awful.key({ modkey 		  }, "q",      function (c) c:kill()                         end,
	      {description = "Close", group = "Client"}),

    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "Swap with Next Client", group = "Client"}),

    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "Swap with Previous Client", group = "Client"}),

    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "Toggle Floating", group = "Client"}),

    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "Move to Master", group = "Client"}),

    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "Move to Screen", group = "Client"}),

    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "Toggle Keep on Top", group = "Client"}),

    awful.key({ modkey,           }, "s", function (c) c.minimized = true end,
              {description = "Minimize", group = "Client"}),

    awful.key({ modkey,           }, "w", function (c) c.maximized = not c.maximized c:raise() end,
              {description = "Maximize", group = "Client"}),

    awful.key({ modkey, "Control" }, "w", function () local c = awful.client.restore() if c then c:emit_signal( "request::activate", "key.unminimize", {raise = true} ) end end,
              {description = "Restore Minimized", group = "Client"}),

    awful.key({ modkey, "Control" }, "m", function (c) c.maximized_vertical = not c.maximized_vertical c:raise() end ,
              {description = "Maximize Vertically", group = "Client"}),
    
    awful.key({ modkey, "Shift"   }, "m", function (c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end ,
              {description = "Maximize Horizontally", group = "Client"}),

    awful.key({ modkey,           }, "f", function (c) c.fullscreen = not c.fullscreen c:raise() end,
	      {description = "Toggle Fullscreen", group = "Client"}),

    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "Jump to Urgent Client", group = "Client"}),

    awful.key({ modkey,           }, "Tab", function () awful.client.focus.history.previous() if client.focus then client.focus:raise() end end,
              {description = "Go Back", group = "Client"})
)


clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

return globalkeys
