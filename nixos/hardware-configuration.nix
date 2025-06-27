{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
      luks.devices."luks-19e1b920-1044-42e5-aa8e-af217294d991".device = "/dev/disk/by-uuid/19e1b920-1044-42e5-aa8e-af217294d991";
      luks.devices."luks-63555409-310c-4029-84c2-4cf410c5f754".keyFile = "/crypto_keyfile.bin";
      luks.devices."luks-63555409-310c-4029-84c2-4cf410c5f754".device = "/dev/disk/by-uuid/63555409-310c-4029-84c2-4cf410c5f754";
      luks.devices."luks-19e1b920-1044-42e5-aa8e-af217294d991".keyFile = "/crypto_keyfile.bin";
      secrets = {"/crypto_keyfile.bin" = null;};
    };
    loader = {
      grub.enable = true;
      grub.device = "/dev/nvme0n1";
      grub.useOSProber = true;
      grub.enableCryptodisk=true;
    };
    kernelModules = [ "kvm-amd" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e5a86c22-24c2-44e4-8f56-905f823e5462";
    fsType = "ext4";
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  swapDevices = [ { device = "/dev/disk/by-uuid/a2fd708f-1085-4815-9e15-1e8f00e46048"; } ];
}
