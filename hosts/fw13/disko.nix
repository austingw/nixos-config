{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";

        # Replace this with the actual value from /dev/disk/by-id/.
        device = "/dev/nvme0n1";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "4G";
              type = "EF00";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            luks = {
              size = "100%";
              label = "luks";

              content = {
                type = "luks";
                name = "cryptroot";

                settings = {
                  # Permit periodic TRIM to reach the SSD through dm-crypt.
                  allowDiscards = true;
                };

                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-L"
                    "nixos"
                    "-f"
                  ];

                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    # The rollback service snapshots this into /root every boot.
                    "/root-blank" = { };

                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/lib" = {
                      mountpoint = "/var/lib";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/persist/swap" = {
                      mountpoint = "/persist/swap";
                      mountOptions = [ "noatime" ];

                      # Disko uses btrfs filesystem mkswapfile, which handles
                      # NOCOW, NODATASUM, preallocation, and compression.
                      swap.swapfile.size = "40G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  # Run periodic fstrim. LUKS allowDiscards lets these requests reach
  # the physical SSD.
  services.fstrim.enable = true;

  # These subvolumes must be mounted early for impermanence and services.
  fileSystems = {
    "/persist".neededForBoot = true;
    "/var/log".neededForBoot = true;
    "/var/lib".neededForBoot = true;
  };

  # Add these after obtaining the Btrfs swapfile resume offset:
  #
  # boot.resumeDevice = "/dev/mapper/cryptroot";
  # boot.kernelParams = [ "resume_offset=REPLACE_WITH_OFFSET" ];
}
