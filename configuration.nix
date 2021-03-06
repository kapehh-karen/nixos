{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub.efiInstallAsRemovable = true;

  networking.hostName = "kapehh-nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_GB.UTF-8";

  # X11
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # Graphics
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ pkgs.mesa.drivers ];
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    ubuntu_font_family
  ];

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.karen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  #virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    # Applications
    vim
    wget
    kate
    mc
    git
    micro
    ventoy-bin
    google-chrome
    tdesktop
    #krita

    # Development
    #vscode
    #(callPackage ./yandex-browser-stable {})
    #rocketchat-desktop
    #filezilla
    #jetbrains.rider
    #docker-compose
    #(with dotnetCorePackages; combinePackages [
    #  sdk_3_1
    #  sdk_5_0
    #  sdk_6_0
    #])
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "21.11";
}
