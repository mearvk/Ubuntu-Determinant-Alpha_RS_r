# Ubuntu Base Userland

## Source

Ubuntu Base 24.04.4 LTS (Noble Numbat) — official minimal rootfs from Canonical.

- **URL:** http://cdimage.ubuntu.com/ubuntu-base/releases/24.04.4/release/
- **File:** ubuntu-base-24.04.4-base-amd64.tar.gz
- **Size:** 29 MB (compressed)
- **Architecture:** amd64 (x86_64)
- **SHA256:** `c1e67ef7b17a6300e136118bd1dc04725009cb376c1aad10abcf8cd453628d58`
- **License:** Free software (various — GPLv2, LGPL, MIT, BSD, etc.)

## Userland Components

| Component | Path | Description |
|-----------|------|-------------|
| Ubuntu Base | `ubuntu-base-24.04.4-base-amd64.tar.gz` | Minimal rootfs (libc, apt, systemd) |
| X11 | `x11/` | X.Org Server 21.1.24 + libs |
| Wallpapers | `wallpapers/` | 9 SVG + 10 Marvell JPEG wallpapers |
| OpenJDK 28 | `openjdk/` | Secure JVM with custom extensions |
| Boot JDK 27 | `java/boot-jdk-27/` | Bootstrap JDK for building OpenJDK |
| Chromium | `chromium/` | Full browser source (headless for Dave) |
| JWSTF/NWE | `java-web-server/` | NitroWebExpress application server |

## NitroWebExpress (JWSTF)

Full Java web server with 4,654 source files, telnet TUI, and web interface.

- **Source:** `java-web-server/source/` (Main.java entry point)
- **Modules:** `java-web-server/modules/` (application plugins)
- **Gateway:** `java-web-server/gateway/` (NAT traversal for home users)
- **Build:** `ant compile` or `ant jar` (see `java-web-server/build.xml`)
- **Install:** Handled by `scripts/install-jwstf.sh` during OS installation

### Stack (installed during OS install)
- Apache2 (reverse proxy, ports 80/443)
- Tomcat 10.1 (servlet container, ports 8080/8443)
- MySQL 8 (database N21, port 3306)
- NWE (telnet TUI, port 23)
- NWE Gateway (NAT traversal, auto-start)

## Boot JDK 27

The boot JDK is required to compile OpenJDK 28 from source. Two large files
(`modules` at 142MB and `src.zip` at 52MB) are stored as chunks to comply
with GitHub's file size limits.

```bash
# After cloning, rebuild the large files:
bash java/boot-jdk-27/lib/chunks/rebuild.sh
```

## Last Updated

2026-08-02 — Added JWSTF, NWE Gateway, boot-jdk-27 chunks
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
