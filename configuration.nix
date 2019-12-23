{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in

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
      "acaexplained.test"
      "cleanenergy.test"
      "cleanwp.test"
      "concordpsychotherapy.test"
      "diamondrubber.test"
      "docbiddle.test"
      "ecoexplore.test"
      "go.fullsteamlabs.test"
      "fracturedappalachia.test"
      "fsl-backend.test"
      "icrt-iot-training.test"
      "ilsag.test"
      "johnsonhilliard.test"
      "newprairiesolar.test"
      "riverartsdistrict.test"
      "summitsearchsolutions.test"
      "toggl-podio.test"
      "theuniformproject.test"
      "wncworkerscenter.test"
      "weavervilleartsafari.test"
    ];
    "0.0.0.0" = ["fullsteamlabs.test"];
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

  # Enable dconf
  programs.dconf.enable = true;

  # Enable Slock
  programs.slock.enable = true;

  # Disable ssh-agent and use gpg-agent instead
  programs.ssh.startAgent = false;

  # Packages
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    automake
    autoconf
    alacritty
    arp-scan
    avahi
    avrdude
    bash-completion
    bat
    bluez
    chromium
    cmake
    davfs2
    docker
    docker_compose
    dolphin
    dunst
    emacs
    emacsPackagesNg.pdf-tools
    unstable.emacsPackages.emacs-libvterm
    emacs-all-the-icons-fonts
    entr
    unstable.erlangR22
    unstable.elixir_1_9
    exa
    filezilla
    firefox
    fish
    fwup
    gcc
    git
    gimp
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
    unstable.libvterm-neovim
    lxqt.lxqt-openssh-askpass
    mlocate
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
    paprefs
    pavucontrol
    python3
    rebar3
    remmina
    ripgrep
    rofi
    scrot
    shutter
    signal-desktop
    simplescreenrecorder
    squashfsTools
    sqlite
    sublime3
    teamviewer
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
    zeal
    zip
    zoom-us
  ];

  # Battery Notifier
  services.batteryNotifier.enable = true;

  # Avahi mDNS Service
  services.avahi = {
    enable = true;
    interfaces = ["wlp0s20f3"];
    publish.addresses = false;
    nssmdns = true;
  };

  # ACPI
  services.acpid.enable = true;
  services.acpid.powerEventCommands = ''
    slock
  '';

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

  # Prevent locked screen bypass by switching VTs or killing the X server with Ctrl+Alt+Backspace
  services.xserver.config = ''
    Section "ServerFlags"
             Option "DontVTSwitch" "True"
             Option "DontZap"      "True"
     EndSection
  '';

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
  services.xserver.windowManager.default = "exwm";
  services.xserver.desktopManager.default = "none";

  # Enable SDDM
  services.xserver.displayManager.sddm = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "jasonmj";
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

  # Define Users and Groups
  users.groups.davfs2 = {};
  users.groups.mlocate = {};
  users.users.jasonmj = {
    description = "Jason Johnson";
    isNormalUser = true;
    uid = 1000;
    group= "users";
    extraGroups = [ "davfs2" "docker" "input" "mlocate" "networkmanager" "wheel" ];
  };
  users.users.davfs2 = {
    group = "davfs2";
  };

  # User nslcd daemon (nss-pam-ldapd) to handle LDAP lookups for NSS and PAM
  users.ldap.daemon.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "19.09";
}
