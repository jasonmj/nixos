{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
      luks.devices."nixos-enc".device = "/dev/disk/by-uuid/cbb9a4d9-b7c8-442f-baf9-b79b7610f5be";
      systemd.enable = true;
    };
    kernelModules = [ "kvm-intel" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  fileSystems = {
    "/" =
      { device = "/dev/disk/by-uuid/97fab64e-bfa7-4d0b-a9ab-b1eeb0fa26f2";
        fsType = "btrfs";
        options = [ "noatime" "compress=lzo" "space_cache" "autodefrag" "subvol=nixos" ];
      };
    "/boot" =
      { device = "/dev/disk/by-uuid/F474-F912";
        fsType = "vfat";
      };
    "/mnt/backup" =
      { device = "/dev/disk/by-uuid/c88fff93-1ad8-4f91-99c4-1b4ce2461370";
        fsType = "ext4";
        options = ["noauto" "x-systemd.automount"];
      };
    "/mnt/storage" =
      { device = "/dev/disk/by-uuid/a1404c51-c21d-4e1a-9438-1c534f4610f5";
        fsType = "ext4";
        options = ["noauto" "x-systemd.automount"];
      };
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];
}
