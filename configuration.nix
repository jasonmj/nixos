{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz;
  unstable = import unstableTarball { config = config.nixpkgs.config; };
  emacsWithPackages = (unstable.emacsPackagesFor unstable.emacs).emacsWithPackages
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
    # androidStudioPackages.dev
    arandr
    arp-scan
    avahi
    avrdude
    awscli2
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
    curl
    davfs2
    delta
    deja-dup
    dex # .desktop file opener
    direnv
    unstable.discord
    docker
    docker-compose
    dunst
    emacsWithPackages
    # emacs
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
    inetutils
    inotify-tools
    insomnia
    ispell
    isync
    jdk
    jre
    jq
    libreoffice
    libtool
    lsof
    lxqt.lxqt-openssh-askpass
    mlocate
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
    unstable.qmk
    rebar3
    remmina
    remote-touchpad
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
    # teams
    terraform_0_13
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
        "cannabusiness.test"
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
    # fontconfig.dpi = 120;
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      iosevka
      # nerdfonts
    ];
  };

  programs = {
    adb.enable = true;
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
      permittedInsecurePackages = ["electron-12.2.3"];
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
      interval = "hourly";
      localuser = null;
      locate = pkgs.mlocate;
      pruneNames = [
        ".config"
        ".emacs.d"
        "_build"
        "node_modules"
        "postgres-data"
      ];
      prunePaths = [
        "/bin"
        "/boot"
        "/dev"
        "/etc"
        "/home/davfs2"
        "/home/jasonmj/.android"
        "/home/jasonmj/.emacs.d"
        "/home/jasonmj/.local"
        "/home/jasonmj/.mozilla"
        "/home/jasonmj/.npm"
        "/home/jasonmj/.npm-packages"
        "/home/jasonmj/.nerves"
        "/home/jasonmj/.cache"
        "/home/jasonmj/.hex"
        "/home/jasonmj/org"
        "/home/jasonmj/virtualbox"
        "/mnt"
        "/opt"
        "/proc"
        "/nix"
        "/root"
        "/share"
        "/sys"
        "/tmp"
        "/usr"
        "/var"
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

    picom = {
      enable = true;
      vSync = true;
    };

    teamviewer.enable = true;

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
      # android-udev-rules
      avrdude
      libmtp.bin
      yubikey-personalization
    ];
  };

  sound.enable = true;

  systemd.network.networks.wlp0s20f3.networkConfig.MulticastDNS = true;

  time.timeZone = "America/New_York";

  # Define Users and Groups
  users.groups.mlocate = {};
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

  system.stateVersion = "22.05";
}
