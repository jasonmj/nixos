{ config, pkgs, ... }:
{
  imports = [./hardware-configuration.nix];

  environment.systemPackages = with pkgs; [
    brightnessctl
    curl
    gcc
    git
    gnumake
    gnupg
    htop
    openssl
    python312
    ripgrep
    screen
    sqlite
    unzip
    vim
    wget
  ];

  environment.etc."links/vterm".source = "${pkgs.emacs.pkgs.vterm}/share/emacs/site-lisp/elpa";

  nix = {
    gc = { # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
    # nixPath = [ "nixos-config=/home/jasonmj/git/jasonmj/nixos/nixos/configuration.nix"];
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "jasonmj" ];
    };
  };

  networking.networkmanager.enable = true;

  programs = {
    gnupg.agent.pinentryPackage = pkgs.pinentry-emacs;
    hyprland.enable = true;
  };

  services = {
    getty.autologinUser = "jasonmj";
    logind.lidSwitch = "hibernate";
    pipewire.extraConfig.pipewire."99-silent-bell.conf"."context.properties"."module.x11.bell" = false;
  };

  time.timeZone = "America/New_York";

  users.users.jasonmj = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = ["networkmanager" "wheel"];
  };

  system.stateVersion = "24.11";
}
