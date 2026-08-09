{
  pkgs,
  homeModule,
  ...
}: {
  programs.fish.enable = true;

  services = {
    dbus.implementation = "broker";
    userborn.enable = true;
  };

  hjem = {
    extraModules = [homeModule];
    users.josh = {};
  };

  users = {
    # Temporarily set until secrets integration
    allowNoPasswordLogin = true;
    mutableUsers = false;
    users.josh = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["wheel"];
    };
  };

  security.pam.u2f = {
    enable = true;
    settings = {
      appid = "pam://nixos";
      origin = "pam://nixos";
      cue = true;
    };
  };
}
