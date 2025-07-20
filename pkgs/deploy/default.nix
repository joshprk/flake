{
  python3Packages,
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
}
