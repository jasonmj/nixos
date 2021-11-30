{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz;
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
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # mDNS Resolution
  systemd.network.networks.wlp0s20f3.networkConfig.MulticastDNS = true;
  # system.nssDatabases.hosts = [ "nerves-jasonmj" ];
  # services.resolved = {
  #       enable = true;
  #       fallbackDns = ["8.8.8.8" "2001:4860:4860::8844"];
  # };

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
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 8000 9630 19000 19001 19002 19003 ];

  # Networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.hosts = {
    "127.0.0.1" = [
      "artswrite.test"
      "ashevilletheatre.test"
      "bankruptcypros.test"
      "cleanenergy.test"
      "cleanwp.test"
      "dogwoodalliance.test"
      "ecoexplore.test"
      "equinoxenvironmental.test"
      "go.fullsteamlabs.test"
      "golocalasheville.test"
      "keyespottery.test"
      "litnotice.test"
      "freecycle.test"
      "johnsonhilliard.test"
      "mt.freecycle.org"
      "freecycle.org"
      "fsl-backend.test"
      "icrt-iot-training.test"
      "ilsag.test"
      "newprairieconstruction.test"
      "newprairiesolar.test"
      "plasmaui.test"
      "riverartsdistrict.test"
      "resource-realty.test"
      "scan-harbor.test"
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
    ];
  };

  # Android Studio
  # programs.adb.enable = true;

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
    automake
    autoconf
    alacritty
    # androidStudioPackages.dev
    arandr
    # arp-scan
    avahi
    avrdude
    bash-completion
    bat
    blueman
    bluezFull
    bluez-tools
    # cargo
    chromium
    clojure
    unstable.clojure-lsp
    clj-kondo
    cmake
    davfs2
    deja-dup
    dex # .desktop file opener
    direnv
    unstable.discord
    docker
    docker_compose
    # dpkg
    dunst
    emacsWithPackages
    # emacs
    emacs-all-the-icons-fonts
    unstable.erlangR24
    unstable.beam.packages.erlangR24.elixir
    unstable.elixir_ls
    # esptool
    exa
    feh
    filezilla
    firefox
    fish
    flameshot
    # fritzing
    gcc
    git
    # gimp
    gnumake
    gnupg
    gparted
    heroku
    htop
    inotify-tools
    insomnia
    ispell
    isync
    jdk
    jre
    libreoffice
    # libfprint
    libtool
    lsof
    lxqt.lxqt-openssh-askpass
    # maim
    mplayer
    # mumble
    my-polybar
    networkmanagerapplet
    networkmanager-l2tp
    # nmap
    nodejs
    nodePackages.javascript-typescript-langserver
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.bash-language-server
    # nodePackages.dockerfile-language-server-nodejs
    openshot-qt
    openssl
    openvpn
    pamixer
    pandoc
    paprefs
    pasystray
    pavucontrol
    picocom
    php74
    php74Packages.composer
    pkg-config
    pulseaudio
    python3
    python38Packages.pip
    # python38Packages.xdot
    rebar3
    remmina
    ripcord
    ripgrep
    # rlwrap
    rofi
    sass
    sassc
    screen
    scrot
    shutter
    unstable.signal-desktop
    simplescreenrecorder
    squashfsTools
    sqlite
    # unstable.tdlib # for telegram
    teamviewer
    # teams
    telnet
    tmux
    traceroute
    tree
    unzip
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

  # RT Kit
  # security.rtkit.enable = true;

  # Services
  services = {
    # ACPI
    acpid.enable = true;

    # Avahi mDNS Service
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        domain = true;
        addresses = true;
        userServices = true;
      };
      interfaces = ["wlp0s20f3" "enp0s31f6"];
    };

    # davfs2 for Webdav
    davfs2.enable = true;

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
    picom.vSync = true;

    # Teamviewer
    # teamviewer.enable = true;

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
        touchpad = {
          accelSpeed = "0.3";
          clickMethod = "none";
          disableWhileTyping = true;
          naturalScrolling = false;
          sendEventsMode = "disabled";
          tapping = false;
        };
      };

      # Display Manager
      displayManager = {
        sddm.enable = true;
        sddm.settings = {
          Theme = {
            Current= "minimal";
            ThemeDir= "/share/sddm/themes";
            FacesDir= "/run/current-system/sw/share/sddm/faces";
            EnableAvatars = false;
          };
        };
        session = [
          {
            manage = "window";
            name = "emacs";
            start = ''
              export VISUAL=emacsclient
              export EDITOR="$VISUAL"
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
      android-udev-rules
      avrdude
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
  users.users.jasonmj = {
    description = "Jason Johnson";
    isNormalUser = true;
    uid = 1000;
    group= "users";
    extraGroups = [ "adbusers" "bluetooth" "davfs2" "dialout" "docker" "input" "networkmanager" "wheel" ];
  };

  # User nslcd daemon (nss-pam-ldapd) to handle LDAP lookups for NSS and PAM
  users.ldap.daemon.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "21.05";
}
