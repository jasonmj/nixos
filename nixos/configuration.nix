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
    pwvucontrol
    python312
    ripgrep
    sqlite
    unzip
    vim
    wget
  ];

  nix = {
    gc = { # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "jasonmj" ];
    };
  };

  networking.networkmanager.enable = true;

  programs.hyprland.enable = true;

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;  # Enable nss-mdns for resolving .local hostnames
      publish = {
        enable = true;
        addresses = true;
      };
    };

    getty.autologinUser = "jasonmj";

    logind.lidSwitch = "hibernate";

    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

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
