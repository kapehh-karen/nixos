# Hotkeys window manager https://i3wm.org/docs/refcard.html

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  # services.xserver = {
  #   enable = true;
  #   autorun = false;             # for manual run
  #   desktopManager = {
  #     xterm.enable = false;
  #   };
  #   displayManager = {
  #     startx.enable = true;      # for manual run
  #     defaultSession = "none+i3";
  #   };
  #   windowManager.i3 = {
  #     enable = true;
  #     extraPackages = with pkgs; [
  #       dmenu
  #       i3status
  #       i3lock
  #       i3blocks
  #       xclip
  #     ];
  #   };
  #   xkbModel = "microsoft";
  #   layout = "us,ru(winkeys)";
  #   xkbOptions = "grp:caps_toggle,grp_led:caps";
  #   xkbVariant = "winkeys";
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.zsh.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    ];
  };
  programs.fish = {
    enable = true;
    loginShellInit = ''
      if test (id --user $USER) -ge 1000 && test (tty) = "/dev/tty1"
        exec sway
      end
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.karen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "sound" "video" "networkmanager" "input" "tty" "sway" "docker" ]; # Enable ‘sudo’ for the user.
    # shell="/run/current-system/sw/bin/zsh";
    shell = pkgs.fish;
  };

  nix.trustedUsers = [ "root" "karen" ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    rxvt_unicode
    htop
    mc
    git
    google-chrome
  ];

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
  system.stateVersion = "21.05"; # Did you read the comment?
}
