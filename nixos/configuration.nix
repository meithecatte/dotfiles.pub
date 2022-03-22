{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./wifi-networks.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel modules
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  networking.hostName = "gravity";
  networking.wireless.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0f1.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.wireless.extraConfig = ''
    ctrl_interface=/run/wpa_supplicant
    ctrl_interface_group=wheel
  '';

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  fonts.fonts = with pkgs; [
    dejavu_fonts
    ipafont
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "DejaVu Sans Mono"
      "IPAGothic"
    ];
    sansSerif = [
      "DejaVu Sans"
      "IPAPGothic"
    ];
    serif = [
      "DejaVu Serif"
      "IPAPMincho"
    ];
  };

  i18n.inputMethod.enabled = "fcitx";
  i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];

  time.timeZone = "Europe/Warsaw";

  nixpkgs.config.packageOverrides = pkgs: rec {
    myNeovim = pkgs.neovim.override {
      configure = {
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [ repeat surround editorconfig-vim vim-nix vim-toml idris-vim rust-vim Coqtail ];
          opt = [ ];
        };

        customRC = builtins.readFile ../vimrc;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    file wget zip unzip tree pstree units
    tmux myNeovim unixtools.xxd
    firefox chromium keybase-gui libreoffice
    gimp audacity
    pass gnupg
    gitFull gitAndTools.delta gitAndTools.hub gitAndTools.pass-git-helper
    aerc quasselClient
    rcm zsh alacritty
    manpages
    ripgrep tokei fd bat
    mosh
    vlc
    wineWowPackages.full

    tectonic zathura watchexec

    isabelle xpra

    rustup cargo-asm cargo-expand cargo-edit gcc10 gdb strace ltrace just
    (python3.withPackages (ps: with ps; [ z3 pwntools ]))

    nix-index

    gnome3.adwaita-icon-theme
  ];

  documentation.dev.enable = true;
  services.keybase.enable = true;
  services.kbfs.enable = true;
  services.vnstat.enable = true;

  # Install tor, but don't start on boot
  services.tor.enable = true;
  systemd.services.tor.wantedBy = lib.mkForce [];

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 95;
  };

  programs.traceroute.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # nsjail needs this
  systemd.enableUnifiedCgroupHierarchy = false;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "pl";
    xkbOptions = "caps:escape";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu i3status maim
      ];
    };
  };

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      accelSpeed = "0.01";
      tapping = false;
      disableWhileTyping = true;
    };
  };

  services.redshift.enable = true;
  location.latitude = 52.;
  location.longitude = 21.;

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.bash}/bin/sh -c 'XSECURELOCK_BLANK_TIMEOUT=3 ${pkgs.xsecurelock}/bin/xsecurelock'";
    extraOptions = ["--transfer-sleep-lock"];
  };

  programs.adb.enable = true;

  users.users.kuba = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "video" "adbusers" "vboxusers" ];
  };

  security.sudo.wheelNeedsPassword = false;

  nix = {
    distributedBuilds = true;
    buildMachines = [{
      hostName = "192.168.0.50";
      maxJobs = 2;
      sshKey = "/home/kuba/.ssh/id_rsa";
      sshUser = "kuba";
      system = "x86_64-linux";
    }];
  };

  virtualisation.virtualbox.host.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

