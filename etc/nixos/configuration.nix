# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  zen-browser = import ./zen-browser.nix { inherit pkgs; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Overkill firewall :3
      ./firewall.nix
    ];


  #===================[ Packages & Apps ]===================

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;





  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    zen-browser

    # actual apps i use:
    fastfetch    
    kitty
    tor-browser
    librewolf
    firefox
    chromium
    baobab
    neofetch
    wofi # rofi alternative for wayland    
    swaybg # wallpaper setter for wayland


    # security apps i use:
    openvpn
    wireshark
    burpsuite
    ffuf # fuzz faster u fool, burpsuite companion basically but FOSS

    # misc/debugging/dependency stuff

    
    #==== screenshots
    grim
    slurp
    wl-clipboard
    #==== END screenshots
    gammastep # redshift alternative
    
    waybar # polybar alternative for wayland/hyprland
    intel-gpu-tools # for intel_gpu_top
    undervolt # undervolt
    s-tui # detailed CPU load viewer
    stress # stresstester
    pulseaudio # for audio controls    
    btop # general resource viewer
    nvtopPackages.full # GPU usage viewer
    git # if you don't know what this is, git outta here
    curl # you know what this is
    wget # this too
    powertop # battery usage analyzer
    brightnessctl # i wonder what this does
    bc # some formatting shit for vcheck script
  ];


  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # stealth option, enable for everyday usability
    dedicatedServer.openFirewall = false; # stealth option, enable for everyday usability
    localNetworkGameTransfers.openFirewall = false; # stealth option, enable for everyday usability
  };


  # Fix logrotate bug
  systemd.services.logrotate-checkconf.serviceConfig.SuccessExitStatus = 1;

  

  #===================[ Boot & Drives ]===================


 services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=sleep
  '';


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # custom additions to bootloader
  boot.kernelPackages = pkgs.linuxPackages_zen; # linux-zen rather than standard, slightly more lightweight kernel. battery life difference not measured but i also just prefer zen.
  boot.kernelParams = [ 
  "button.lid_init_state=open"
   ]; # supposedly fixes hybrid wake up on the razer blade 15 NON-ADVANCED

  # LUKS LVM encrypted mounting process
  # Skip if you aren't encrypting your drive
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  #===================[ VM's ]=================

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["skep"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;


  #===================[ Basic Networking ]===================

  # networking
  networking.hostName = "theDevil"; # Define your hostname.
  networking.usePredictableInterfaceNames = false; # i love predictable interface names i wanna type sudo ip link set wlp91s0d4a9p4m2k3ifosjef93qgh839qfh4f up

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true; # enable NetworkManager, connect to wifi via `nmtui`
  networking.networkmanager.wifi.macAddress = "random"; # randomize MAC address to prevent LAN tracking/fingerprinting. no real consequences.
  # TODO: wpa_supplicant.service is also running, and networking.wireless.enable = false; doesn't get rid of it. Figure out if this is problematic at all.
  


  #===================[ Locales ]===================

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



  #===================[ Graphics Drivers ]===================


  # Enable OpenGL (now called graphics
  hardware.graphics = {
    enable = true;
  };

  # load intel drivers for igpu for moar (battery) powah # plus nvidia for ollama
  services.xserver.videoDrivers = [ "modesetting" ]; # modesetting for igpu

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


  #===================[ DE & Trackpad ]===================

  
  services.displayManager.defaultSession = "hyprland";

  services.libinput.enable = false; # disable libinput since synaptics is used instead
  services.xserver = {
    enable = true;
    synaptics = {
      enable = true;
      twoFingerScroll = true;
      vertEdgeScroll = false;
      horizEdgeScroll = false;
      tapButtons = true;
      palmDetect = false;
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
	Option "PalmDetect" "0"
      '';
    };

# i3WM:   
  desktopManager.xterm.enable = false;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi # launch menu
        i3lock # lock screen i think? forgor
        i3status # status bar
        polybar # status bar but cooler
        feh # wallpaper
        maim # screenshot shit
        xclip # to copy said screenshot

      ];
    };
  };

# Hyprland:
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # uncomment once fully on hyprland, hint electron apps to use wayland

  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts-cjk-sans # for japanese text, optional
  ];
  
  #===================[ Local LLM stuff ]============
  services.ollama = {
    enable = true;
    loadModels = [ "qwen2.5-coder:7b" "deepseek-coder:6.7b" "starcoder2:15b" "deepseek-coder-v2:16b" "dolphin-mistral:7b" "deepseek-r1:8b" ];
    acceleration = "cuda";
  };
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.latest ];
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  #===================[ Audio ]===================

  hardware.pulseaudio.enable = false; # disable pulseaudio since pipewire is used instead
  security.rtkit.enable = true; # forgot what this does
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  #===================[ Battery Optimization ]===================

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
      
      # Optional long-term battery wear avoidance
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80; # Change to 100 or comment out if you need your full battery
      # ^-- this doesn't work kek
    };
  };

  # Sleepytime
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=45min
  '';
  services.logind.lidSwitch = "suspend-then-hibernate"; # she can't wake up from this --> "suspend-then-hibernate";
                                                        # ^-- haha just kidding
                                                        # somewhere down the line it just started working


  #===================[ User(s) and Security ]===================

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.skep = {
    isNormalUser = true;
    description = "skep";
    extraGroups = [ "networkmanager" "wheel" "undervolt" "iptables" "ip6tables" ]; # keep undervolt so i3 scripts can execute undervolt checks
    packages = with pkgs; [];
  };

  # Security
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=1 # sudo session timeout (in minutes)
  '';

  # Ensure uvolt, rstvolt, & uvcheck can be ran without a password
  # FOR SECURITY REASONS YOU MUST RUN THESE COMMANDS BEFORE USING POLYBAR WITH UNDERVOLT MODULES:
  # `sudo chown root:root ~/Scripts/uvolt.sh ~/Scripts/rstvolt.sh ~/Scripts/uvcheck.sh`
  # `sudo chmod 755 ~/Scripts/uvolt.sh ~/Scripts/rstvolt.sh ~/Scripts/uvcheck.sh`
  # What/why?
  # These lines change the owner of those scripts to root, and make them readable and executable by you
  #  but not writeable. To write to these scripts you must use `sudo nano ~/Scripts/whatever.sh`
  #   this is necessary because otherwise, anyone in your session can edit that file to execute whatever
  #    scripts they want with sudo. Call it paranoia but better safe than not.
  security.sudo.extraRules = [
  {
    users = [ "skep" ]; # Did you read the comment? --^
    commands = [
      {
        command = "/home/skep/Scripts/uvolt.sh";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/home/skep/Scripts/rstvolt.sh";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/home/skep/Scripts/uvcheck.sh";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/home/skep/Scripts/check-icmp.sh";
        options = [ "NOPASSWD" ];
      }

    ];
  }
];


  #===================[ Security & Firewall (ipv4) ]===================

  # FIREWALL DEFINED IN /etc/nixos/firewall.nix

# kernel network safety tweaks
boot.kernel.sysctl = {
  #‑‑‑ anti‑spoof & silent tweaks ‑‑‑
  "net.ipv4.conf.all.rp_filter"        = "1";  # reverse‑path filter
  "net.ipv4.conf.default.rp_filter"    = "1";

  "net.ipv4.icmp_echo_ignore_broadcasts" = "1";  # ignore smurf/broadcast pings

  "net.ipv4.conf.all.accept_redirects" = "0";  # don’t accept ICMP redirects. may break connection on some networks.
  "net.ipv4.conf.all.send_redirects"   = "0";  # don’t send them either
};


# badusb prevention, because i have asshole friends ;P
services.usbguard = {
  enable = true;
  # will default to block unknown devices
  implicitPolicyTarget = "block";  # getthafookouttahereeee
  rules = ''
    allow id 1532:0276  # internal razer keyboard (which, fun fact, is recognized as a USB device btw lol
  '';
};
# COMMENT THIS OUT IF YOU ARE NOT USING A RAZER BLADE 15 ADVANCED!!!! UNTESTED WITH NON-ADVANCED MODEL.
# YOU **WILL** LOCK YOURSELF OUT!!!





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





  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
