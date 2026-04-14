{ ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable NTFS support
  boot.supportedFilesystems = [ "ntfs" ];
}
