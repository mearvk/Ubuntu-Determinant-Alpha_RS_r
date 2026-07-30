# Ubuntu Base Userland

## Source

Ubuntu Base 24.04.4 LTS (Noble Numbat) — official minimal rootfs from Canonical.

- **URL:** http://cdimage.ubuntu.com/ubuntu-base/releases/24.04.4/release/
- **File:** ubuntu-base-24.04.4-base-amd64.tar.gz
- **Size:** 29 MB (compressed)
- **Architecture:** amd64 (x86_64)
- **SHA256:** `c1e67ef7b17a6300e136118bd1dc04725009cb376c1aad10abcf8cd453628d58`
- **License:** Free software (various — GPLv2, LGPL, MIT, BSD, etc.)

## What It Contains

A minimal but functional Ubuntu userspace:
- apt/dpkg package management (install anything from Ubuntu repos)
- bash shell
- coreutils (ls, cp, mv, rm, cat, etc.)
- libc6, libstdc++
- networking utilities
- systemd (init system)
- No GUI, no desktop — just the base for building up

## Usage

### Deploy to a root filesystem

```bash
# Create and mount your target partition
mkfs.ext4 /dev/sdXN
mount /dev/sdXN /mnt/rootfs

# Extract userland
tar -xzf ubuntu-base-24.04.4-base-amd64.tar.gz -C /mnt/rootfs

# Install kernel modules
cp -r /lib/modules/5.15.204 /mnt/rootfs/lib/modules/

# Add a user
chroot /mnt/rootfs useradd -m -G sudo,adm mearvk
chroot /mnt/rootfs passwd mearvk

# Install additional packages (with network)
chroot /mnt/rootfs apt-get update
chroot /mnt/rootfs apt-get install -y openssh-server vim
```

### Use with QEMU for testing

```bash
# Create a disk image
qemu-img create -f raw rootfs.img 2G
mkfs.ext4 rootfs.img

# Mount and populate
mkdir /tmp/mnt && sudo mount -o loop rootfs.img /tmp/mnt
sudo tar -xzf ubuntu-base-24.04.4-base-amd64.tar.gz -C /tmp/mnt
sudo umount /tmp/mnt

# Boot with custom kernel
qemu-system-x86_64 \
    -kernel /path/to/bzImage \
    -drive file=rootfs.img,format=raw \
    -append "root=/dev/sda rw console=ttyS0" \
    -nographic
```

## Integration with Ubuntu Determinant Alpha RS

After deploying, install the custom tools:
- `tools/sudo_gate/` → Grade privilege wrapper
- `tools/chat/` → Terminal chat
- `tools/nnet/` → Identity query
- `tools/negamane/` → Userspace immutability command
- `tools/accounts/provision_accounts.sh` → System accounts
