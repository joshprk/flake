{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.deploy;
in {
  options.modules.deploy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the deploy module.";
      default = false;
    };

    containers = lib.mkOption {
      type = with lib.types; attrsOf (submodule {
        options.autoStart = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        options.binds = lib.mkOption {
          type = with lib.types; listOf (either str (submodule {
            options.hostPath = {
              type = nullOr str;
              default = null;
            };

            options.mountPoint = {
              type = str;
            };

            options.isReadOnly = {
              type = bool;
              default = false;
            };
          }));
          default = [];
          apply = opt: lib.pipe opt [
            (map (bind: rec {
              name = value.mountPoint;
              value =
                if builtins.isString bind
                then {mountPoint = bind;}
                else bind;
            }))
            builtins.listToAttrs
          ];
        };

        options.config = lib.mkOption {
          type = lib.types.deferredModule;
        };

        options.forwardPorts = lib.mkOption {
          type = with lib.types; listOf (submodule {
            options.containerPort = lib.mkOption {
              type = ints.positive;
            };

            options.hostPort = lib.mkOption {
              type = nullOr ints.positive;
              default = null;
            };

            options.protocol = lib.mkOption {
              type = str;
            };
          });
          default = [];
        };

        options.internal = lib.mkOption {
          type = lib.types.bool;
          default = false;
          apply = opt:
            lib.throwIf
            (!config.services.tailscale.enable && opt)
            "node must be added to tailnet to host internal services"
            opt;
        };

        options.routes = lib.mkOption {
          type = with lib.types; attrsOf str;
          default = {};
        };
      });
      description = "An attrset of deployments.";
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = let
      numHosts =
        lib.length
        (builtins.attrNames config.services.caddy.virtualHosts);
      mkRouteInternal = route: ''
        @denied not remote_ip private_ranges 100.64.0.0/10
        abort @denied
        ${route}
      '';
    in {
      enable = numHosts > 0;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
        hash = "sha256-7TqepCX9F5AMAUJrH8wxdnrr3JMezhowyIPlfFYUQG8=";
      };
      environmentFile = config.age.secrets.caddy-env.path;

      globalConfig = ''
        acme_dns porkbun {
          api_key {env.PORKBUN_API_KEY}
          api_secret_key {env.PORKBUN_SEC_KEY}
        }
      '';

      virtualHosts = lib.pipe cfg.containers [
        builtins.attrValues
        (builtins.map (container:
          if container.internal
          then lib.mapAttrs (_: mkRouteInternal) container.routes
          else container.routes
        ))
        (lib.foldl (a: b:
          a // lib.mapAttrs (_: v: {extraConfig = v;}) b) {}
        )
      ];
    };

    containers = let
      mkContainer = cfg': {
        inherit (cfg') autoStart config forwardPorts;
        privateNetwork = true;
        bindMounts = cfg'.binds;
      };
    in
      lib.mapAttrs (_: mkContainer) cfg.containers;

    networking.firewall = let
      internalName = config.services.tailscale.interfaceName;
      parsePorts = filterCond: lib.pipe cfg.containers [
        (lib.filterAttrs (_: filterCond))
        builtins.attrValues
        (builtins.concatMap (x: x.forwardPorts))
        (lib.foldl (a: b: {
          allowedTCPPorts =
            a.allowedTCPPorts
            ++ lib.optional (b.protocol == "tcp") b.hostPort;
          allowedUDPPorts =
            a.allowedUDPPorts
            ++ lib.optional (b.protocol == "udp") b.hostPort;
        }) {
          allowedTCPPorts = [];
          allowedUDPPorts = [];
        })
      ];
    in
      {interfaces.${internalName} = parsePorts (c: c.internal);}
      // parsePorts (c: !c.internal);
  };
}
