{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../modules/simple-efi.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  sops.defaultSopsFile = ../secrets/example.yaml;

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  environment.sessionVariables.SOPS_AGE_KEY_FILE = "/run/secrets.d/age-keys.txt";

  sops.secrets.home-wifi-password = { };
  sops.secrets.work-wifi-password = { };

  sops.templates."wireless.env".content = ''
    HOME_WIFI=${config.sops.placeholder.home-wifi-password}
    WORK_WIFI=${config.sops.placeholder.work-wifi-password}
  '';

  networking.wireless.enable = true;
  networking.wireless.environmentFile = config.sops.templates."wireless.env".path;
  networking.wireless.networks = {
    "1337_ap_home" = {
      psk = "@HOME_WIFI@";
    };
    "HP-Print-46-DeskJet 2540 Series" = {
      psk = "@WORK_WIFI@";
    };
  };

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.loader.systemd-boot.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";

  services.xserver = {
    layout = "us,ru,ua";
    xkbOptions = "grp:win_space_toggle";
  };

  time.timeZone = "Europe/Kyiv";

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  programs.git = {
    enable = true;
    lfs.enable = true;
  };


  environment.systemPackages = with pkgs; [
    vim
    wget
    file
    gparted
    direnv

    sops
    age

    nixos-generators
  ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.vmware.host.enable = true;
  virtualisation.docker.enable = true;

  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  # virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.guest.x11 = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };


  users.mutableUsers = true;
  users.users = {
    user = {
      initialPassword = "user"; # TODO: change password
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ 
        "wheel" 
        "docker"
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  system.stateVersion = "23.11";
}
