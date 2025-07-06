# Unfortunately, forge is private infrastructure used for my consulting
# services, and exposing information about it publicly is irresponsible.
#
# As a result, its nixexprs are hosted on a private repository.
#
builtins.fetchGit {
  url = "git@github.com:joshprk/forge.git";
};
