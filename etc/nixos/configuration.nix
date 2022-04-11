# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.trustedUsers = [ "root" "ron" ];

  nix = {
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix.nix
    ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/EFI";
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    cryptoroot = {
      preLVM = true;
      allowDiscards = true;
      device = "/dev/disk/by-uuid/a71c0266-125e-4e82-8686-a7213505b2be";
    };
  };

  powerManagement.cpuFreqGovernor = "performance";

  # networking.hostName = "nixos"; # Define your hostname.
  networking.wireless = {
    enable = true;  # Enables wireless support via wpa_supplicant.
    interfaces = [ "wlp3s0" ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak-programmer";  # 21.05 change
  };
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  services.haveged.enable = true;

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 21 ];
  # networking.firewall.allowedTCPPortRanges = [ { from = 51000; to = 51999; } ];

  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support.
  services.xserver = {
    enable = true;

    libinput.enable = true;

    layout = "us";
    xkbVariant = "dvp";
    xkbOptions = "compose:ralt";

    displayManager = {
      lightdm = {
        enable = true;
      };
      defaultSession = "xfce+i3";
    };

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

    windowManager = {
      i3 = {
        enable = true;
        extraPackages = [
          pkgs.dmenu
          pkgs.i3status
        ];
      };
    };
  };

  services.dictd = {
    enable = true;
  };

  virtualisation.virtualbox.host.enable = true;

  virtualisation.docker.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Make sure it exists, for "light" command.
  users.groups.video = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ron = {
    isNormalUser = true;
    home = "/home/ron";
    extraGroups = [ "docker" "wheel" "networkmanager" "video" "vboxusers" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
