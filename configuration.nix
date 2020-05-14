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
      "cleanenergy.test"
      "cleanwp.test"
      "diamondrubber.test"
      "ecoexplore.test"
      "equinoxenvironmental.test"
      "go.fullsteamlabs.test"
      "keyespottery.test"
      "mt.freecycle.org"
      "fsl-backend.test"
      "icrt-iot-training.test"
      "ilsag.test"
      "newprairieconstruction.test"
      "newprairiesolar.test"
      "riverartsdistrict.test"
      "scan-harbor.test"
      "summitsearchsolutions.test"
      "toggl-podio.test"
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
      noto-fonts
    ];
  };

  # Enable dconf
  programs.dconf.enable = true;

  # Enable Slock
  programs.slock.enable = true;

  # Disable ssh-agent and use gpg-agent instead
  programs.ssh.startAgent = false;

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.gnupg.agent.pinentryFlavor = "emacs";

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
    atom
    automake
    autoconf
    alacritty
    arandr
    arp-scan
    avahi
    avrdude
    bash-completion
    bat
    blueman
    bluezFull
    bluez-tools
    chromium
    cmake
    davfs2
    dex
    docker
    docker_compose
    dunst
    unstable.emacs
    emacsPackagesNg.pdf-tools
    emacs-all-the-icons-fonts
    unstable.erlangR22
    unstable.elixir_1_9
    exa
    filezilla
    firefox
    fish
    gcc
    git
    gimp
    unstable.google-drive-ocamlfuse
    gnumake
    gnumeric
    gnupg
    gparted
    heroku
    htop
    imagemagick
    inotify-tools
    insomnia
    ispell
    isync
    killall
    libreoffice
    libfprint
    libtool
    lxqt.lxqt-openssh-askpass
    mlocate
    mplayer
    mumble
    linphone
    my-polybar
    networkmanagerapplet
    nmap
    nodejs
    nodePackages.javascript-typescript-langserver
    nodePackages.jsdoc
    nodePackages.prettier
    nodePackages.tern
    nodePackages.typescript
    unstable.nodePackages.bash-language-server
    unstable.nodePackages.dockerfile-language-server-nodejs
    unstable.nodePackages.vscode-css-languageserver-bin
    unstable.nodePackages.vue-language-server
    openshot-qt
    openssl
    openvpn
    pandoc
    paprefs
    pasystray
    pavucontrol
    # pinentry-curses
    pharo
    php72
    php72Packages.composer
    python3
    qemu
    # qmk_firmware
    rebar3
    remmina
    ripgrep
    rofi
    sass
    screenkey
    scrot
    shutter
    signal-desktop
    simplescreenrecorder
    squashfsTools
    sqlite
    stalonetray
    sublime3
    teamviewer
    telnet
    tmux
    traceroute
    tree
    unrar
    unzip
    usbutils
    vim
    vscodium
    watchman
    wget
    whois
    wordnet
    xbanish
    xbindkeys xbindkeys-config xdotool
    xorg.xbacklight xorg.xev xorg.xmodmap
    yarn
    yubikey-manager
    yubikey-personalization
    zeal
    zip
    zoom-us
  ];

  # Nixpkgs overlays
  nixpkgs.overlays = [
    (self: super: {
      my-polybar = super.polybar.override {
        pulseSupport = true;
      };
    })
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

  # Locate Config
  services.locate.enable = true;
  services.locate.interval = "minutely";
  services.locate.pruneNames = [".cache" ".config" ".emacs.d" ".git" ".local" ".mail" "mix" ".mozilla" ".themes" "node_modules" ".ssh" "tmp"];
  services.locate.prunePaths = ["/bin" "/boot" "/dev" "/mnt" "/nix" "/store" "/path" "/proc" "/root" "/run" "/sddm" "/sys" "/system" "/usr" "/var"];
  services.locate.locate = pkgs.mlocate;

  # fprint
  services.fprintd.enable = true;

  # fwupd
  services.fwupd.enable = true;

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.logRefusedConnections = true;

  services.logind.lidSwitch = "ignore";
  services.logind.extraConfig = "
    HandlePowerKey=suspend
    HandleSuspendKey=suspend
    HandleHibernateKey=suspend
    IdleAction=ignore
  ";

  # Enable sound.
  sound.enable = true;

  # USB Guard
  # services.usbguard.enable = true;

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Prevent locked screen bypass by switching VTs or killing the X server with Ctrl+Alt+Backspace
  # Option "DontVTSwitch" "True"
  services.xserver.config = ''
    Section "ServerFlags"
      Option "DontZap"      "True"
      Option "BlankTime"    "0"
      Option "StandbyTime"  "0"
      Option "SuspendTime"  "0"
      Option "OffTime"      "0"
    EndSection
  '';

  services.xserver.layout = "us";

  # Keyboard Sensitivity
  services.xserver.autoRepeatDelay = 130;
  services.xserver.autoRepeatInterval = 12;

  # Enable touchpad support
  services.xserver.libinput = {
    enable = true;
    accelSpeed = "0.5";
    clickMethod = "none";
    disableWhileTyping = true;
    naturalScrolling = false;
    tapping = false;
  };

  #
  services.xserver.displayManager.session = [
    {
      manage = "window";
      name = "emacs";
      start = ''
        exec dbus-launch --exit-with-session ${pkgs.unstable.emacs}/bin/emacs
      '';
    }
  ];

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
  };
  location = {
    latitude = 35.849549;
    longitude = -82.738750;
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
    extraGroups = [ "bluetooth" "davfs2" "docker" "input" "mlocate" "networkmanager" "wheel" ];
  };
  users.users.davfs2 = {
    group = "davfs2";
  };

  # User nslcd daemon (nss-pam-ldapd) to handle LDAP lookups for NSS and PAM
  users.ldap.daemon.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "20.03";
}
