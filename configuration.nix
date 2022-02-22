{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz;
  unstable = import unstableTarball { config = config.nixpkgs.config; };
  emacsWithPackages = (unstable.emacsPackagesGen unstable.emacs).emacsWithPackages
    (epkgs: ([epkgs.pdf-tools]));
in

{
  imports = [./hardware-configuration.nix];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  environment.systemPackages = with pkgs; [
    automake
    autoconf
    alacritty
    androidStudioPackages.dev
    arandr
    arp-scan
    avahi
    avrdude
    aws
    bash-completion
    bat
    blueman
    bluezFull
    bluez-tools
    cargo
    chromium
    clojure
    clojure-lsp
    clj-kondo
    cmake
    davfs2
    deja-dup
    dex # .desktop file opener
    direnv
    unstable.discord
    docker
    docker_compose
    dunst
    # emacsWithPackages
    emacs
    emacs-all-the-icons-fonts
    unstable.erlangR24
    unstable.beam.packages.erlangR24.elixir
    unstable.elixir_ls
    # esptool
    etcher
    exa
    feh
    file
    filezilla
    firefox
    fish
    flameshot
    fritzing
    fwup
    gcc
    gdb
    git
    gnome.dconf-editor
    gnumake
    gnupg
    gparted
    heroku
    hicolor-icon-theme
    htop
    inotify-tools
    insomnia
    ispell
    isync
    jdk
    jre
    libreoffice
    libtool
    lsof
    lxqt.lxqt-openssh-askpass
    mlocate
    mopidy-spotify
    mpd
    mplayer
    mumble
    p7zip
    my-polybar
    networkmanagerapplet
    networkmanager-l2tp
    nmap
    nodejs
    nodePackages.javascript-typescript-langserver
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.bash-language-server
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
    rebar3
    remmina
    ripcord
    ripgrep
    rofi
    sass
    sassc
    screen
    scrot
    shutter
    unstable.signal-desktop
    sierra-gtk-theme
    simplescreenrecorder
    squashfsTools
    sqlite
    unstable.tdlib # for telegram
    teamviewer
    teams
    telnet
    tmux
    traceroute
    tree
    universal-ctags
    unzip
    vim
    vscodium
    watchman
    wget
    whois
    wordnet
    xbanish
    xbindkeys xbindkeys-config xdotool
    xfce.xfce4-settings
    xl2tpd
    xorg.xbacklight xorg.xev xorg.xmodmap
    yarn
    yubikey-manager
    yubikey-personalization
    zip
    zoom-us
  ];

  location = {
    latitude = 35.849549;
    longitude = -82.738750;
  };

  nix = {
    gc = { # Garbage Collection
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
    };
    trustedUsers = [ "root" "jasonmj" ];
  };

  networking = {
    firewall = {
      enable = false;
      allowedTCPPorts = [ 8000 9630 19000 19001 19002 19003 ];
    };
    hosts = {
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
    hostName = "nixos";
    networkmanager.enable = true;
  };

  fonts = {
    fontconfig.dpi = 120;
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      iosevka
    ];
  };

  programs = {
    dconf.enable = true;
    slock.enable = true;
    ssh.startAgent = false; # use gpg-agent instead
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "emacs";
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import unstableTarball {
          config = config.nixpkgs.config;
        };
      };
    };
    overlays = [
      (self: super: {
        my-polybar = super.polybar.override {
          pulseSupport = true;
        };
      })
    ];
  };

  services = {
    acpid.enable = true;

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

    davfs2.enable = true;

    fwupd.enable = true;

    # Locate Config
    locate = {
      enable = true;
      interval = "minutely";
      pruneNames = [
        "_build"
        "node_modules"
      ];
      prunePaths = [
        "/tmp"
        "/var/tmp"
        "/var/cache"
        "/var/lock"
        "/var/run"
        "/var/spool"
        "/nix/store"
        "/nix/var/log/nix"
        "/home/jasonmj/.android"
        "/home/jasonmj/.npm"
        "/home/jasonmj/.npm-packages"
        "/home/jasonmj/.nerves"
        "/home/jasonmj/.cache"
        "/home/jasonmj/.hex"
        "/home/jasonmj/virtualbox"
        "/home/jasonmj/"
      ];
    };

    logind = {
      extraConfig = "
        HandlePowerKey=suspend
        HandleSuspendKey=suspend
        HandleHibernateKey=suspend
        IdleAction=ignore
      ";
      lidSwitch = "ignore";
    };

    # mopidy = {
    #   enable = true;
    #   extensionPackages = [
    #     pkgs.mopidy-iris
    #     pkgs.mopidy-spotify
    #   ];
    #   extraConfigFiles = [ "/share/mopidy/mopidy.conf" ];
    # };

    picom = {
      enable = true;
      vSync = true;
    };

    xl2tpd.enable = true;

    xserver = {
      enable = true;

      # Keyboard
      autoRepeatDelay = 130;
      autoRepeatInterval = 12;
      layout = "us";

      # Add Option "DontVTSwitch" "True" to Prevent switching ttys
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

  sound.enable = true;

  systemd.network.networks.wlp0s20f3.networkConfig.MulticastDNS = true;

  time.timeZone = "America/New_York";

  # Define Users and Groups
  users.users.jasonmj = {
    description = "Jason Johnson";
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [ "adbusers" "bluetooth" "davfs2" "dialout" "docker" "input" "mlocate" "networkmanager" "wheel" ];
  };

  # User nslcd daemon (nss-pam-ldapd) to handle LDAP lookups for NSS and PAM
  users.ldap.daemon.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "21.11";
}
