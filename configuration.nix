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
    alacritty
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    arandr
    # arp-scan
    # avahi
    brightnessctl
    clipcat
    chromium
    curl
    delta
    # deja-dup
    # dex # .desktop file opener
    direnv
    # docker
    # docker-compose
    # dropbox-cli
    emacs-all-the-icons-fonts
    emacs-lsp-booster
    unstable.emacs
    unstable.erlang
    unstable.elixir
    unstable.elixir_ls
    # eza
    unstable.firefox
    fish
    fswatch
    gcc
    git
    gnumake
    gnupg
    haskellPackages.greenclip
    htop
    kanata
    # multipass
    nodejs
    nodePackages.bash-language-server
    # nodePackages.pyright
    # openocd
    # openshot-qt
    openssl
    parcellite
    pamixer
    # pandoc
    pavucontrol
    pulseaudio
    python311
    # python311Packages.grip
    ripgrep
    rofi
    screen
    screenkey
    shutter
    # simplescreenrecorder
    sqlite
    sxhkd
    # traceroute
    unzip
    vim
    wget
    whois
    # xbanish
    xkeysnail
    xbindkeys xbindkeys-config
    xdotool
    xob
    xorg.xmodmap
    zip
    zoom-us
  ];

  environment.etc."links/vterm".source = "${unstable.emacs.pkgs.vterm}/share/emacs/site-lisp/elpa";

  location = {
    latitude = 44.4259;
    longitude = 69.0064;
  };

  nix = {
    gc = { # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      trusted-users = [ "root"
      "jasonmj" ];
    };
  };

  networking = {
    firewall.enable = true;
    hostName = "nixos";
    networkmanager.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      google-fonts
      iosevka
      (nerdfonts.override { fonts = [ "FiraCode"
      "Iosevka"]; })
    ];
  };

  programs = {
    # adb.enable = true;
    gnupg.agent.pinentryPackage = pkgs.pinentry-emacs;
    light.enable = true;
    # nix-ld.enable = true;
    slock.enable = true;
    ssh.startAgent = false; # use gpg-agent instead
    sway.enable = true;
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
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    emacs = {
      enable = true;
      package = unstable.emacs;
    };

    fwupd.enable = true;

    logind = {
      extraConfig = "
        HandlePowerKey=suspend
        HandleSuspendKey=suspend
        HandleHibernateKey=suspend
        IdleAction=ignore
      ";
      # lidSwitch = "ignore";
    };

    picom = {
      enable = true;
      vSync = true;
    };

    pipewire.extraConfig.pipewire."99-silent-bell.conf" = {
      "context.properties" = {
        "module.x11.bell" = false;
      };
    };

    resolved = {
      enable = true;
      fallbackDns = ["8.8.8.8"];
    };

    # Touchpad support
    libinput = {
      enable = true;
      touchpad = {
        accelSpeed = "0.45";
        # clickMethod = "none";
        # disableWhileTyping = true;
        naturalScrolling = true;
        # sendEventsMode = "disabled";
        # tapping = false;
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
    };

    # xl2tpd.enable = true;

    xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      windowManager.exwm.enable = true;
      windowManager.bspwm.enable = true;
      windowManager.bspwm.configFile = "/home/jasonmj/.config/bspwm/bspwmrc";
      windowManager.bspwm.sxhkd.configFile = "/home/jasonmj/.config/sxhkd/sxhkdrc";

      # Display
      dpi = 78;

      # Keyboard
      autoRepeatDelay = 150;
      autoRepeatInterval = 11;
      xkb.layout = "us";

      # Add Option "DontVTSwitch"
      # "True" to Prevent switching ttys
      # config = ''
      #   Section "ServerFlags"
      #     Option "DontZap"      "True"
      #     Option "BlankTime"    "0"
      #     Option "StandbyTime"  "0"
      #     Option "SuspendTime"  "0"
      #     Option "OffTime"      "0"
      #   EndSection
      # '';
    };

    # redshift.enable = true;

    # Enable pcscd for smartcard support
    # pcscd.enable = true;

    # UDEV
    udev = {
      packages = with pkgs; [
        #   avrdude
        #   vial
      ];
    };
  };

  time.timeZone = "America/New_York";

  # Define Users and Groups
  # users.extraGroups.vboxusers.members = [ "jasonmj" ];
  users.users.jasonmj = {
    description = "Jason Johnson";
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [
      # "adbusers"
      # "bluetooth"
      # "dialout"
      # "docker"
      # "input"
      # "mlocate"
      "networkmanager"
      "wheel"
    ];
  };

  # User nslcd daemon (nss-pam-ldapd) to handle LDAP lookups for NSS and PAM
  # users.ldap.daemon.enable = true;

  # virtualisation = {
  # docker.enable = true;
  # multipass.enable = true;
  # virtualbox.host = {
  #   enable = true;
  #   enableExtensionPack = true;
  # };
  # };

  # !CAUTION!
  # Allows users in group "wheel" to execute sudo commands
  security.sudo.wheelNeedsPassword = false;

  # system.nssDatabases.hosts = [ "nerves" ];
  system.stateVersion = "24.11";
}
