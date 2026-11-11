{
  amp-cli,
  dockerTools,
  lib,
  stdenv,
  writeTextFile,
}: let
  hashes = {
    aarch64-linux = "sha256-+cicZxeQ/akCYi+v9+fPi2vbH2zCwKGgacPWvqiNsq4=";
    x86_64-linux = "sha256-aoDY8XHjVrHOtCNsHxVOEgaeetLMiynbAYCTDBLbG5k=";
  };
in
  dockerTools.buildLayeredImage {
    name = "localhost/amp-orbs";
    tag = "latest";
    fromImage = dockerTools.pullImage {
      imageName = "quay.io/podman/stable";
      imageDigest = "sha256:7b5e95b4934dde2d367b949c47a68f3705ca21e077fb27ed9a5b4fb8b01b9008";
      hash = hashes.${stdenv.hostPlatform.system};
      finalImageTag = "base";
    };
    contents = [
      (writeTextFile {
        name = "amp-orbs-dispatch";
        destination = "/dispatch.sh";
        executable = true;
        text = builtins.readFile ./dispatch.sh;
      })
    ];
    config = {
      Entrypoint = [(lib.getExe amp-cli) "orb" "provider" "/dispatch.sh"];
      Cmd = [];
      Env = ["HOME=/root" "AMP_SKIP_UPDATE_CHECK=1" "PATH=/usr/local/bin:/usr/bin"];
    };
  }
