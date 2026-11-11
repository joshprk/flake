{
  config,
  lib,
  pkgs,
  ...
}: {
  options.pods.amp-orbs = lib.mkEnableOption "the container-backed Amp orb provider";

  config = lib.mkIf config.pods.amp-orbs {
    virtualisation.oci-containers.containers.amp-orbs = {
      image = "localhost/amp-orbs:latest";
      imageFile = pkgs.callPackage ./image.nix {};
      pull = "never";
      environmentFiles = ["/nix/secrets/amp-orbs"];
      volumes = ["amp-orbs-storage:/var/lib/containers"];
      environment = {
        ORB_IMAGE = "us-central1-docker.pkg.dev/amp-prod-0/amp-orb/amp-orb${lib.optionalString pkgs.stdenv.hostPlatform.isAarch64 "-arm64"}:latest";
      };
      extraOptions = [
        "--privileged"
        "--shm-size=1g"
        "--image-volume=ignore"
      ];
    };
  };
}
