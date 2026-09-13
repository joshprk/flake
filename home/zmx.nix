{pkgs, ...}: {
  packages = with pkgs; [
    fzf
    zmx
  ];

  xdg.config.files."fish/conf.d/20-zmx.fish".text = ''
    function zmx-select
      zmx ls --short | fzf \
        --prompt "zmx> " \
        --height "30%" \
        --min-height "20+" \
        --margin "0,20,0,0" \
        --layout "reverse" \
        --preview "zmx hi {}" \
        --preview-window "right:60%,<60(hidden)" \
        --bind "enter:become(zmx attach {})" \
        --bind "ctrl-n:become(zmx attach {q})" \
        --bind "ctrl-k:become(zmx kill {})"
    end

    alias z="zmx-select"
  '';
}
