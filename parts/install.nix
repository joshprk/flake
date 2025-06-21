{
  self,
  inputs,
  ...
}: {
  perSystem = {
    self',
    lib,
    pkgs,
    system,
    ...
  }: {
    apps.install = {
      type = "app";
      program = "${lib.getExe self'.packages.install}";
    };

    packages.install = pkgs.writeShellApplication {
      name = "install-system";
      
      runtimeInputs = with pkgs; [
        git-credential-manager
      ];

      text = ''
        read -p "Enter hostname: $(tput sgr0)" -r TARGET_HOST

        echo "+ authenticate github"
        echo "+ generate hardware report for nixos-facter"
        echo "+ enroll secrets key"
        echo "+ rekey secrets for host"
        echo "+ push new host config to remote"
        echo "+ format disk using disko"
        echo "+ run nixos-install to activate config"

        read -p "$(tput bold)Are you sure? (yes/[no]): $(tput sgr0)" -r CONFIRM

        if [ "$CONFIRM" != "yes" ]; then
          echo "Installation canceled. No changes were made."
          exit 1
        fi

        TMPDIR=$(mktemp -d)
        SYSTEM_KEY="/mnt${self.paths.key}"
        STATE_DIR=$(dirname "$SYSTEM_KEY")
        HOSTPATH="$TMPDIR/${builtins.baseNameOf self.paths.hosts}/$TARGET_HOST"

        cd "$TMPDIR"
        mkdir -p "$STATE_DIR"

        echo "$(tput bold)Authenticate GitHub to continue...$(tput sgr0)"

        ${lib.getExe pkgs.git-credential-manager} github login
        git clone ${self.paths.git} "$TMPDIR"

        if ! test -d "$HOSTPATH"; then
          echo "Host configuration does not exist. No changes were made."
          exit 1
        fi

        nix run github:nix-community/nixos-facter -- -o "$HOSTPATH/facter.json"
        ${pkgs.age}/bin/age-keygen > "$SYSTEM_KEY"
        chmod -R 000 "$STATE_DIR"
        chown -R root "$STATE_DIR"

        grep "# public key: " "$SYSTEM_KEY" | \
          awk -F': ' '{print $2}' > "$HOSTPATH/keyring.pub"

        ${pkgs.agenix-rekey}/bin/agenix rekey -a

        git add .
        git commit -m "chore: configure host \`$TARGET_HOST\`"
        git push

        nix run path:${inputs.disko} -- \
          --mode destroy,format,mount \
          --flake "$TMPDIR"#"$TARGET_HOST"

        nixos-install \
          --no-root-password \
          --no-channel-copy \
          --flake "$TMPDIR"#"$TARGET_HOST"

        if test -e "/dev/tpmrm0"; then
          echo "$(tput bold)If your disks are encrypted, make sure to run:"
          echo -e "$(tput sgr0)"
          echo "systemd-cryptenroll --tpm2-device /dev/tpmrm0 /mnt/nix"
        fi
      '';
    };

    packages.installer = (lib.nixosSystem {
      inherit system;
      modules = lib.singleton {
        imports = with inputs; let
          isoType = "installation-cd-minimal.nix";
        in
          ["${nixpkgs}/nixos/modules/installer/cd-dvd/${isoType}"];

        environment.sessionVariables = {
          GCM_CREDENTIAL_STORE = "cache";
        };

        programs.git = {
          enable = true;
          config = {
            user.name = "Joshua Park";
            user.email = "git@joshprk.me";
            credential.helper = "manager";
            init.defaultBranch = "main";
          };
        };

        networking.networkmanager = {
          enable = true;
        };

        networking.wireless = {
          enable = lib.mkForce false;
        };

        nix.settings.extra-experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
      };
    }).config.system.build.isoImage;
  };
}
