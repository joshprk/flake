{inputs, self, ...}: {
  flake = {
    agenix-rekey = inputs.agenix-rekey.configure {
      inherit (self) nixosConfigurations;
      userFlake = self;
    };
  };
}
