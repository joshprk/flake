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
        echo "+ format disk using disko"
        echo "+ enroll secrets key"
        echo "+ rekey secrets for host"
        echo "+ push new host config to remote"
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

        echo "$(tput bold)Authenticate GitHub to continue...$(tput sgr0)"

        ${lib.getExe pkgs.git-credential-manager} github login
        git clone ${lib.head (lib.splitString "?ref=" self.paths.git)} "$TMPDIR"

        if ! test -d "$HOSTPATH"; then
          echo "Host configuration does not exist. No changes were made."
          exit 1
        fi

        nix run github:nix-community/nixos-facter -- -o "$HOSTPATH/facter.json"

        nix run path:${inputs.disko} -- \
          --mode destroy,format,mount \
          --yes-wipe-all-disks \
          --flake "$TMPDIR"#"$TARGET_HOST"

        mkdir -p "$STATE_DIR"

        ${pkgs.age}/bin/age-keygen > "$SYSTEM_KEY"
        chown -R root "$STATE_DIR"
        chmod -R 600 "$STATE_DIR"

        grep "# public key: " "$SYSTEM_KEY" | \
          awk -F': ' '{print $2}' > "$HOSTPATH/keyring.pub"

        ${pkgs.agenix-rekey}/bin/agenix rekey -a

        git add .
        git commit -m "chore: configure host \`$TARGET_HOST\`"
        git push

        nixos-install \
          --no-root-password \
          --no-channel-copy \
          --flake "$TMPDIR"#"$TARGET_HOST"

        if test -e "/dev/tpmrm0"; then
          PASSWORD=$(systemd-ask-password "Enter passphrase to enroll to TPM")
          export PASSWORD
          for device in /dev/disk/by-partlabel/*; do
            if [[ -b "$device" ]] && cryptsetup isLuks "$device" 2>/dev/null; then
              systemd-cryptenroll --tpm2-device=auto "$device" || true
            fi
          done
          unset PASSWORD
        fi
      '';
    };

    packages.installer =
      (lib.nixosSystem {
        inherit system;
        modules = lib.singleton {
          imports = with inputs; let
            isoType = "installation-cd-minimal.nix";
          in ["${nixpkgs}/nixos/modules/installer/cd-dvd/${isoType}"];

          environment.sessionVariables = {
            GCM_CREDENTIAL_STORE = "cache";
          };

          environment.shellAliases = {
            install = "sudo nix run git+${self.paths.git}#install";
          };

          programs.git = {
            enable = true;
            config = {
              user.name = "Automaton";
              user.email = "auto@joshprk.me";
              credential.helper = "manager";
              init.defaultBranch = "main";
            };
          };

          networking.wireless = {
            enable = false;
            iwd.enable = true;
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
