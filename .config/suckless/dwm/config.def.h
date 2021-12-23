/* Appearance  */


static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int gappx     = 5;        /* gap pixel between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;     /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "monospace:size=11" };
static const char dmenufont[]       = "monospace:size=11";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#1793d1";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

/* ScratchPad */


typedef struct {
	const char *name;
	const void *cmd;
} Sp;
const char *spcmd1[] = {"st", "-n", "spterm", "-g", "120x34", NULL };
const char *spcmd2[] = {"st", "-n", "spfm",   "-g", "150x40", "vifm", NULL };
const char *spcmd3[] = {"st", "-n", "spdm",   "-g", "144x41", "/home/user/.config/rtorrent/start", NULL };
const char *spcmd4[] = {"st", "-n", "spam",   "-g", "120x34", "pulsemixer", NULL };
const char *spcmd5[] = {"st", "-n", "spmp",   "-g", "144x41", "mocp", "--config", "/home/user/.config/moc/config", NULL };
static Sp scratchpads[] = {
	/* name          cmd  */
	{"term",       spcmd1},
	{"file",       spcmd2},
	{"download",   spcmd3},
	{"audio",      spcmd4},
	{"music",      spcmd5},
};

/* Tagging */


static const char *tags[] = { "1", "2", "3", "4" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class          instance     title       tags mask     isfloating   monitor */
	{ "Firefox",      NULL,        NULL,       1 << 8,       0,           -1 },
	{ "qutebrowser",  NULL,        NULL,       1 << 1,       0,           -1 },
	{ "brave",        NULL,        NULL,       1 << 1,       0,           -1 },
	{ "Gimp",         NULL,        NULL,       0,            1,           -1 },
	{ "Krita",        NULL,        NULL,       0,            1,           -1 },
	{ NULL,	          "spterm",    NULL,       SPTAG(0),     1,	      -1 },
	{ NULL,	          "spfm",      NULL,       SPTAG(1),     1,	      -1 },
	{ NULL,	          "spdm",      NULL,       SPTAG(2),     1,	      -1 },
	{ NULL,	          "spam",      NULL,       SPTAG(3),     1,	      -1 },
	{ NULL,	          "spmp",      NULL,       SPTAG(4),     1,	      -1 },
};

/* Layouts */


static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle },
	{ "><>",      NULL },    /* no layout function means floating behavior */
};

/* Commands */
  

#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|Mod1Mask,              KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {
  "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL
};
static const char *launchercmd[]  = {
  "rofi", "-show", "drun", "-theme", "onedark", NULL
};
static const char *termcmd[]  = {
  "st", NULL
};
static const char *browsercmd[] = {
  "brave", NULL
};
static const char *idlecmd[] = {
  "emacsclient", "--alternate-editor=""", "--create-frame", NULL
};
static const char *vaultcmd[] = {
  "rofi-rbw", NULL
};
static const char *screenshotcmd[] = {
  "scrot", "--exec", "mv $f /media/files/Ricardo/Pictures/Screenshots", "%Y-%m-%d_%H:%M:%S_scrot.png", NULL
};
static const char *capturecmd[] = {
  "scrot", "--select", "--line", "style=dash,width=2,color=#1793d1,opacity=80", "--freeze", "--exec", "mv $f /media/files/Ricardo/Pictures/Screenshots", "%Y-%m-%d_%H:%M:%S_scrot.png", NULL
};

/* killing an aplication with hotkeys

#!/bin/bash
windowFocus=$(xdotool getwindowfocus);
pid=$(xprop -id $windowFocus | grep PID);
kill -9 $pid*/

/* Key Definitions */
  

static Key keys[] = {
	/* modifier                     key        function        argument */
	/* spawn */
	{ MODKEY,                       XK_r,      spawn,          {.v = launchercmd } },
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      spawn,          {.v = browsercmd } },
	{ MODKEY,                       XK_i,      spawn,          {.v = idlecmd } },
	{ MODKEY,                       XK_p,      spawn,          {.v = vaultcmd } },
	{ MODKEY,                       XK_c,      spawn,          {.v = screenshotcmd } },
	{ MODKEY|ControlMask,           XK_c,      spawn,          {.v = capturecmd } },
	{ MODKEY,            		XK_x,	   togglescratch,  {.ui = 0 } },
	{ MODKEY,            		XK_e,	   togglescratch,  {.ui = 1 } },
	{ MODKEY,            		XK_d,	   togglescratch,  {.ui = 2 } },
	{ MODKEY,            		XK_a,	   togglescratch,  {.ui = 3 } },
	{ MODKEY,            		XK_m,	   togglescratch,  {.ui = 4 } },
	/* layout */
	/*{ MODKEY,                       XK_space,  togglefloating, {0} },*/
	{ MODKEY|Mod1Mask,              XK_comma,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY|Mod1Mask,              XK_period,     setlayout,      {.v = &layouts[1]} },
	{ MODKEY|Mod1Mask,              XK_space,      setlayout,      {.v = &layouts[2]} },
	/* client */
	{ MODKEY,                       XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|Mod1Mask,              -1,        incnmaster,     {.i = +1 } },
	{ MODKEY|Mod1Mask,              -1,        incnmaster,     {.i = -1 } },
	{ MODKEY,                       -1,        zoom,           {0} },
	{ MODKEY,                       -1,        focusmon,       {.i = +1 } },
	{ MODKEY,                       -1,        focusmon,       {.i = -1 } },
	/* tags */
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,                       -1,        view,           {.ui = ~0 } },
	{ MODKEY,                       -1,        tag,            {.ui = ~0 } },
	{ MODKEY|Mod1Mask,              -1,        tagmon,         {.i = +1 } },
	{ MODKEY|Mod1Mask,              -1,        tagmon,         {.i = -1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	/* system */
	{ MODKEY|Mod1Mask,              -1,        togglebar,      {0} },
	{ MODKEY|Mod1Mask,              XK_q,      quit,           {0} },
};

/* Button Definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin *\/ */


static Button buttons[] = {
	/* click              event mask            button        function             argument */
	{ ClkLtSymbol,        0,                    Button1,      setlayout,           {0} },
	{ ClkLtSymbol,        0,                    Button3,      setlayout,           {.v = &layouts[2]} },
	{ ClkWinTitle,        0,                    Button1,      focusstack,          {.i = +1 } },
	{ ClkWinTitle,        0,                    Button3,      focusstack,          {.i = -1 } },
	{ ClkWinTitle,        0,                    Button2,      zoom,                {0} },
	{ ClkStatusText,      0,                    Button2,      spawn,               {.v = termcmd } },
	{ ClkClientWin,       MODKEY|Mod1Mask,      Button1,      movemouse,           {0} },
	{ ClkClientWin,       MODKEY|Mod1Mask,      Button3,      resizemouse,         {0} },
	{ ClkClientWin,       MODKEY,               Button2,      togglefloating,      {0} },
	{ ClkClientWin,       MODKEY,               Button1,      focusstack,          {.i = +1 } },
	{ ClkClientWin,       MODKEY,               Button3,      focusstack,          {.i = -1 } },
	{ ClkRootWin,         MODKEY,               Button1,      zoom,                {0} },
	{ ClkTagBar,          0,                    Button1,      view,                {0} },
	{ ClkTagBar,          0,                    Button3,      toggleview,          {0} },
	{ ClkTagBar,          MODKEY,               Button1,      tag,                 {0} },
	{ ClkTagBar,          MODKEY,               Button3,      toggletag,           {0} },
};
