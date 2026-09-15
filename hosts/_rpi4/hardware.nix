# Placeholder hardware for rpi4 (Raspberry Pi 4, aarch64).
# REPLACE before building: run `nixos-generate-config` on the Pi and paste the
# generated fileSystems + swapDevices here. See README "Configure before deploy".
{lib, ...}: {
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  # Optionally import a profile from the flake's `nixos-hardware` input.
  # fileSystems + swapDevices are REQUIRED — the build fails fast without them.
}
