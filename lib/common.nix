{
  self,
  lib,
  ...
}: {
  forAllSystems = lib.genAttrs lib.systems.flakeExposed;

  ensureDefaults = spec: args:
    if builtins.isAttrs spec
    then
      lib.recursiveUpdate
      (builtins.mapAttrs (
          name: default:
            if builtins.hasAttr name args
            then self.common.ensureDefaults args.${name} args.${name}
            else self.common.ensureDefaults default default
        )
        spec)
      args
    else args;

  readModulesDir = path:
    if builtins.pathExists path
    then
      lib.pipe path [
        builtins.readDir
        builtins.attrNames
        (map (name: lib.path.append path name))
        (map import)
      ]
    else [];

  wrapLazy = fn: fn (builtins.functionArgs fn) // {__functor = fn;};
}
