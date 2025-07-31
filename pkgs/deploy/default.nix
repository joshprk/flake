{
  disko,
  facter,
  git,
  git-credential-manager,
  nix,
  python3Packages,
  sops,
  ...
}:
python3Packages.buildPythonApplication {
  pname = "deploy";
  version = "0.1.0";

  src = ./.;

  pyproject = true;

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = [
    disko
    facter
    git
    git-credential-manager
    nix
    sops
    python3Packages.textual
  ];
}
