# ================================================================
#
#               ██████╗ ████████╗██╗██╗     ███████╗
#              ██╔═══██╗╚══██╔══╝██║██║     ██╔════╝
#              ██║   ██║   ██║   ██║██║     █████╗  
#              ██║▄▄ ██║   ██║   ██║██║     ██╔══╝  
#              ╚██████╔╝   ██║   ██║███████╗███████╗
#               ╚══▀▀═╝    ╚═╝   ╚═╝╚══════╝╚══════╝
#
#   Config File                         Edited By: Ricardo Gomez
# ================================================================
from typing import List  # noqa: F401
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal                       # Import programs modules
from libqtile import layout                                     # Import layouts modules
from libqtile.config import Group, Match, Rule                  # Import groups modules
from libqtile.config import EzKey as Key, KeyChord              # Import keys modules
from libqtile import extension 
from libqtile.config import EzClick as Click, EzDrag as Drag    # Import mouse modules
from libqtile.config import Screen                              # Import screen modules
from libqtile import bar, widget

# If a window requests to be fullscreen, it is automatically fullscreened
auto_fullscreen = True

# When clicked, should the window be brought to the front or not
bring_front_click = False

# If true, the cursor follows the focus as directed by the keyboard, warping to the center of the focused window
cursor_warp = False

# Behavior of the _NET_ACTIVATE_WINDOW message sent by applications
# urgent: urgent flag is set for the window
# focus: automatically focus the window
# smart: automatically focus if the window is in the current group
# never: never automatically focus any window that requests it
focus_on_window_activation = "smart"

# Controls whether or not focus follows the mouse around as it moves across windows in a layout
follow_mouse_focus = True

# The default floating layout to use. This allows you to set custom floating rules among other things if you wish
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])


# ================================================================
# =========================== Programs ===========================
# ================================================================
# Programs
terminal = "termite -t Termite"
explorer =  terminal + " -e vifm -t Vifm"
browser = "qutebrowser"
downloads = "uget-gtk"
music = "termite -e \"mocp --config /home/user/.config/moc/config\""
#launcher = "rofi -show drun"
#screenshots = "scrot -e 'mv $f /media/files/Ricardo/Downloads/ 2>/dev/null'"
#emojis = "ibus emoji"

# Colors
color1 = '#f0f0f0'
color2 = '#282C33'
color3 = '#2b87dc'
color4 = '#b90d36'
color5 = '#37c8ab'
color6 = '#ffb52a'


# ================================================================
# =========================== Layouts ============================
# ================================================================
layouts = [
    layout.Max(),
    layout.Floating(),
    layout.Columns(
        border_focus=color3, 
        fair=True,
        grow_amount=10,
        insert_position=1,
        margin=5,
        margin_on_single=-1,
        split=True,
        wrap_focus_columns=True,
    ),
    layout.MonadTall(),
    layout.Bsp(ratio=1.2),
    layout.TreeTab(panel_width=80),
]


# ================================================================
# ============================ Groups ============================
# ================================================================
groups = [
    Group("1", label='', spawn=[terminal], layout='columns'), 
    Group("2", label='', layout="max", matches=[Match(wm_class=[browser])]),      # Only the browser will be display
    Group("3", label='', layout='monadtall'),
    Group("4", label='', layout='Bsp')
]

# Alias
group1 = groups[0].name
group2 = groups[1].name
group3 = groups[2].name
group4 = groups[3].name

# Rules for make float windows
#Rule(Match(wm_class=["qutebrowser"]), float=True)


# ================================================================
# ============================= Keys =============================
# ================================================================
keys = [
    # Windows
    Key("M-q",          lazy.window.kill(),             desc="Kill focused window"),
    Key("M-h",          lazy.layout.left(),             desc="Move focus to left"),
    Key("M-a",          lazy.layout.left(),             desc="Move focus to left (Alternative)"),
    Key("M-l",          lazy.layout.right(),            desc="Move focus to right"),
    Key("M-d",          lazy.layout.right(),            desc="Move focus to right (Alternative)"),
    Key("M-j",          lazy.layout.down(),             desc="Move focus down"),
    Key("M-s",          lazy.layout.down(),             desc="Move focus down (Alternative)"),
    Key("M-k",          lazy.layout.up(),               desc="Move focus up"),
    Key("M-w",          lazy.layout.up(),               desc="Move focus up (Alternative)"),

    # Layout (Columns)
    Key("M-A-h",        lazy.layout.shuffle_left(),     desc="Move window to the left"),
    Key("M-A-l",        lazy.layout.shuffle_right(),    desc="Move window to the right"),
    Key("M-A-j",        lazy.layout.shuffle_down(),     desc="Move window down"),
    Key("M-A-k",        lazy.layout.shuffle_up(),       desc="Move window up"),
    Key("M-C-h",        lazy.layout.grow_left(),        desc="Grow window to the left"),
    Key("M-C-l",        lazy.layout.grow_right(),       desc="Grow window to the right"),
    Key("M-C-j",        lazy.layout.grow_down(),        desc="Grow window down"),
    Key("M-C-k",        lazy.layout.grow_up(),          desc="Grow window up"),
    Key("M-n",          lazy.layout.normalize(),        desc="Reset all window sizes"),
    Key("M-A-<Return>", lazy.layout.toggle_split(),     desc="Toggle between split and unsplit sides of stack"),

    # Groups
    Key("M-u",          lazy.group[group1].toscreen(),  desc="Switch to group {}".format(group1)),
    Key("M-i",          lazy.group[group2].toscreen(),  desc="Switch to group {}".format(group2)),
    Key("M-o",          lazy.group[group3].toscreen(),  desc="Switch to group {}".format(group3)),
    Key("M-p",          lazy.group[group4].toscreen(),  desc="Switch to group {}".format(group4)),
    Key("M-A-u",        lazy.window.togroup(group1, switch_group=True), desc="Switch to & move focused window to group {}".format(group1)),
    Key("M-A-i",        lazy.window.togroup(group2, switch_group=True), desc="Switch to & move focused window to group {}".format(group2)),
    Key("M-A-o",        lazy.window.togroup(group3, switch_group=True), desc="Switch to & move focused window to group {}".format(group3)),
    Key("M-A-p",        lazy.window.togroup(group4, switch_group=True), desc="Switch to & move focused window to group {}".format(group4)),

    # Launch Programs
    Key("M-<Return>",   lazy.spawn(terminal),           desc="Launch terminal"),
    Key("M-c",          lazy.spawn(explorer),           desc="Launch file manager"),
    Key("M-x",          lazy.spawn(downloads),          desc="Launch download manager"),
    Key("M-z",          lazy.spawn(browser),            desc="Launch browser"),
    Key("M-m",          lazy.spawn(music),              desc="Launch music player"),
#    Key('M-m', lazy.run_extension(extension.CommandSet(
#        commands={
#            'play/pause': '[ $(mocp -i | wc -l) -lt 2 ] && mocp -p || mocp -G',
#            'next': 'mocp -f',
#            'previous': 'mocp -r',
#            'quit': 'mocp -x',
#            'open': 'urxvt -e mocp',
#            'shuffle': 'mocp -t shuffle',
#            'repeat': 'mocp -t repeat',
#        },
#        pre_commands=['[ $(mocp -i | wc -l) -lt 1 ] && mocp -S'],
#        rofi
#    ))),


    # Toggle between different layouts as defined below
    Key("M-<Tab>",      lazy.next_layout(),             desc="Toggle between layouts"),

    # Globals
    Key("M-C-r",        lazy.restart(),                 desc="Restart qtile"),
    Key("M-C-q",        lazy.shutdown(),                desc="Shutdown qtile"),
    Key("M-r",          lazy.spawncmd(),                desc="Spawn a command using a prompt widget")
]


# ================================================================
# ============================ Mouse =============================
# ================================================================
mouse = [
    Drag("M-1",     lazy.window.set_position_floating(),   start=lazy.window.get_position()),
    Drag("M-3",     lazy.window.set_size_floating(),       start=lazy.window.get_size()),
    Click("M-2",    lazy.window.bring_to_front()),
]


# ================================================================
# =========================== Screens ============================
# ================================================================
widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        # Bar
        top=bar.Bar(
            # Bar General Options
            size=24,
            background=["#282C33"],
            margin=[0,0,0,0],
            opacity=1,
            
            # Widgets
            widgets=[
                widget.WidgetBox(
                    widgets=[
                        widget.TextBox(text="This widget is in the box"),
                        widget.LaunchBar(           # required: pyxdg
                            #progs=('logout', 'qshell:self.qtile.cmd_shutdown()', 'logout from qtile'),
                            #progs=('restart', 'echo shutdown', 'restart the machine'), 
                        ),
                    ],
                    background=color3,
                    text_open='',
                    text_closed='',
                ),
                widget.CurrentLayoutIcon(
                    custom_icon_paths=['~/.config/qtile/icons'],
                    background=color3,
                ),
                widget.GroupBox(
                    active=color1,
                    inactive=color2,
                    background=color3,
                ),
                widget.Prompt(
                    prompt='Search: ',
                    background=color3,
                ),
                widget.Spacer(
                    length=bar.STRETCH,
                    background=color2
                ),
                widget.TaskList(
                    foreground=color1,
                    background=color2,
                    #max_title_width=50,
                ),
                widget.Spacer(
                    length=bar.STRETCH,
                    background=color2
                ),
                widget.CPU(
                    format='{load_percent}%',
                    foreground=color1,
                    background=color4,
                ),
                widget.Memory(
                    format='{MemPercent}%',
                    foreground=color1,
                    background=color4,
                ),
                widget.ThermalSensor(
                    foreground=color1,
                    background=color4,
                ),
                widget.WidgetBox(
                    widgets=[
                        widget.Pomodoro(
                            color_active='00ff00',
                            color_inactive='ff0000',
                            color_break='ffff00',
                            foreground=color1,
                            background=color3,
                            #length_long_break=15,
                            #length_pomodori=25,
                            #length_short_break=5,
                        ),
                    ],
                    background=color3,
                    text_open='',
                    text_closed='',
                ),
                widget.Volume(
                    fmt='奔 {}',
                    foreground=color1,
                    background=color3,
                ),
                #widget.Moc(            # Require moc (http://moc.daper.net)
                #    fmt='moc{}',
                #    max_chars=30,
                #    foreground=color1,
                #    background=color4,
                #),
                widget.Net(
                    format='說{ down}',
                    foreground=color1,
                    background=color3,
                ),
                widget.KeyboardLayout(
                    foreground=color1,
                    background=color3,
                ),
                widget.Clock(
                    format='%Y-%m-%d %a %I:%M %p',
                    background=color3,
                ),
                widget.Notify(
                    foreground=color1,
                    background=color3,
                    audiofile=None,
                ),
                widget.Systray(
                    background=color3,
                    icon_size=20,
                    padding=5,
                ),
                widget.CheckUpdates(
                    background=color3,
                ),
                
            ],
        ),

        wallpaper="/home/user/.config/qtile/wallpaper.png",
        wallpaper_mode='fill'
    ),
]
