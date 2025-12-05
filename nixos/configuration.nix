# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # noatime: Prevents the system from writing the access time to files every time they are read. Reduces write amplification on the SSD.
  # discard: Enables continuous TRIM. This tells the SSD when blocks are free, allowing it to manage its storage efficiently.
  fileSystems."/" = {
    options = ["noatime"];
  };
  services.fstrim.enable = true; # recommended instead of the "discard" mount option on ext4 (runs weekly by default)
  services.fstrim.interval = "weekly";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Basic FIFO queue for I/O scheduling supposedly works well with SSDs
  boot.kernelParams = ["elevator=noop"];

  # Keep max 10 NixOS generations
  boot.loader.systemd-boot.configurationLimit = 10;

  # Allow cross compiling raspberry pi images
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  networking.hostName = "neo"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.interfaces.enp5s0.wakeOnLan = {
    enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.xpadneo.enable = true; # xbox controller
  #boot.blacklistedKernelModules = [ "xpad" "xpad_noone" ];
  #hardware.xone.enable = true; # xbox controller

  # GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    # extraPackages = with pkgs; [
    #   amdvlk
    #   mesa # RADV
    # ];
    #
    # extraPackages32 = with pkgs; [
    #   driversi686Linux.amdvlk
    #   driversi686Linux.mesa
    # ];
  };

  # nfs
  boot.supportedFilesystems = ["nfs"];
  services.rpcbind.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [pkgs.brlaser];

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL_L2445DW";
        deviceUri = "dnssd://Brother%20HL-L2445DW._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-94ddf876b721";
        model = "everywhere";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "Brother_HL_L2445DW";
  };

  # network printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.davfs2.enable = true;
  services.davfs2.settings = {
    globalSection = {
      # https://github.com/alisarctl/davfs2/issues/22
      buf_size = 64;
    };
  };
  environment.etc."davfs2/secrets" = {
    text = ''
      # WebDAV credentials
      # Format: <mount_point> <username> <password>
      /mnt/tailscale "" ""
    '';
    mode = "0600";
  };
  systemd.tmpfiles.rules = [
    "d /mnt/tailscale 0755 root root -"
    "d /mnt/ds9backupcloud 0755 root root -"
    "d /mnt/ds9backuplocal 0755 root root -"
  ];
  systemd.mounts = [
    {
      where = "/mnt/tailscale";
      what = "http://100.100.100.100:8080";
      type = "davfs";
      options = "rw";
      # ensure tailscale is running before mounting
      requires = ["tailscaled.service"];
      after = ["tailscaled.service"];
    }
    {
      where = "/mnt/ds9backupcloud";
      what = "ds9:/volume1/backupcloud";
      type = "nfs";
      options = "nolock,vers=3";
      requires = ["tailscaled.service"];
      after = ["tailscaled.service"];
    }
    {
      where = "/mnt/ds9backuplocal";
      what = "ds9:/volume1/backuplocal";
      type = "nfs";
      options = "nolock,vers=3";
      requires = ["tailscaled.service"];
      after = ["tailscaled.service"];
    }
  ];
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          (action.lookup("unit") == "mnt-tailscale.mount" ||
           action.lookup("unit") == "mnt-ds9backupcloud.mount" ||
           action.lookup("unit") == "mnt-ds9backuplocal.mount") &&
          subject.isInGroup("users")) {
        return polkit.Result.YES;
      }
    });
  '';

  # GPU monitoring tools
  environment.systemPackages = with pkgs; [
    git # ensure git is available for nix flakes

    amdgpu_top
    lm_sensors # Temperature sensors
    libva-utils # For vainfo
    vdpauinfo # For vdpauinfo
    vulkan-tools # For vulkaninfo
    mesa-demos # For glxinfo
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    rocmPackages.rocm-smi
    btop-rocm

    lutris
    wineWowPackages.stableFull
    winetricks
    gamescope

    xsel
    xorg.xlsclients
    xorg.xwininfo
    xorg.xeyes

    playerctl # play/pause media controls

    usbutils
    pciutils

    wl-clipboard
    xdg-utils # xdg-open
    #fuzzel
    #mako
    #waybar
    xwayland-satellite
    pantheon.pantheon-agent-polkit # test by running `pkexec whoami`

    pkgs-unstable.wl-kbptr
    wlrctl

    #x11_ssh_askpass

    #blueman

    door-knocker # test app for xdg portals
    ashpd-demo # test app for xdg portals

    guvcview # test webcam
    pkgs-unstable.wiremix
    pkgs-unstable.mission-center

    man-pages
    man-pages-posix

    nfs-utils
  ];

  # programs.nix-ld = {
  #   enable = true;
  #   libraries = with pkgs; [
  #     xorg.libX11
  #     libGL
  #   ];
  # };

  # Start when uwsm / niri start
  #systemd.user.services.mako.wantedBy = ["graphical-session.target"];
  #systemd.user.services.waybar.wantedBy = ["graphical-session.target"];
  #systemd.user.services.xwayland-satellite.wantedBy = ["graphical-session.target"];

  # Enable hardware sensors
  # hardware.sensor.hddtemp.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  fonts.fontconfig = {
    useEmbeddedBitmaps = true; # fix emoji in firefox
    enable = true;
    defaultFonts = {
      serif = ["DejaVu Serif" "Symbols Nerd Font"];
      sansSerif = ["DejaVu Sans" "Symbols Nerd Font"];
      monospace = ["JetBrainsMonoNL Nerd Font Mono"];
      emoji = ["Noto Color Emoji"];
    };
    #antialias = true;
    # hinting = {
    #   enable = true;
    #   style = "full";
    #   autohint = false;
    # };
    # subpixel = {
    #   rgba = "none";
    #   lcdfilter = "default";
    # };
  };

  #fonts.fontconfig.useEmbeddedBitmaps = true;
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono

    julia-mono
    liberation_ttf
    ibm-plex
    iosevka
    maple-mono.truetype

    font-awesome # used in waybar defaults
  ]; #++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  #services.xserver.enable = true;
  #services.xserver.enable = true; # to enable the xorg server
  #services.xserver.videoDrivers = [ "amdgpu" ]; # to load the amdgpu kernel module
  #services.xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.wayland.enable = true;
  #services.desktopManager.plasma6.enable = true;

  services.displayManager.cosmic-greeter = {
    enable = true;
  };
  services.desktopManager.cosmic = {
    enable = true;
  };

  # use unstable packages for cosmic
  # nixpkgs.overlays = [
  #   (
  #     final: prev:
  #       lib.filterAttrs
  #       (
  #         name: _:
  #           lib.hasPrefix "cosmic-" name
  #           || lib.hasPrefix "pop-" name
  #           || name == "xdg-desktop-portal-cosmic"
  #       )
  #       pkgs-unstable
  #   )
  # ];

  security.polkit.enable = true;

  # programs.niri.enable = true;
  #
  # programs.uwsm = {
  #   enable = true;
  #   waylandCompositors.niri = {
  #     prettyName = "Niri";
  #     comment = "Niri compositor managed by UWSM";
  #     # Writing a shell script to add the CLI flag
  #     binPath = pkgs.writeShellScript "niri-uwsm-bin" ''
  #       ${lib.getExe config.programs.niri.package} --session
  #     '';
  #   };
  # };

  # services.gnome.gnome-keyring.enable = true;
  # services.greetd = {
  #   enable = true;
  #   settings = rec {
  #     initial_session = {
  #       command = "${lib.getExe config.programs.uwsm.package} start niri-uwsm.desktop";
  #       user = "robbiev";
  #     };
  #     default_session = initial_session;
  #   };
  # };

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  #services.tailscale.extraSetFlags = [ "--advertise-exit-node" "--ssh" ];

  # YubiKey
  services.pcscd.enable = true;
  services.yubikey-agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;

  # Prevent pcscd from auto-exiting to maintain YubiKey PIN session
  systemd.services.pcscd = {
    serviceConfig = {
      # Override to remove --auto-exit / -x flag
      ExecStart = lib.mkForce [
        "" # Clear previous setting
        "${pkgs.pcsclite}/bin/pcscd -f"
      ];
    };
  };

  # To properly link xdg-desktop-portal definitions and configurations in
  # NixOS, you need to add /share/xdg-desktop-portal and /share/applications to
  # environment.pathsToLink in your configuration.nix if you are using
  # useUserPackages = true in Home Manager
  # See https://github.com/nix-community/home-manager/blob/7c35504839f915abec86a96435b881ead7eb6a2b/modules/misc/xdg-portal.nix#L26
  #
  # environment.pathsToLink = [
  #   "/share/xdg-desktop-portal"
  #   "/share/applications"
  # ];

  # xdg.portal = {
  #   enable = true;
  #   xdgOpenUsePortal = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-gnome
  #     pkgs.xdg-desktop-portal-gtk
  #   ];
  #
  #   #
  #   config = {
  #     # override defaults at /run/current-system/sw/share/xdg-desktop-portal/*
  #     # with new files in /etc/xdg/xdg-desktop-portal/*
  #     #
  #     # replicate niri defaults
  #     niri."org.freedesktop.impl.portal.Access" = "gtk";
  #     niri."org.freedesktop.impl.portal.Notification" = "gtk";
  #     niri."org.freedesktop.impl.portal.Secret" = "gnome-keyring";
  #     # override niri default
  #     niri.default = "gnome"; # from gnome,gtk
  #     niri."org.freedesktop.impl.portal.FileChooser" = "gtk"; # from gnome,gtk (the default)
  #     # common.default = "gnome,gtk";
  #     # obs.default = "gnome";
  #   };
  # };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  boot.initrd.kernelModules = ["amdgpu"];
  #services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable libinput support for modern input handling
  services.libinput = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.fish.enable = true;
  users.users.robbiev = {
    isNormalUser = true;
    description = "Robbie Vanbrabant";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
  };

  environment.sessionVariables = {
    # Force hardware acceleration
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";

    # Mesa variables
    AMD_VULKAN_ICD = "RADV"; # as opposed to AMDVLK
    #VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";

    #SSH_ASKPASS = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
  };

  # Enable automatic login for the user.
  #services.displayManager.autoLogin.enable = true;
  #services.displayManager.autoLogin.user = "robbiev";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true;

  # Doesn't play nice with flakes so disable for now
  programs.command-not-found.enable = false;

  documentation.dev.enable = true;

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

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Delete unused things from the nix store
  nix.gc = {
    automatic = true;
    dates = "weekly"; # Or "daily"
    options = "--delete-older-than 30d"; # Keep generations for 30 days
  };

  # Optimise nix store disk usage store automatically
  nix.optimise.automatic = false;

  nix.extraOptions = ''
    warn-dirty = false
  '';

  # Disable systemd-coredump
  # Use ulimit or gcore
  systemd.coredump.enable = false;
  boot.kernel.sysctl."kernel.core_pattern" = "|/bin/false";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
