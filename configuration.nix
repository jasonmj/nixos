{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
  unstable = import unstableTarball {
    config = config.nixpkgs.config;
  };
  emacsWithPackages = (unstable.emacsPackagesGen unstable.emacs).emacsWithPackages (epkgs: ([
    epkgs.pdf-tools
    epkgs.multi-vterm
    epkgs.vterm
  ]));
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

  # Trusted Users
  nix.trustedUsers = [ "root" "jasonmj" ];

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.logRefusedConnections = true;

  # Networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.hosts = {
    "127.0.0.1" = [
      "bankruptcypros.test"
      "cleanenergy.test"
      "cleanwp.test"
      "dogwoodalliance.test"
      "diamondrubber.test"
      "ecoexplore.test"
      "equinoxenvironmental.test"
      "go.fullsteamlabs.test"
      "keyespottery.test"
      "freecycle.test"
      "mt.freecycle.org"
      "freecycle.org"
      "fsl-backend.test"
      "icrt-iot-training.test"
      "ilsag.test"
      "newprairieconstruction.test"
      "newprairiesolar.test"
      "riverartsdistrict.test"
      "scan-harbor.test"
      "staff.brchs.test"
      "summitsearchsolutions.test"
      "teflpros.test"
      "toggl-podio.test"
    ];
    "0.0.0.0" = ["fullsteamlabs.test"];
    "192.168.0.11" = ["pitimer.config"];
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

  # Android Studio
  programs.adb.enable = true;

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
    androidStudioPackages.dev
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
    clojure
    cmake
    davfs2
    dex
    direnv
    discord
    docker
    docker_compose
    dpkg
    dunst
    emacsWithPackages
    emacs-all-the-icons-fonts
    unstable.erlangR23
    unstable.beam.packages.erlangR23.elixir
    esptool
    exa
    fastlane
    filezilla
    firefox
    fish
    gcc
    git
    gimp
    google-drive-ocamlfuse
    gnumake
    gnumeric
    gnupg
    gparted
    graphviz
    heroku
    htop
    inotify-tools
    insomnia
    ispell
    isync
    jdk
    jre
    killall
    libreoffice
    libfprint
    libtool
    lsof
    lxqt.lxqt-openssh-askpass
    mlocate
    mplayer
    mumble
    linphone
    my-polybar
    networkmanagerapplet
    networkmanager-l2tp
    next
    nix-prefetch-git
    nmap
    nodejs
    nodePackages.javascript-typescript-langserver
    nodePackages.jsdoc
    nodePackages.prettier
    nodePackages.tern
    nodePackages.typescript
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    openscad
    openshot-qt
    openssl
    openvpn
    pandoc
    paprefs
    pasystray
    pavucontrol
    picocom
    php72
    php72Packages.composer
    pv
    python3
    python38Packages.xdot
    qemu
    rebar3
    remmina
    ripgrep
    rofi
    sass
    sassc
    screen
    scrot
    shutter
    signal-desktop
    simplescreenrecorder
    squashfsTools
    sqlite
    stalonetray
    sublime3
    tclap
    teamviewer
    telnet
    tmux
    traceroute
    tree
    typora
    unzip
    usbutils
    xdeltaUnstable
    vim
    vscodium
    watchman
    wget
    whois
    wordnet
    xbanish
    xbindkeys xbindkeys-config xdotool
    xl2tpd
    xorg.xbacklight xorg.xev xorg.xmodmap
    yarn
    yubikey-manager
    yubikey-personalization
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

  # Services
  services = {
    # ACPI
    acpid.enable = true;

    # Avahi mDNS Service
    avahi = {
      enable = true;
      interfaces = ["wlp0s20f3"];
      publish.addresses = false;
      nssmdns = true;
    };

    # Battery Notifier
    batteryNotifier.enable = true;

    # Locate Config
    locate = {
      enable = true;
      interval = "minutely";
      pruneNames = [".cache" ".config" ".emacs.d" ".git" ".local" ".mail" "mix" ".mozilla" ".themes" "node_modules" ".ssh" "tmp"];
      prunePaths = ["/bin" "/boot" "/dev" "/mnt" "/nix" "/store" "/path" "/proc" "/root" "/run" "/sddm" "/sys" "/system" "/usr" "/var"];
      locate = pkgs.mlocate;
    };

    # Lorri
    lorri.enable = true;

    # fprint
    # fprintd.enable = true;

    # fwupd
    fwupd.enable = true;

    # Laptop Lid & Power Button
    logind.lidSwitch = "ignore";
    logind.extraConfig = "
      HandlePowerKey=suspend
      HandleSuspendKey=suspend
      HandleHibernateKey=suspend
      IdleAction=ignore
    ";

    # Picom Composite Manager
    picom.enable = true;

    # USB Guard
    # usbguard.enable = true;

    # L2TP VPN
    xl2tpd.enable = true;

    # X11 Window Server
    xserver = {
      enable = true;

      # Keyboard Sensitivity
      autoRepeatDelay = 130;
      autoRepeatInterval = 12;
      layout = "us";

      # Option "DontVTSwitch" "True" # Prevent switching ttys
      config = ''
        Section "ServerFlags"
          Option "DontZap"      "True"
          Option "BlankTime"    "0"
          Option "StandbyTime"  "0"
          Option "SuspendTime"  "0"
          Option "OffTime"      "0"
        EndSection
      '';

      # Touchpad support
      libinput = {
        enable = true;
        accelSpeed = "0.3";
        clickMethod = "none";
        disableWhileTyping = true;
        naturalScrolling = false;
        tapping = false;
      };

      # Display Manager
      displayManager = {
        sddm = {
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

        session = [
          {
            manage = "window";
            name = "emacs";
            start = ''
              exec dbus-launch --exit-with-session ${pkgs.emacs}/bin/emacs -mm
            '';
          }
        ];
      };
    };

    # Enable Redshift as a Service
    redshift.enable = true;

    # Enable pcscd for smartcard support
    pcscd.enable = true;

    # UDEV Packages
    udev.packages = with pkgs; [
      avrdude
      esptool
      libmtp.bin
      yubikey-personalization
    ];
  };

  # Enable sound.
  sound.enable = true;

  location = {
    latitude = 35.849549;
    longitude = -82.738750;
  };

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
    extraGroups = [ "adbusers" "bluetooth" "davfs2" "dialout" "docker" "input" "mlocate" "networkmanager" "wheel" ];
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
