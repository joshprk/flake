{
  config,
  lib,
  pkgs,
  ...
}: {
  home.username = "joshua";
  home.stateVersion = "25.05";

  settings.niri = {
    enable = true;
    binds = {
      "Mod+Q".action.spawn = "ghostty";
      "Mod+W".action.spawn = "firefox";
    };
  };

  settings.nvim.enable = true;
  settings.firefox.enable = true;

  /* temporary configuration until modules */

  programs.ghostty = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userEmail = "joshuprk@gmail.com";
    userName = "Joshua Park";
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
