# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/bda6825e-c8c2-410c-bfa2-cc5e11a4bcb4";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  # Fonts
  fonts = {
    fonts = with pkgs; [
      fira
      fira-code
      inconsolata
    ];
  };

  networking.hostName = "nixos";
  networking.enableB43Firmware = true;
  networking.networkmanager.enable = true;
  networking.hosts = {
    "127.0.0.1" = [
      "ashevillecreativeleague.test"
      "chcmadisoncountync.test"
      "bountifulcities.test"
      "diamondrubber.test"
      "fsl-backend.test"
      "fullsteamlabs.test"
      "riverartsdistrict.test"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    ag
    bind
    chromium
    davfs2
    docker docker_compose
    elixir
    emacs
    erlang
    evince
    filezilla
    firefox
    gimp
    git
    gnumeric
    gnupg
    hfsprogs
    insomnia
    insync
    kbdlight
    keychain
    libreoffice
    mopidy mopidy-iris mopidy-spotify mpc_cli
    mu
    offlineimap
    physlock
    qutebrowser
    redshift
    spectacle
    sublime3
    unzip
    virtualbox
    wget
    whois
    xorg.xbacklight
    xbindkeys xbindkeys-config xdotool
    xorg.xmodmap
    zip
  ];

  nixpkgs.config.chromium = {
    enableAdobeFlash = true;
    enableAdobePDF = true;
  };

  # Allow Editing Keyboard Backlight without Password
  security.sudo.extraConfig = "jasonmj nixos = (root) NOPASSWD: /sys/class/leds/smc";

  # Locate Config
  services.locate.prunePaths = ["/boot" "/etc" "/home/jasonmj/.config" "/home/jasonmj/.cache" "/home/jasonmj/Maildir" "/nix/store" "/tmp" "/var/cache" "/var/lock" "/var/run" "/var/spool" "/var/tmp"];

  # Setup Mopidy
  services.mopidy = {
    enable = true;
    extensionPackages = [ pkgs.mopidy-spotify pkgs.mopidy-iris ];
    configuration = ''
      [local]
      enabled = true
      media_dir = /home/jasonmj/Music

      [spotify]
      enabled = true
      username = laurakeyes9
      password = Misomonster1
      client_id = 05839c1b-39a5-4250-bc13-fe900df0c6d2
      client_secret = Bco0YN3TzeeebulrpELi_2E-bCrnggJb1Gay3ILdjU8=
    '';
  };

  # Macbook Pro Fan Support
  services.mbpfan.enable = true;

  # Screen Locking
  services.physlock = {
    enable = true;
    lockOn.suspend = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Enable touchpad support.
  services.xserver.synaptics = {
    enable = true;
    tapButtons = true;
    fingersMap = [ 1 3 2 ];
    twoFingerScroll = true;
    minSpeed = "0.75";
    maxSpeed = "5.5";
    accelFactor = "0.015";
    palmDetect = true;
    palmMinWidth = 8;
    palmMinZ = 20;
    scrollDelta = -65;
  };

  # Enable Redshift as a Service
  services.redshift = {
    enable = true;
    latitude = "35.849549";
    longitude = "-82.738750";
  };

  # Setup the Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
    extraConfig = ''
      [General]
      InputMethod=

      [Theme]
      Current=clairvoyance
      ThemeDir=/sddm/themes
      FacesDir=/run/current-system/sw/share/sddm/faces
      EnableAvatars=false
    '';
    theme = "nixos";
  };
  services.xserver.windowManager.exwm.enable = true;

  # Enable sound.
  sound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.jasonmj = {
    description = "Jason Johnson";
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [
      "davfs"
      "docker"
      "networkmanager"
      "wheel"
    ];
  };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
