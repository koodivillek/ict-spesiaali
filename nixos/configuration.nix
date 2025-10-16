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
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fi";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fi";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mikim = {
    isNormalUser = true;
    description = "Miki Meklin";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [];
    shell = pkgs.fish; #Kommentoi tämä pois jos menee rikki
  };

  programs.fish.enable = true; #Kommentoi tämä pois jos menee rikki


  # Enable automatic login for the user.
  services.getty.autologinUser = "mikim";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  git
  nano
  htop
  wget
  curl
  fish
  zfs
  ];


  # Jellyfin mediapalvelin

  services.jellyfin.enable = true;

  # Portti ja palomuuri (Jellyfin ja Samba
  networking.firewall.allowedUDPPorts = [ 137 138 ];
  networking.firewall.allowedTCPPorts = [ 8096 139 445]; # HTTP OLETUSPORTTI JOTEN JELLYFIN NÄKYY
  # OSOITTEESSA http://localhost:8096


  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "25.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ZFS-tuki
  boot.supportedFilesystems = [ "zfs" ];

  # ZFS vaatii 8-merk. heksa hostId:n
  # (ota esim. ensimmäiset 8 merkkiä /etc/machine-id:stä:  head -c8 /etc/machine-id)
  networking.hostId = "1e2cd903";  # <- vaihda omaan arvoon

  services.zfs = {
    autoScrub.enable = true;  # viikoittainen scrub
    trim.enable = true;       # ok SSD:lle ja useimmille virtuaalilevyille
    # autoSnapshot.enable = true; # valinnainen
    # zed.settings = { ZED_NOTIFY_VERBOSE = true; };
  };

  # ZFS automaattiset snapshotit
  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 8;  # 8 snapshottia 15 min välein
    hourly   = 24; # 24 tuntia
    daily    = 7;  # 7 päivää
    weekly   = 4;  # 4 viikkoa
    monthly  = 3;  # 3 kuukautta
  };

  # --- SAMBA ---
  services.samba = {
    enable = true;
    smbd.enable = true;
    nmbd.enable = true;

    settings = {
      "global" = {
        "workgroup" = "WORKGROUP";
        "server min protocol" = "SMB2";
        "map to guest" = "Bad User";
        "usershare allow guests" = "yes";
      };

      "movies" = {
        "path" = "/media/movies";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
    };
  };
}
