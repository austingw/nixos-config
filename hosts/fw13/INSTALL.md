# Framework 13 Installation Guide/Log

Hardware:

- Ryzen AI 9 HX 370
- TEAMGROUP Elite SODIMM DDR5 32GB (2x16GB) 5600MHz
- Samsung 990 EVO Plus SSD 1TB

Setup:

- UEFI with systemd-boot
- LUKS passphrase unlock
- Btrfs managed by Disko
- Persistent `/home`, `/nix`, `/var/lib`, `/var/log`, and `/persist`
- Impermanence for `/etc/machine-id` and NetworkManager connections
- Fresh root snapshot on every normal boot
- 40 GiB swapfile with hibernation

The committed `resume_offset` belongs to the current swapfile. Comment it out
before reinstalling and detect the new value afterward.

## 1. Boot the Installer

Boot the NixOS minimal installer in UEFI mode and connect to the network:

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

## 2. Clone the Configuration

```bash
cd /tmp
git clone https://github.com/austingw/nixos-config.git
cd nixos-config
```

## 3. Select the Disk

```bash
lsblk -d -o NAME,PATH,MODEL,SERIAL,SIZE,TRAN
ls -l /dev/disk/by-id/
```

Set the private whole-disk by-id path. Do not use a `-partN` path or commit the
value to the repository.

```bash
DISK='/dev/disk/by-id/REPLACE-WITH-WHOLE-DISK-ID'
readlink -f "$DISK"
lsblk -d -o NAME,PATH,MODEL,SERIAL,SIZE,TRAN "$(readlink -f "$DISK")"
```

## 4. Create the Password Hash

The destination must match `users/austin/nixos.nix` exactly:

```text
/persist/secrets/austin-password-hash
```

Generate and stage the hash:

```bash
PASSWORD_HASH="$(nix run nixpkgs#mkpasswd -- --method=yescrypt)"
TEMP_PASSWORD_FILE=/tmp/austin-password-hash

sudo install -m 0600 -o root -g root /dev/null "$TEMP_PASSWORD_FILE"
printf '%s\n' "$PASSWORD_HASH" \
  | sudo dd of="$TEMP_PASSWORD_FILE" status=none

unset PASSWORD_HASH
sudo stat -c '%U:%G %a %s %n' "$TEMP_PASSWORD_FILE"
```

## 5. Disable the Old Resume Offset

```bash
nvim hosts/fw13/disko.nix
```

Comment out the current values at the end of the file:

```nix
# boot.resumeDevice = "/dev/mapper/cryptroot";
# boot.kernelParams = [ "resume_offset=OLD_VALUE" ];
```

## 6. Install

This destroys the selected disk. The Disko revision matches `flake.lock` at the
time this guide was written.

```bash
DISKO_REV=de5708739256238fb912c62f03988815db89ec9a

sudo nix run \
  "github:nix-community/disko/$DISKO_REV#disko-install" \
  -- \
  --write-efi-boot-entries \
  --flake "path:$PWD#fw13" \
  --disk nvme0n1 "$DISK" \
  --extra-files \
    "$TEMP_PASSWORD_FILE" \
    /persist/secrets/austin-password-hash
```

`disko-install` partitions, formats, mounts, and installs the system. Do not
also run `nixos-install` or `nixos-enter`.

After `disko-install succeeded`:

```bash
sudo rm -f "$TEMP_PASSWORD_FILE"
sudo reboot
```

## 7. First Boot

Enter the LUKS passphrase and log in as `austin`. Configure Wi-Fi if needed:

```fish
sudo chmod 0700 /persist/secrets
sudo nmtui
```

Clone the configuration into the persistent home:

```fish
git clone https://github.com/austingw/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

Optionally restore the SSH remote:

```fish
git remote set-url origin git@github.com:austingw/nixos-config.git
```

Check the persistent mounts:

```fish
findmnt /home
findmnt /nix
findmnt /persist
findmnt /var/lib
findmnt /var/log
findmnt --mountpoint /etc/machine-id
findmnt --mountpoint /etc/NetworkManager/system-connections
swapon --show
```

## 8. Test Root Rollback

```fish
sudo touch /root/should-disappear
touch ~/should-survive
sudo reboot
```

After reboot:

```fish
sudo test ! -e /root/should-disappear; and echo "root rolled back"
test -e ~/should-survive; and echo "home persisted"
rm ~/should-survive
```

To skip rollback for one boot, append this to a systemd-boot entry with `e`:

```text
root-rollback.disable
```

## 9. Detect the Swapfile Offset

Do not hibernate until the new offset is installed.

```fish
swapon --show

set RESUME_OFFSET \
    (sudo btrfs inspect-internal map-swapfile \
        -r \
        /persist/swap/swapfile)

printf 'Resume offset: %s\n' "$RESUME_OFFSET"
```

Edit `hosts/fw13/disko.nix`:

```fish
nvim hosts/fw13/disko.nix
```

Set the detected value:

```nix
boot.resumeDevice = "/dev/mapper/cryptroot";
boot.kernelParams = [ "resume_offset=DETECTED_VALUE" ];
```

Install and reboot:

```fish
sudo nixos-rebuild switch --flake .#fw13
sudo reboot
```

Confirm the new boot parameters:

```fish
cat /proc/cmdline
```

The offset must be detected again whenever the swapfile is recreated or moved.

## 10. Test Hibernation

```fish
sudo touch /root/hibernate-marker
systemctl hibernate
```

After resume, the marker should still exist:

```fish
sudo test -e /root/hibernate-marker; and echo "hibernate resumed"
```

After a normal reboot, rollback should remove it:

```fish
sudo reboot
```

```fish
sudo test ! -e /root/hibernate-marker; and echo "root rolled back"
```

Commit the new offset after it works:

```fish
git add hosts/fw13/disko.nix
git diff --cached
git commit -m "Update Framework resume offset"
git push
```
