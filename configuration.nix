{ config, pkgs, ... }:

{
  imports =
    [
      ./battery-notifier.nix
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Filesystems
  fileSystems."/home/jasonmj/org" = {
    device = "https://nextcloud.forthelonghaul.net/remote.php/webdav/";
    fsType = "davfs";
    options = [
      "noauto"
      "uid=1000"
      "gid=100"
      "x-systemd.automount"
    ];
  };

  # Automatic Garbage Collection
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.hosts = {
    "127.0.0.1" = [
      "cleanenergy.test"
      "cleanwp.test"
      "diamondrubber.test"
      "ecoexplore.test"
      "go.fullsteamlabs.test"
      "fsl-backend.test"
      "ilsag.test"
      "johnsonhilliard.test"
      "riverartsdistrict.test"
      "toggl-podio.test"
      "theuniformproject.test"
      "wncworkerscenter.test"
      "weavervilleartsafari.test"
    ];
    "0.0.0.0" = [
      "fullsteamlabs.test"
    ];
    "172.31.98.1" = ["aruba.odyssys.net"];
  };

  # Fonts
  fonts = {
    fontconfig.dpi = 120;
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      iosevka
      nerdfonts
    ];
  };

  # Enable Slock
  programs.slock.enable = true;

  # Disable ssh-agent and use gpg-agent instead
  programs.ssh.startAgent = false;

  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    arp-scan
    avrdude
    bash-completion
    bat
    chromium
    cmake
    davfs2
    docker
    docker_compose
    dolphin
    dunst
    emacs
    emacsPackagesNg.pdf-tools
    emacsPackagesNg.emacs-libvterm
    emacs-all-the-icons-fonts
    exa
    filezilla
    firefox
    fish
    gcc
    git
    gimp
    gftp
    gnumake
    gnumeric
    gnupg
    gparted
    heroku
    htop
    inotify-tools
    insomnia
    ispell
    isync
    libinput-gestures
    libreoffice
    libtool
    libvterm
    mlocate
    mopidy mopidy-iris mopidy-spotify mpc_cli
    mplayer
    nmap
    nodejs
    nodePackages.javascript-typescript-langserver
    nodePackages.prettier
    nodePackages.tern
    nodePackages.typescript
    openshot-qt
    openssl
    openvpn
    pavucontrol
    python3
    remmina
    ripgrep
    rofi
    scrot
    shutter
    signal-desktop
    simplescreenrecorder
    sqlite
    sublime3
    tmux
    traceroute
    tree
    typora
    unrar
    unzip
    usbutils
    vim
    virtualbox
    vscode
    watchman
    wget
    whois
    wordnet
    xbindkeys xbindkeys-config xdotool
    xorg.xbacklight xorg.xev xorg.xmodmap
    yubikey-manager
    yubikey-personalization
    zip
    zoom-us
  ];

  # Battery Notifier
  services.batteryNotifier.enable = true;

  # ACPI
  services.acpid.enable = true;
  services.acpid.powerEventCommands = ''
    slock
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

  # Locate Config
  services.locate.enable = true;
  services.locate.interval = "minutely";
  services.locate.pruneNames = [".cache" ".config" ".emacs.d" ".git" ".local" ".mail" "mix" ".mozilla" ".themes" "node_modules" ".ssh" "tmp"];
  services.locate.prunePaths = ["/bin" "/boot" "/dev" "/mnt" "/nix" "/store" "/path" "/proc" "/root" "/run" "/sddm" "/sys" "/system" "/usr" "/var"];
  services.locate.locate = pkgs.mlocate;
  # networking.firewall.enable = false;

  # Enable sound.
  sound.enable = true;

  # Enable the X11 windowing system
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Keyboard Sensitivity
  services.xserver.autoRepeatDelay = 160;
  services.xserver.autoRepeatInterval = 20;

  # Enable touchpad support
  services.xserver.libinput = {
    enable = true;
    accelSpeed = "0.5";
    clickMethod = "none";
    disableWhileTyping = true;
    naturalScrolling = true;
    tapping = false;
  };

  # Enable EXWM
  services.xserver.windowManager.exwm.enable = true;

  # Enable SDDM
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

  # Enable Redshift as a Service
  services.redshift = {
    enable = true;
    latitude = "35.849549";
    longitude = "-82.738750";
  };

  # Enable pcscd for smartcard support
  services.pcscd.enable = true;

  # UDEV Packages
  services.udev.packages = with pkgs; [
    avrdude
    libmtp.bin
    yubikey-personalization
  ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Define a user account
  users.groups.davfs2 = {};
  users.users.jasonmj = {
    description = "Jason Johnson";
    isNormalUser = true;
    uid = 1000;
    group= "users";
    extraGroups = [ "davfs2" "docker" "input" "networkmanager" "wheel" ];
  };
  users.users.davfs2 = {
    group = "davfs2";
  };

  # User nslcd daemon (nss-pam-ldapd) to handle LDAP lookups for NSS and PAM
  users.ldap.daemon.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "19.03";
}
