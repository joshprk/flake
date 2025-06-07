{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.user.firefox;
  utils = {
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
    addon = id: {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
      installation_mode = "force_installed";
    };
  };
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

    addons = lib.mkOption {
      type = lib.types.attrs;
      description = "Read-only attrset of Firefox addons.";
      default = with utils; {
        "*" = {installation_mode = "blocked";};
        "uBlock0@raymondhill.net" = addon "ublock-origin";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" =
          addon "bitwarden-password-manager";
      };
      readOnly = true;
    };

    preferences = lib.mkOption {
      type = lib.types.attrs;
      description = "Read-only attrset of Firefox preferences.";
      default = with utils; {
        "browser.topsites.contile.enabled" = lock-false;
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
        "sidebar.verticalTabs" = lock-true;
      };
      readOnly = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      inherit (cfg) enable package;
      languagePacks = ["en-US"];

      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        BlockAboutProfiles = true;
        DisableFirefoxScreenshots = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableProfileImport = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "never";
        DontCheckDefaultBrowser = true;
        EnableTrackingProtection.Value = true;
        EnableTrackingProtection.Locked = true;
        EnableTrackingProtection.Cryptomining = true;
        EnableTrackingProtection.Fingerprinting = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        PasswordManagerEnabled = false;
        PromptForDownloadLocation = false;
        SkipTermsOfUse = true;
        ExtensionSettings = cfg.addons;
        Preferences = cfg.preferences;
      };

      profiles = {
        "${config.home.username}".isDefault = true;
      };
    };

    xdg.mimeApps.defaultApplications = builtins.listToAttrs (
      map (type: lib.nameValuePair type ["firefox.desktop"]) [
        "text/html"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ]
    );
  };
}
