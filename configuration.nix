{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz;
  unstable = import unstableTarball { config = config.nixpkgs.config; };
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
    arandr
    arp-scan
    avahi
    avrdude
    awscli2
    bash-completion
    bat
    brave
    chromium
    clojure
    clojure-lsp
    cmake
    curl
    davfs2
    deadd-notification-center
    delta
    deja-dup
    dex # .desktop file opener
    direnv
    docker
    docker-compose
    electron
    (emacsWithPackagesFromUsePackage {
      config = /home/jasonmj/.emacs.d/init.el;
      package = (pkgs.emacsNativeComp.override { withXwidgets = true; });
      alwaysEnsure = true;
      alwaysTangle = true;
      extraEmacsPackages = epkgs: [
        epkgs.pdf-tools
        epkgs.vterm
      ];
      override = epkgs: epkgs // {
        tree-sitter-langs = epkgs.tree-sitter-langs.withPlugins(
          grammars: builtins.filter lib.isDerivation (lib.attrValues grammars)
        );
      };
    })
    emacs-all-the-icons-fonts
    unstable.erlangR25
    unstable.beam.packages.erlangR25.elixir
    unstable.elixir_ls
    exa
    file
    firefox
    fish
    flameshot
    gcc
    gh
    git
    gnumake
    gnupg
    gtk3-x11
    htop
    inotify-tools
    ispell
    jdk
    jre
    jq
    libreoffice
    libtool
    lsof
    mlocate
    mplayer
    networkmanagerapplet
    # networkmanager-l2tp
    nmap
    nodejs
    nodePackages.javascript-typescript-langserver
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.bash-language-server
    obsidian
    openssl
    # openvpn
    pamixer
    pandoc
    pavucontrol
    postman
    pulseaudio
    python3
    rebar3
    remmina
    ripgrep
    screen
    scrot
    shutter
    unstable.signal-desktop
    simplescreenrecorder
    slack
    sqlite
    tig
    traceroute
    tree
    unzip
    usbutils
    vim
    vscodium
    wayland
    wget
    whois
    xbanish
    xbindkeys xbindkeys-config xdotool
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
      allowedTCPPorts = [ 8000 9630 ];
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
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      }))
    ];
  };

  services = {
    acpid.enable = true;

    avahi = {
      enable = true;
      nssmdns = true;
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

    postgresql = let mypg = pkgs.postgresql_13; in {
      enable = true;
      package = mypg;
      authentication = pkgs.lib.mkForce ''
      # TYPE	DATABASE	USER	ADDRESS		METHOD
      local	all		all			trust
      host	all		all	127.0.0.1/32	trust
      host	all		all	::1/128		trust
      '';
      extraPlugins = with mypg.pkgs; [ pkgs.postgresql13Packages.postgis ];
    };

    resolved = {
      enable = true;
      fallbackDns = ["8.8.8.8" "2001:4860:4860::8844"];
    };

    xl2tpd.enable = true;

    xserver = {
      enable = true;

      # Display
      dpi = 120;

      # Keyboard
      autoRepeatDelay = 150;
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
            name = "exwm";
            start = ''
              export VISUAL=emacsclient
              export EDITOR="$VISUAL"
              exec dbus-launch --exit-with-session ${pkgs.emacs}/bin/emacs-28.1 -mm
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
      avrdude
      libmtp.bin
      yubikey-personalization
    ];
  };

  sound.enable = true;

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

  system.nssDatabases.hosts = [ "impression" "nerves" "pitimer" "01232cc90a32da9eee" ];
  system.stateVersion = "22.05";
}
