# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # custom additions to bootloader
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [ "button.lid_init_state=open" ]; # supposedly fixes something, idk what but better safe than sorry
  networking.hostName = "theDevil"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Sleepytime
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=120min
  '';
  services.logind.lidSwitch = "ignore"; # she can't wake up from this --> "suspend-then-hibernate";
  # Fix logrotate bug
  systemd.services.logrotate-checkconf.serviceConfig.SuccessExitStatus = 1;

  # NVIDIA shit

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
  };

  # load intel drivers for igpu for moar (battery) powah
  services.xserver.videoDrivers = ["modesetting"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true; # apparently good on post 20 series cards 
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  # WM shit / login logic / autistic touchpad settings
  services.xserver = {
    enable = true;
    libinput.enable = false; # disable libinput if you’re using synaptics
    synaptics = {
      enable = true;
      twoFingerScroll = true;
      vertEdgeScroll = false;
      horizEdgeScroll = false;
      tapButtons = false;
      palmDetect = true;
      # You can add more options via:
      additionalOptions = ''
        Option "TapButton1" "1"  # One-finger tap = left click
        Option "TapButton2" "3"  # Two-finger tap = right click
        Option "TapButton3" "2"  # Three-finger tap = middle click
        Option "TapAction" "0 0 0 0 1 3 2"
        Option "ClickAction" "1 3 2"
        Option "AreaLeftEdge" "600"
        Option "AreaRightEdge" "3200"
        Option "MinSpeed" "3.0"
        Option "MaxSpeed" "3.0"
        Option "AccelFactor" "0.0" # fuck you, fuck you, DEFINITELY fuck you
      '';
    };
  
  desktopManager.xterm.enable = false;
  displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3lock
        i3status
        polybar
        feh
      ];
    };
  };
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;
    };
  };



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.skep = {
    isNormalUser = true;
    description = "skep";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    curl
    wget
    fastfetch    
    kitty
    librewolf
    firefox
    btop
    nvtop
 
    powertop # battery level stuff
    brightnessctl # i wonder what this does
    maim # screenshot shit
    xclip # to copy said screenshot
    bc # some formatting shit for vcheck script
    #tlp # battery shit # instated in config now
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
