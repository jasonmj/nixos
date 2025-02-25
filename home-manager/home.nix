{ config, inputs, pkgs, ... }:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  imports = [inputs.xremap-flake.homeManagerModules.default];

  home.file."links/vterm".source = "${pkgs.emacs30-pgtk.pkgs.vterm}/share/emacs/site-lisp/elpa";
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
    jq
    ripgrep

    # GUI Utilities
    haskellPackages.greenclip
    rofi-wayland
    waybar
    wob
    wpaperd

    # Apps
    code-cursor
    emacs30-pgtk
    firefox
    gscreenshot

    # Fonts
    emacs-all-the-icons-fonts
    fira-code
    fira-code-symbols
    iosevka
    unstable.nerd-fonts.fira-code
    unstable.nerd-fonts.iosevka
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
    package = pkgs.emacs30-pgtk;
    startWithUserSession = "graphical";
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-emacs;

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
    plugins = [ pkgs.hyprlandPlugins.hyprexpo ];
  };

  xdg.desktopEntries = {
    emacs = {
      name = "Emacs";
      noDisplay = true;
    };
    emacsclient = {
      name = "Emacs";
      exec = "emacsclient -c";
      icon = "/etc/profiles/per-user/jasonmj/share/icons/hicolor/32x32/apps/emacs.png";
    };
    htop = {
      name = "Htop";
      noDisplay = true;
    };
    nixos-manual = {
      name = "NixOS Manual";
      noDisplay = true;
    };
    vim = {
      name = "Vim";
      noDisplay = true;
    };
  };
}
