{
  config,
  lib,
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
}
