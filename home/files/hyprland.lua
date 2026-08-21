local MAIN_MOD <const> = "SUPER"
local NOCTALIA <const> = "noctalia"
local TERMINAL <const> = "ghostty"

local VIM_DIRECTIONS <const> = {
  { "left", "l" },
  { "down", "d" },
  { "up", "u" },
  { "right", "r" },
  { "H", "l" },
  { "J", "d" },
  { "K", "u" },
  { "L", "r" },
}

local NOCTALIA_BINDS <const> = {
  XF86AudioRaiseVolume = "volume-up",
  XF86AudioLowerVolume = "volume-down",
  XF86AudioMute = "volume-mute",
  XF86AudioMicMute = "mic-mute",
  XF86AudioPlay = "media toggle",
  XF86AudioPause = "media pause",
  XF86AudioStop = "media stop",
  XF86AudioPrev = "media previous",
  XF86AudioNext = "media next",
  XF86MonBrightnessUp = "brightness-up",
  XF86MonBrightnessDown = "brightness-down",
}

local function noctalia_ipc(command)
  return hl.dsp.exec_cmd(NOCTALIA .. " msg " .. command)
end

local function mod(key)
  return MAIN_MOD .. " + " .. key
end

local function register_binds()
  hl.bind(mod("RETURN"), hl.dsp.exec_cmd(TERMINAL))

  hl.bind(mod("Comma"), noctalia_ipc("settings-toggle"))
  hl.bind(mod("Space"), noctalia_ipc("panel-toggle launcher"))
  hl.bind(mod("S"), noctalia_ipc("panel-toggle control-center"))
  hl.bind(mod("Tab"), noctalia_ipc("window-switcher"))
  hl.bind(mod("CTRL + Q"), noctalia_ipc("session lock"))
  hl.bind(mod("SHIFT + Q"), noctalia_ipc("panel-toggle session"))

  hl.bind(mod("F"), hl.dsp.window.fullscreen())
  hl.bind(mod("Q"), hl.dsp.window.close())

  hl.bind(mod("V"), hl.dsp.window.float({ action = "toggle" }))
  hl.bind(mod("P"), hl.dsp.window.pseudo())

  hl.bind(mod("mouse:272"), hl.dsp.window.drag(), { mouse = true })
  hl.bind(mod("mouse:273"), hl.dsp.window.resize(), { mouse = true })

  for key, command in pairs(NOCTALIA_BINDS) do
    hl.bind(key, noctalia_ipc(command), { locked = true })
  end

  for _, binding in ipairs(VIM_DIRECTIONS) do
    local key, direction = table.unpack(binding)
    hl.bind(mod(key), hl.dsp.focus({ direction = direction }))
    hl.bind(mod("CTRL + " .. key), hl.dsp.window.move({ direction = direction }))
    hl.bind(mod("SHIFT + " .. key), hl.dsp.focus({ monitor = direction }))
    hl.bind(mod("CTRL + SHIFT + " .. key), hl.dsp.window.move({ monitor = direction }))
  end

  for workspace = 1, 9 do
    hl.bind(mod(workspace), hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod("CTRL + " .. workspace), hl.dsp.window.move({ workspace = workspace }))
  end

  hl.bind(mod("D"), hl.dsp.workspace.toggle_special("scratchpad"))
  hl.bind(mod("CTRL + D"), hl.dsp.window.move({ workspace = "special:scratchpad" }))
end

local function register_animations()
  hl.curve("water", { type = "bezier", points = { {0.22, 0.9}, {0.36, 1.0} } })
  hl.curve("flow", { type = "bezier", points = { {0.25, 0.1}, {0.25, 1.0} } })
  hl.curve("ripple", { type = "bezier", points = { {0.33, 0.0}, {0.2, 1.0} } })
  hl.curve("stream", { type = "bezier", points = { {0.4, 0.0}, {0.4, 1.0} } })
  hl.curve("cascade", { type = "bezier", points = { {0.19, 1.0}, {0.22, 1.0} } })
  hl.curve("md3_standard", { type = "bezier", points = { {0.2, 0.0}, {0.0, 1.0} } })
  hl.curve("md3_accel", { type = "bezier", points = { {0.3, 0.0}, {0.8, 0.15} } })
  hl.curve("overshot", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

  hl.animation({ leaf = "windows", enabled = true, speed = 3.0, bezier = "water" })
  hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.5, bezier = "cascade", style = "slide" })
  hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.4, bezier = "stream", style = "slide" })
  hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.6, bezier = "flow" })
  hl.animation({ leaf = "fade", enabled = true, speed = 2.4, bezier = "water" })
  hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.0, bezier = "cascade" })
  hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.8, bezier = "ripple" })
  hl.animation({ leaf = "fadeDim", enabled = true, speed = 2.0, bezier = "water" })
  hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 1.4, bezier = "flow" })
  hl.animation({ leaf = "layersIn", enabled = true, speed = 1.5, bezier = "overshot", style = "popin 80%" })
  hl.animation({ leaf = "layersOut", enabled = true, speed = 1.3, bezier = "md3_accel", style = "popin 90%" })
  hl.animation({ leaf = "layers", enabled = true, speed = 1.5, bezier = "md3_standard" })
  hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "flow", style = "slidevert" })
  hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2.5, bezier = "water", style = "slidevert" })
  hl.animation({ leaf = "border", enabled = true, speed = 2.9, bezier = "water" })
  hl.animation({ leaf = "borderangle", enabled = true, speed = 3.5, bezier = "flow" })
end

local function configure()
  hl.config({
    general = {
      gaps_in = 12,
      gaps_out = 20,
      border_size = 0,
      layout = "dwindle",
    },
    decoration = {
      rounding = 12,
      active_opacity = 0.95,
      inactive_opacity = 0.95,
      shadow = {
        enabled = true,
        range = 30,
        color = "rgba(00000077)",
        offset = { 0, 5 },
      },
    },
    input = {
      follow_mouse = 1,
      touchpad = {
        natural_scroll = true,
      },
    },
    misc = {
      disable_hyprland_logo = true,
      force_default_wallpaper = 0,
    },
    ecosystem = {
      no_update_news = true,
      no_donation_nag = true,
    },
  })

  hl.layer_rule({
    name = "xray-all-layers",
    match = { namespace = ".*" },
    xray = true,
  })

  hl.window_rule({
    name = "picture-in-picture",
    match = { class = "app.zen_browser.zen", title = "^Picture-in-Picture$" },
    float = true,
    move = { "monitor_w-window_w-20", "monitor_h-window_h-20" },
  })

  hl.window_rule({
    name = "noctalia",
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
  })

  register_animations()
  register_binds()
end

configure()
