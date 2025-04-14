{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: {
  home.username = "joshua";
  home.stateVersion = "25.05";

  /* temporary configuration until modules */
  programs.firefox = {
    enable = true;
    languagePacks = ["en-US"];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      ExtensionSettings = {
        "*".installation_mode = "blocked";
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  programs.ghostty = {
    enable = true;
  };

  programs.git = {
    enable = true;
  };

  programs.niri = {
    inherit (osConfig.programs.niri) package;
    settings.binds = {
      "Mod+Q".action.spawn = "ghostty";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";

    initExtra = ''
      autoload -U colors && colors
      export PS1="%B%{$fg[green]%}[%n@%m:%~]$%b%{$reset_color%} "

      if [[ $1 == eval ]]
      then
        "$@"
        set --
      fi

      nix-init() {
        if [ ! -e flake.nix ]; then
          nix flake new .
          $EDITOR flake.nix
        fi
        if [ ! -e .envrc ]; then
          echo "use flake" > .envrc
        fi
        direnv allow
        direnv reload
      }
    '';

    completionInit = ''
      autoload -U compinit
      [ -d ${config.xdg.cacheHome}/zsh ] || mkdir -p ${config.xdg.cacheHome}/zsh
      zstyle ':completion:*' cache-path ${config.xdg.cacheHome}/zsh/zcompcache
      compinit -d ${config.xdg.cacheHome}/zsh/zcompdump
    '';

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };
}
