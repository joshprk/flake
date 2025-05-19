{...}: {
  config = {
    environment.enableAllTerminfo = true;
    environment.variables = {
      TERMINFO = "$XDG_DATA_HOME/terminfo";
      TERMINFO_DIRS = "$XDG_DATA_HOME/terminfo:/usr/share/terminfo";
    };
  };
}
