{
  pkgs,
  utils,
  ...
}:
let
  cryptrootDev = "${utils.escapeSystemdPath "/dev/mapper/cryptroot"}.device";
in
{
  environment.persistence."/persist/" = {
    hideMounts = true;
    files = [
      "/etc/machine-id"
    ];
    directories = [
      {
        directory = "/etc/NetworkManager/system-connections";
        mode = "0700";
      }
    ];
  };
  boot.initrd.systemd.services.rollback-root = {
    description = "Rollback root subvolume";
    unitConfig = {
      DefaultDependencies = false;
      ConditionKernelCommandLine = "!root-rollback.disable";
    };
    serviceConfig.Type = "oneshot";
    requiredBy = [ "initrd.target" ];
    before = [ "sysroot.mount" ];

    requires = [ cryptrootDev ];
    after = [
      cryptrootDev
      "local-fs-pre.target"
    ];

    path = [
      pkgs.btrfs-progs
      pkgs.coreutils
      pkgs.util-linux
    ];

    script = ''
      set -euo pipefail

      btrfs_top=/btrfs-top

      mkdir -p "$btrfs_top"
      mount \
        -t btrfs \
        -o subvolid=5 \
        /dev/mapper/cryptroot \
        "$btrfs_top"

      trap 'umount "$btrfs_top"' EXIT
      btrfs subvolume show "$btrfs_top/root-blank" >/dev/null

      if [ -e "$btrfs_top/root-previous" ]; then
        btrfs subvolume delete -R "$btrfs_top/root-previous"
      fi

      if [ -e "$btrfs_top/root" ]; then
        mv "$btrfs_top/root" "$btrfs_top/root-previous"
      fi

      btrfs subvolume snapshot \
        "$btrfs_top/root-blank" \
        "$btrfs_top/root"
    '';
  };
}
