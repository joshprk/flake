{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.kernel;
in {
  options.modules.kernel = {
    package = lib.mkOption {
      type = lib.types.raw;
      description = "Which package to use for the Linux kernel.";
      default =
        if config.modules.home.interactive
        then pkgs.linuxPackages_zen
        else pkgs.linuxPackages_latest;
    };

    secureBoot = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable secure boot through Limine.";
      default = false;
    };

    pcr15Hash = lib.mkOption {
      type = with lib.types; nullOr str;
      description = "The expected value of PCR 15 after LUKS. Ignored if null.";
      default = null;
    };
  };

  options = {
    boot.initrd.luks.devices = lib.mkOption {
      type = with lib.types; attrsOf (submodule {
        config.crypttabExtraOpts = ["tpm2-device=auto" "tpm2-measure-pcr=yes"];
      });
    };
  };

  config = {
    modules.impermanence.extraDirectories = ["/var/lib/sbctl"];

    boot.loader = {
      limine = {
        enable = true;
        secureBoot.enable = cfg.secureBoot;
        enrollConfig = true;
        maxGenerations = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    boot.initrd = {
      systemd.enable = true;
      systemd.services = let
        check-pcrs = {
          script = ''
            echo "Checking PCR 15 value"
            if [[ $(systemd-analyze pcrs 15 --json=short \
                | ${pkgs.jq}/bin/jq -r ".[0].sha256") != \
                "${cfg.pcr15Hash}" ]] ; then
              echo "PCR 15 check failed"
              exit 1
            else
              echo "PCR 15 check succeeded"
            fi
          '';
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          unitConfig.DefaultDependencies = "no";
          after = ["cryptsetup.target"];
          before = ["sysroot.mount"];
          requiredBy = ["sysroot.mount"];
        };

        perDevice =
          lib.listToAttrs (
            lib.foldl'
              (acc: attrs:
                let
                  inherit (attrs) name value;
                  escapedDev = lib.utils.escapeSystemdPath value.device;
                  extraOpts =
                    value.crypttabExtraOpts
                    ++ (lib.optional attrs.value.allowDiscards "discard");
                  cfg' = config.boot.initrd.systemd;
                in
                  acc ++ [
                    (lib.nameValuePair "cryptsetup-${name}" {
                      unitConfig = {
                        Description = "Cryptography setup for ${name}";
                        DefaultDependencies = "no";
                        IgnoreOnIsolate = true;
                        Conflicts = [ "umount.target" ];
                        BindsTo = "${escapedDev}.device";
                      };
                      serviceConfig = {
                        Type = "oneshot";
                        RemainAfterExit = true;
                        TimeoutSec = "infinity";
                        KeyringMode = "shared";
                        OOMScoreAdjust = 500;
                        ImportCredential = "cryptsetup.*";
                        ExecStart = ''
                          ${cfg'.package}/bin/systemd-cryptsetup attach \
                            '${name}' '${value.device}' '-' \
                            '${lib.concatStringsSep "," extraOpts}'
                        '';
                        ExecStop = ''
                          ${cfg'.package}/bin/systemd-cryptsetup detach \
                            '${name}'
                        '';
                      };
                      after =
                        [
                          "cryptsetup-pre.target"
                          "systemd-udevd-kernel.socket"
                          "${escapedDev}.device"
                        ]
                        ++ (
                          lib.optional
                          cfg'.tpm2.enable
                          "systemd-tpm2-setup-early.service"
                        )
                        ++ (
                          lib.optional
                          (acc != [ ])
                          "${(lib.head acc).name}.service"
                        );
                      before = [
                        "blockdev@dev-mapper-${name}.target"
                        "cryptsetup.target"
                        "umount.target"
                      ];
                      wants = [ "blockdev@dev-mapper-${name}.target" ];
                      requiredBy = [ "sysroot.mount" ];
                    })
                  ]
          )
          []
          (lib.sortOn (x: x.name)
            (lib.attrsets.attrsToList config.boot.initrd.luks.devices))
        );
      in (lib.mkIf (cfg.pcr15Hash != null) {inherit check-pcrs;}) // perDevice;
      verbose = false;
    };

    boot.plymouth.enable = true;
    boot.consoleLogLevel = 0;
    boot.kernelParams = [
      (lib.mkIf (cfg.pcr15Hash != null) "rd.luks=no")
      "quiet"
      "plymouth.use-simpledrm"
    ];
    boot.kernelPackages = cfg.package;
  };
}
