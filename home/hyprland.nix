{
  config,
  lib,
  pkgs,
  ...
}: {
  xdg.config.files."hypr/hyprland.conf".text = ''
    source = ~/.config/hypr/hyprland-binds.conf

    exec-once = vicinae server

    general {
      gaps_in = 5
      gaps_out = 20
      border_size = 1
      col.active_border = rgba(ffffffaa) rgba(595959aa) 45deg
      col.inactive_border = rgba(595959aa)
      resize_on_border = false
      layout = dwindle
    }

    # https://wiki.hypr.land/Configuring/Variables/#decoration
    decoration {
      rounding = 6
      rounding_power = 2

        # Change transparency of focused and unfocused windows
        active_opacity = 0.92
        inactive_opacity = 0.92

        shadow {
            enabled = true
            range = 4
            render_power = 3
            color = rgba(1a1a1aee)
        }

        blur {
            enabled = true
            size = 3
            passes = 1
            vibrancy = 0.1696
        }
    }

    animations {
      enabled = yes

      #        NAME,           X0,   Y0,   X1,   Y1
      bezier = easeOutQuint,   0.23, 1,    0.32, 1
      bezier = easeInOutCubic, 0.65, 0.05, 0.36, 1
      bezier = linear,         0,    0,    1,    1
      bezier = almostLinear,   0.5,  0.5,  0.75, 1
      bezier = quick,          0.15, 0,    0.1,  1

      #           NAME,          ONOFF, SPEED, CURVE,        [STYLE]
      animation = global,        1,     10,    default
      animation = border,        1,     5.39,  easeOutQuint
      animation = windows,       1,     4.79,  easeOutQuint
      animation = windowsIn,     1,     4.1,   easeOutQuint, popin 87%
      animation = windowsOut,    1,     1.49,  linear,       popin 87%
      animation = fadeIn,        1,     1.73,  almostLinear
      animation = fadeOut,       1,     1.46,  almostLinear
      animation = fade,          1,     3.03,  quick
      animation = layers,        1,     3.81,  easeOutQuint
      animation = layersIn,      1,     4,     easeOutQuint, fade
      animation = layersOut,     1,     1.5,   linear,       fade
      animation = fadeLayersIn,  1,     1.79,  almostLinear
      animation = fadeLayersOut, 1,     1.39,  almostLinear
      animation = workspaces,    1,     1.94,  almostLinear, fade
      animation = workspacesIn,  1,     1.21,  almostLinear, fade
      animation = workspacesOut, 1,     1.94,  almostLinear, fade
      animation = zoomFactor,    1,     7,     quick
    }

    dwindle {
        pseudotile = true
        preserve_split = true
    }

    master {
        new_status = master
    }

    misc {
        force_default_wallpaper = 0
        disable_hyprland_logo = true
    }

    input {
        kb_layout = us
        follow_mouse = 1
        touchpad {
            natural_scroll = true
        }
    }

    # Ignore maximize requests from apps. You'll probably like this.
    windowrule = suppressevent maximize, class:.*

    # Fix some dragging issues with XWayland
    windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
  '';

  xdg.config.files."hypr/hyprland-binds.conf".text = ''
    $terminal = ghostty
    $fileManager = nautilus
    $menu = vicinae toggle

    $mainMod = SUPER

    gesture = 3, horizontal, workspace

    # User binds
    bind = $mainMod, Q, exec, $terminal
    bind = $mainMod, W, killactive,
    bind = $mainMod SHIFT, E, exit,
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, TAB, exec, $menu
    bind = $mainMod, P, pseudo,
    bind = $mainMod, T, togglesplit,
    bind = $mainMod, F, fullscreen,

    # Move focus with mainMod + directional keys
    bind = $mainMod, h, movefocus, l
    bind = $mainMod, l, movefocus, r
    bind = $mainMod, k, movefocus, u
    bind = $mainMod, j, movefocus, d

    # Move window with mainMod SHIFT + directional keys
    bind = $mainMod SHIFT, h, movewindow, l
    bind = $mainMod SHIFT, l, movewindow, r
    bind = $mainMod SHIFT, k, movewindow, u
    bind = $mainMod SHIFT, j, movewindow, d

    # Switch workspaces
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to specified workspace
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Scratchpad workspace
    bind = $mainMod, S, togglespecialworkspace, magic
    bind = $mainMod SHIFT, S, movetoworkspace, special:magic

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
  '';
}
