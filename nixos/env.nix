{...}: {
  options.modules.env = {
  };

  config = {
    environment = {
      enableAllTerminfo = true;
      variables = {
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
