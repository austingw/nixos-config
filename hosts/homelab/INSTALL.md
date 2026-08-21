# Homelab Installation Guide

Hardware:

- Lenovo ThinkPad E14
- AMD Ryzen 7 7730U
- 40 GB RAM
- 512 GB NVMe SSD

Setup:

- UEFI with systemd-boot
- Unencrypted ext4 root managed by Disko
- Zram instead of disk swap
- Persistent system and service state
- Tailscale-only, key-authenticated SSH
- Tailscale enrolled after first boot
- No graphical environment, hibernation, or impermanence

## 1. Prepare the Firmware

Configure the ThinkPad firmware before booting the installer:

- Use UEFI boot mode.
- Disable Secure Boot if the installer does not boot with it enabled.
- Enable automatic power-on after AC loss if the firmware provides it.
- Prefer wired Ethernet for installation and normal operation.

## 2. Boot the Installer

Boot the NixOS minimal installer and connect to the network:

```bash
sudo nmtui
curl --fail --location --head https://github.com
timedatectl status
```

Enter a shell with the required tools and enable flakes:

```bash
export NIX_CONFIG='experimental-features = nix-command flakes'
nix-shell -p git neovim
```

## 3. Clone the Configuration

```bash
cd /tmp
git clone https://github.com/austingw/nixos-config.git
cd nixos-config
```

## 4. Generate the Hardware Configuration

Replace the committed baseline with a scan from the ThinkPad. Filesystems are
omitted because Disko defines them:

```bash
nixos-generate-config \
  --show-hardware-config \
  --no-filesystems \
  > hosts/homelab/hardware-configuration.nix
```

Review the generated module:

```bash
git diff -- hosts/homelab/hardware-configuration.nix
```

Keep this generated file after installation and commit it from another machine
or after the homelab is online.

## 5. Verify SSH Access

SSH password authentication is disabled. Confirm that the public key in
`hosts/homelab/configuration.nix` belongs to a client that will be available
after installation:

```bash
grep 'ssh-ed25519' hosts/homelab/configuration.nix
```

Add any other client public keys before installing. The configured account also
has a local password for console login and `sudo`.

## 6. Select the Disk

This installation destroys the selected disk. List the available devices:

```bash
lsblk -d -o NAME,PATH,MODEL,SERIAL,SIZE,TRAN
ls -l /dev/disk/by-id/
```

Set the whole-disk by-id path. Do not select a `-partN` path:

```bash
DISK='/dev/disk/by-id/REPLACE-WITH-WHOLE-DISK-ID'
readlink -f "$DISK"
lsblk -d -o NAME,PATH,MODEL,SERIAL,SIZE,TRAN "$(readlink -f "$DISK")"
```

Confirm that this is the internal SSD before continuing.

Record the same persistent path in the Disko configuration so future direct
Disko operations cannot fall back to the unstable `/dev/nvme0n1` name:

```bash
printf '%s\n' "$DISK"
nvim hosts/homelab/disko.nix
```

Set `disko.devices.disk.main.device` to the printed value:

```nix
device = "/dev/disk/by-id/REPLACE-WITH-WHOLE-DISK-ID";
```

Whole-disk IDs are hardware identifiers, not credentials, and are safe to
commit publicly. Model-based IDs may disclose the SSD model and serial number.
Keep the explicit `--disk main "$DISK"` argument during installation as an
additional guard.

## 7. Create the Password Hash

Generate a root-owned yescrypt hash using the repository script:

```bash
TEMP_PASSWORD_FILE=/tmp/austin-password-hash
./scripts/create-password-hash.sh "$TEMP_PASSWORD_FILE"
```

The script prompts for the password without writing the plaintext password to
the repository or shell history. The installed destination must match:

```text
/var/lib/nixos/secrets/austin-password-hash
```

## 8. Validate the Configuration

Evaluate the hostname and build the system before modifying the disk:

```bash
nix eval \
  --raw \
  "path:$PWD#nixosConfigurations.homelab.config.networking.hostName"

nix build \
  --no-link \
  "path:$PWD#nixosConfigurations.homelab.config.system.build.toplevel"
```

The hostname command must print `homelab` and the build must succeed.

## 9. Install

The Disko revision below matches `flake.lock` at the time this guide was
written:

```bash
DISKO_REV=de5708739256238fb912c62f03988815db89ec9a

sudo nix run \
  "github:nix-community/disko/$DISKO_REV#disko-install" \
  -- \
  --write-efi-boot-entries \
  --flake "path:$PWD#homelab" \
  --disk main "$DISK" \
  --extra-files \
    "$TEMP_PASSWORD_FILE" \
    /var/lib/nixos/secrets/austin-password-hash
```

`disko-install` partitions, formats, mounts, and installs the system. Do not
also run `nixos-install` or `nixos-enter`.

After `disko-install succeeded`:

```bash
sudo rm -f "$TEMP_PASSWORD_FILE"
sudo reboot
```

## 10. First Boot

Log in as `austin` at the local console. If Ethernet is unavailable, configure
Wi-Fi:

```fish
sudo nmtui
```

Confirm the storage and secret permissions:

```fish
findmnt /
findmnt /boot
lsblk -f
swapon --show
sudo stat -c '%U:%G %a %s %n' \
  /var/lib/nixos/secrets/austin-password-hash
```

The password file must be owned by `root:root` with mode `600`. Zram should be
the only swap device.

## 11. Enroll Tailscale

Keep the host's own DNS independent from the future Pi-hole service:

```fish
sudo tailscale up --accept-dns=false
tailscale status
tailscale ip -4
```

Complete authentication using the URL printed by `tailscale up`.

## 12. Test Remote Administration

From the Framework, connect to the Tailscale address printed during enrollment:

```bash
ssh austin@REPLACE-WITH-TAILSCALE-IP
```

Port 22 is allowed only on the Tailscale interface. If MagicDNS is enabled for
the tailnet, the hostname can be used instead:

```bash
ssh austin@homelab
```

Clone the configuration into the persistent home directory:

```fish
git clone https://github.com/austingw/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

## 13. Test Headless Operation

Verify the enabled services:

```fish
systemctl status sshd tailscaled
```

Close the lid and confirm that SSH remains connected. Then reboot remotely:

```fish
sudo reboot
```

Confirm that Tailscale SSH returns after the reboot. Finally, test recovery
after AC loss if automatic power-on was enabled in the firmware.

Only after these checks pass should Pi-hole, Caddy, Jellyfin, TorBox, or other
application services be enabled.
