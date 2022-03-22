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

  # Use the Zen kernel for improved system responsiveness
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Kernel modules
  boot.extraModulePackages = with config.boot.kernelPackages; [
    # OBS-as-webcam
    v4l2loopback
  ];

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
    comic-relief
  ];

  # Japanese fallback fonts
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

  # Japanese IME
  i18n.inputMethod.enabled = "fcitx";
  i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];

  time.timeZone = "Europe/Warsaw";

  nixpkgs.config.packageOverrides = pkgs: rec {
    myNeovim = pkgs.neovim.override {
      configure = {
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            repeat surround editorconfig-vim
            vim-nix vim-toml typescript-vim
            idris-vim rust-vim Coqtail
            vim-plugin-AnsiEsc
            ats-vim zig-vim
            UltiSnips
          ];
          opt = [ ];
        };

        customRC = builtins.readFile ../vimrc;
      };
    };
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    file wget zip unzip tree pstree units
    tmux myNeovim xclip unixtools.xxd
    firefox
    chromium keybase-gui libreoffice
    gimp audacity
    pass gnupg
    gitFull gitAndTools.delta gitAndTools.hub gitAndTools.pass-git-helper
    aerc quasselClient
    rcm zsh alacritty
    man-pages
    ripgrep tokei fd bat
    mosh
    vlc
    feh
    wineWowPackages.full
    borgbackup

    gimp inkscape

    tectonic zathura watchexec pandoc

    #isabelle xpra

    rustup cargo-asm cargo-expand cargo-edit cargo-release
    gcc10 gdb strace ltrace just
    (python3.withPackages (ps: with ps; [ z3 pwntools pycryptodome ]))

    nix-index

    torsocks

    gnome3.adwaita-icon-theme

    usbutils pciutils
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

  # Use pipewire over pulseaudio for high quality microphone audio over Bluetooth.
  sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [ { "device.name" = "~bluez_card.*"; } ];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
    ];
  };


  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;
  services.blueman.enable = true;

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

  # YOLO
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

