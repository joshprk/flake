{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.user.firefox;
in {
  options.user.firefox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the Firefox home module.";
      default = nixosConfig.modules.home.interactive;
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = "The Firefox module to use.";
      default = pkgs.firefox;
    };
  };

  config = lib.mkIf cfg.enable {
    # clean this up later
    programs.firefox = {
      inherit (cfg) enable package;
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
          "*" = {
            installation_mode = "blocked";
          };
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
        };
        Preferences = let
          lock-false = {
            Value = false;
            Status = "locked";
          };

          lock-true = {
            Value = true;
            Status = "locked";
          };
        in {
          "browser.contentblocking.category" = {
            Value = "strict";
            Status = "locked";
          };
          "browser.topsites.contile.enabled" = lock-false;
          "browser.toolbars.bookmarks.visibility" = {
            Value = "never";
            Status = "locked";
          };
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
          "browser.tabs.closeWindowWithLastTab" = lock-false;
          "browser.ml.chat.provider" = {
            Value = "https://chatgpt.com";
            Status = "locked";
          };
          "browser.ml.chat.shortcuts" = lock-false;
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
          "extensions.formautofill.addresses.enabled" = lock-false;
          "extensions.formautofill.creditCards.enabled" = lock-false;
          "signon.rememberSignons" = lock-false;
          "sidebar.verticalTabs" = lock-true;
        };
      };
    };
  };
}
