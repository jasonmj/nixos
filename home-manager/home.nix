{ config, inputs, pkgs, ... }:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  imports = [inputs.xremap-flake.homeManagerModules.default];

  home.homeDirectory = "/home/jasonmj";
  home.packages = with pkgs; [
    # Programming Langs & Tools
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    delta
    emacs-lsp-booster
    erlang_27
    elixir_1_18
    nodejs

    # CLI Utilities
    direnv
    ripgrep

    # GUI Utilities
    haskellPackages.greenclip
    rofi-wayland
    waybar
    wob
    wpaperd

    # Apps
    emacs
    firefox
    gscreenshot

    # Fonts
    emacs-all-the-icons-fonts
    fira-code
    fira-code-symbols
    iosevka
    (nerdfonts.override { fonts = [ "FiraCode" "Iosevka"]; })
  ];
  home.stateVersion = "24.11";
  home.username = "jasonmj";

  programs.kitty = {
    enable = true;
    settings.enable_audio_bell = false;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = ./programs/rofi/themes/rounded-nord-dark.rasi;
  };

  services.emacs = {
    enable = true;
    startWithUserSession = "graphical";
  };

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
    };
  };

  services.xremap = {
    config = (import ./../nixos/modules/xremap/default.nix { inherit pkgs; });
    withWlroots = true;
  };

  systemd.user.startServices = "sd-switch";

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = (builtins.readFile ./modules/hyprland.conf);
    plugins = [pkgs.hyprlandPlugins.hyprspace];
  };
}
