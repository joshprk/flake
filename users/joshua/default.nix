{...}: {
  isNormalUser = true;
  initialPassword = "password";
  hostGroups = ["default"];
  extraGroups = ["wheel"];
  stateVersion = "24.11";

  config = {config, ...}: {
    
  };
}
