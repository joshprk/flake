{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.user.programs;
in {
  options.user = {
    programs = {
      enable = lib.mkEnableOption "the programs configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprshot
      swappy
      zen-browser
      wl-clipboard-rs
    ];

    programs.btop = {
      enable = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config = {
        global = {
          warn_timeout = "0";
          hide_env_diff = true;
        };
      };
    };

    programs.fzf = {
      enable = true;
    };

    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        window-decoration = false;
        gtk-single-instance = true;
      };
    };

    programs.git = {
      enable = true;
      userEmail = "joshuprk@gmail.com";
      userName = "Joshua Park";
      extraConfig = {
        init.defaultBranch = "main";
        merge.tool = "nvimdiff";
        mergetool.nvimdiff = "LOCAL,BASE,REMOTE / MERGED";
      };
    };

    programs.ripgrep = {
      enable = true;
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

        nix-develop() {
          nix develop $1 -c $SHELL -ais eval "export SHELL=$SHELL"
        }

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
  };
}
