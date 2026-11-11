{
  config,
  lib,
  ...
}: {
  options.pods.hello-world = lib.mkEnableOption "the hello-world pod";

  config = lib.mkIf config.pods.hello-world {
    virtualisation.oci-containers.containers."hello-world" = {
      image = "docker.io/library/hello-world";
    };
  };
}
