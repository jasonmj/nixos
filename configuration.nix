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

  # Filesystems
  fileSystems."/home/jasonmj/org" = {
    device = "https://dav.box.com/dav";
    fsType = "davfs";
    options = [
      "noauto"
      "uid=1000"
      "gid=100"
      "x-systemd.automount"
    ];
  };

  # Fonts
  fonts = {
    fonts = with pkgs; [
      fira
      fira-code
      hack-font
      inconsolata
      iosevka
      source-code-pro
    ];
  };

  # automatic gc
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";

  networking.hostName = "nixos";
  networking.enableB43Firmware = true;
  networking.networkmanager.enable = true;
  networking.hosts = {
    "127.0.0.1" = [
      "ashevillecreativeleague.test"
      "chcmadisoncountync.test"
      "cleanenergy.test"
      "cleanenergyactionfund.test"
      "bountifulcities.test"
      "diamondrubber.test"
      "dogwoodalliance.test"
      "fsl-backend.test"
      "fullsteamlabs.test"
      "johnsonhilliard.test"
      "kingshouseorientalrugs.test"
      "riverartsdistrict.test"
    ];
  };
  networking.enableIPv6 = false;

  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Keyboard Backlight
  programs.kbdlight.enable = true;

  # Enable Slock
  programs.slock.enable = true;

  # Disable ssh-agent and use gpg-agent instead
  programs.ssh.startAgent = false;

  # Installed Packages
  environment.systemPackages = with pkgs; [
    ag
    bind
    chromium
    davfs2
    docker docker_compose
    dunst
    emacs
    filezilla
    firefox
    gimp
    git
    gnumeric
    gnupg
    hfsprogs
    htop
    insomnia
    insync
    ispell
    isync
    libnotify
    libreoffice
    mlocate
    mopidy mopidy-iris mopidy-spotify mpc_cli
    msmtp
    mu
    openssl
    pavucontrol
    python
    ripgrep
    scrot
    sublime3
    unzip
    virtualbox
    wget
    whois
    xorg.xbacklight
    xbindkeys xbindkeys-config xdotool
    xorg.xmodmap
    yarn
    yubikey-manager
    yubikey-personalization
    zip
  ];

  nixpkgs.config.chromium = {
    enableAdobeFlash = true;
    enableAdobePDF = true;
  };

  # Locate Config
  services.locate.enable = true;
  services.locate.interval = "hourly";
  services.locate.extraFlags = [
    "--prunenames='.cache .config .emacs.d .git .insync-trash .kde .local .mail mix .mozilla .themes  node_modules org .ssh tmp'"
    " --prunepaths='/bin /boot /dev /mnt /nix/store /path /proc /root /run /sddm /sys /system /usr /var'"
  ];
  services.locate.locate = pkgs.mlocate;

  # Power Event Config
  services.logind.extraConfig = ''
  HandlePowerKey=ignore
  '';

  # Setup Mopidy
  services.mopidy = {
    enable = true;
    extensionPackages = [ pkgs.mopidy-spotify pkgs.mopidy-iris ];
    configuration = ''
      [mpd]
      enabled = true
      hostname = 127.0.0.1

      [http]
      enabled = true
      hostname = 127.0.0.1
      port = 6680

      [local]
      enabled = true
      media_dir = /home/jasonmj/Music

      [spotify]
      enabled = true
      username = laurakeyes9
      password = Misomonster1
      client_id = 05839c1b-39a5-4250-bc13-fe900df0c6d2
      client_secret = Bco0YN3TzeeebulrpELi_2E-bCrnggJb1Gay3ILdjU8=

      [audio]
      output = pulsesink server=127.0.0.1
    '';
  };

  # Macbook Pro Fan Support
  services.mbpfan.enable = true;

  # Enable pcscd for smartcard support
  services.pcscd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # UDEV Packages
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.startDbusSession = true;
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
      Current=nixos
      ThemeDir=/sddm/themes
      FacesDir=/run/current-system/sw/share/sddm/faces
      EnableAvatars=false
    '';
  };
  services.xserver.windowManager.exwm.enable = true;

  # Enable sound.
  sound.enable = true;

  # Automatic updates every day
  system.autoUpgrade.enable = true;

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

  system.stateVersion = "18.03";

}
