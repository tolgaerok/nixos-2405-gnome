{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    proggyfonts
    #    nerdfonts
    corefonts
    font-awesome
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
    }) {
      inherit pkgs;
    };
  };

  environment.systemPackages = with pkgs; [
    nur.repos.sagikazarmark.sf-pro
  ];
}
