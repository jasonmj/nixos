{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  imports =
    [
      ./battery-notifier.nix
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
      fira-code
      fira-code-symbols
      inconsolata
			iosevka
    ];
  };

  # Automatic Garbage Collection
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";

  # Networking Config
  networking.enableB43Firmware = true;
  networking.enableIPv6 = false;
  networking.hostName = "nixos";
  networking.hosts = {
    "127.0.0.1" = [
      "appalshop.test"
      "cleanenergy.test"
      "cleanenergyactionfund.test"
      "diamondrubber.test"
      "dogwoodalliance.test"
      "ecoexplore.test"
      "fsl-backend.test"
      "fullsteamlabs.test"
      "johnsonhilliard.test"
      "riverartsdistrict.test"
      "summitsearchsolutions.test"
      "toggl-podio.test"
    ];
  };
  networking.networkmanager.enable = true;

  # Package Configuration
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = ["webkitgtk-2.4.11"];

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
    alacritty
    arp-scan
    bat
    beam.packages.erlangR21.elixir_1_7
    bind
    chromium
    clojure
    davfs2
    docker docker_compose
    dunst
    emacs
    emacsPackagesNg.melpaPackages.pdf-tools
    file
    filezilla
    firefox
    gimp
    git
    gnumeric
    gnupg
    hfsprogs
    htop
    imagemagick
    inotify-tools
    insomnia
    insync
    ispell
    isync
    lastpass-cli
    libnotify
    libreoffice
    leiningen
    unstable.linphone
    mlocate
    mopidy mopidy-iris mopidy-spotify mpc_cli
    msmtp
    mu
    nmap
    nodejs
    nodePackages.javascript-typescript-langserver
    nodePackages.tern
    openssl
    pavucontrol
    python
    ripgrep
    sass
    scrot
    smbnetfs
    sqlite
    sublime3
    traceroute
    unstable.toggldesktop
    unzip
    virtualbox
    vscode
    w3m
    watchman
    wget
    whois
    wordnet
    xorg.xbacklight
    xbindkeys xbindkeys-config xdotool
    xorg.xmodmap
    yarn
    yubikey-manager
    yubikey-personalization
    zip
  ];

  nixpkgs.config.chromium = {
    enableAdobeFlash = false;
    enableAdobePDF = true;
  };

  # Avahi mDNS Service
  services.avahi = {
    enable = true;
    interfaces = ["wlp3s0"];
    publish.addresses = false;
    nssmdns = true;
  };

  # Battery Notifier
  services.batteryNotifier.enable = true;

  # Locate Config
  services.locate.enable = true;
  services.locate.interval = "minutely";
  services.locate.pruneNames = [".cache" ".config" ".emacs.d" ".git" ".insync-trash" ".kde" ".local" ".mail" "mix" ".mozilla" ".themes" "node_modules" ".ssh" "tmp"];
  services.locate.prunePaths = ["/bin" "/boot" "/dev" "/mnt" "/nix" "/store" "/path" "/proc" "/root" "/run" "/sddm" "/sys" "/system" "/usr" "/var"];
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

  # Enable the systemd DNS resolver daemon
  services.resolved.enable = true;

  # UDEV Packages
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.startDbusSession = true;
  services.xserver.layout = "us";

  # Touchpad Configuration
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
  services.xserver.displayManager.sddm = {
    enable = true;
    extraConfig = ''
      [General]
      InputMethod=

      [Theme]
      Current=minimal
      ThemeDir=/sddm/themes
      FacesDir=/run/current-system/sw/share/sddm/faces
      EnableAvatars=false
    '';
  };
  services.xserver.windowManager.exwm.enable = true;

  # Enable sound.
  sound.enable = true;

  # System version, channel, and upgrade settings
  system = {
    autoUpgrade.enable = true;
    autoUpgrade.channel = https://nixos.org/channels/nixos-18.09;
    stateVersion = "18.09";
  };

  # systemd timeout settings
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=1s
  '';

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

  # User nslcd daemon (nss-pam-ldapd) to handle LDAP lookups for NSS and PAM
  users.ldap.daemon.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

}
