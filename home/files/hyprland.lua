local TERMINAL <const> = "ghostty"

local mod = function(key)
  return "SUPER + " .. key
end

local noctalia = function(cmd)
  return hl.dsp.exec_cmd("noctalia msg " .. cmd)
end

local BINDS <const> = {
  { mod("RETURN"), hl.dsp.exec_cmd(TERMINAL) },

  { mod("Comma"), noctalia("settings-toggle") },
  { mod("Space"), noctalia("panel-toggle launcher") },
  { mod("S"), noctalia("panel-toggle control-center") },
  { mod("Tab"), noctalia("window-switcher") },
  { mod("CTRL + Q"), noctalia("session lock") },
  { mod("SHIFT + Q"), noctalia("panel-toggle session") },

  { mod("F"), hl.dsp.window.fullscreen() },
  { mod("Q"), hl.dsp.window.close() },
  { mod("V"), hl.dsp.window.float({ action = "toggle" }) },
  { mod("P"), hl.dsp.window.pseudo() },
  { mod("T"), hl.dsp.layout("togglesplit") },

  { mod("mouse:272"), hl.dsp.window.drag(), { mouse = true } },
  { mod("mouse:273"), hl.dsp.window.resize(), { mouse = true } },

  { "XF86AudioRaiseVolume", noctalia("volume-up"), { locked = true } },
  { "XF86AudioLowerVolume", noctalia("volume-down"), { locked = true } },
  { "XF86AudioMute", noctalia("volume-mute"), { locked = true } },
  { "XF86AudioMicMute", noctalia("mic-mute"), { locked = true } },
  { "XF86AudioPlay", noctalia("media toggle"), { locked = true } },
  { "XF86AudioPause", noctalia("media pause"), { locked = true } },
  { "XF86AudioStop", noctalia("media stop"), { locked = true } },
  { "XF86AudioPrev", noctalia("media previous"), { locked = true } },
  { "XF86AudioNext", noctalia("media next"), { locked = true } },
  { "XF86MonBrightnessUp", noctalia("brightness-up"), { locked = true } },
  { "XF86MonBrightnessDown", noctalia("brightness-down"), { locked = true } },
}

local M <const> = {}

function M.monitors()
  hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
  })
end

function M.hl_binds()
  local VIM_DIRECTIONS <const> = {
    l = { "left", "H" },
    d = { "down", "J" },
    u = { "up", "K" },
    r = { "right", "L" },
  }

  for direction, keys in pairs(VIM_DIRECTIONS) do
    for _, key in ipairs(keys) do
      hl.bind(mod(key), hl.dsp.focus({ direction = direction }))
      hl.bind(mod("CTRL + " .. key), hl.dsp.window.move({ direction = direction }))
      hl.bind(mod("SHIFT + " .. key), hl.dsp.focus({ monitor = direction }))
      hl.bind(mod("CTRL + SHIFT + " .. key), hl.dsp.window.move({ monitor = direction }))
    end
  end

  for workspace = 1, 9 do
    hl.bind(mod(workspace), hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod("CTRL + " .. workspace), hl.dsp.window.move({ workspace = workspace }))
  end
end

function M.binds()
  for _, binding in ipairs(BINDS) do
    hl.bind(binding[1], binding[2], binding[3])
  end
end

function M.hl_config()
  hl.config({
    general = {
      gaps_in = 12,
      gaps_out = 20,
      border_size = 0,
      layout = "dwindle",
      no_focus_fallback = true,
    },
    dwindle = {
      preserve_split = true,
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
end

function M.fixes()
  hl.window_rule({
    name = "zen-unmaximized",
    match = { class = "app.zen_browser.zen" },
    fullscreen_state = "0 0",
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
end

function M:setup()
  self.monitors()
  self.hl_binds()
  self.binds()
  self.hl_config()
  self.fixes()
end

M:setup()
