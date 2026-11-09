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

  hjem.users.josh = import homeModule;

  users = {
    allowNoPasswordLogin = true;
    mutableUsers = false;
    users.josh = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = [(builtins.readFile ../id_mldsa44_ed25519.pub)];
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
