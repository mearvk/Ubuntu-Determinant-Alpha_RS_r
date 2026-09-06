# tools/tac3 — `tac3ctl` userspace diagnostic

`tac3ctl` is the userspace companion to the in-kernel **TAC3** filesystem
(`fs/tac3`, built into the ISO kernel via `CONFIG_TAC3=m`). It links the
portable C++ engine (`tac3.cpp` / `tac3.hpp`, the same port kept in
`file-systems/tac3/`) so it runs with or without the kernel module loaded.

## Commands

```text
tac3ctl info                Print the TAC3 model summary (tables, multitude,
                            device-class speed ceilings). This is the default.
tac3ctl simulate [opts]     Offline wear/pressure/health simulation.
tac3ctl help                Usage.
```

`simulate` options: `--multitude <n>` (1..16), `--class <ide-hdd|sata-hdd|
sas-hdd|sata-ssd|nvme3|nvme4|nvme5|usb2|usb3|usb4>`, `--reads <n>`,
`--writes <n>`, `--jarring <n>`.

When the kernel module is loaded, authoritative live per-mount numbers are at
`/proc/tac3/{status,health,admin}`; `tac3ctl` complements that with an offline
model view and simulation.

## Build & install

```sh
tools/tac3/build.sh          # or: make -C tools/tac3
tools/tac3/install.sh        # or: make -C tools/tac3 install   (PREFIX=/usr/local/bin)
```

## Integration points

- **ISO / kernel:** the TAC3 *filesystem module* ships in the ISO through the
  kernel build (`CONFIG_TAC3=m` in `arch/x86/configs/galactic_cherry_defconfig`
  and the checked-in `.config`), so `modules_install` folds `tac3.ko` into the
  rootfs and `gen-iso.sh`'s squashfs. `tac3ctl` is not the module.
- **Binary installer:** `tac3ctl` is registered in
  `installer/install-manifest.txt` (`tac3ctl|tools/tac3|tac3ctl|1`), so the
  `package-installer` binary installs it into `/user/bin` and `/deck/bin`
  without any recompile of the installer.
- **Tools chain:** wired into `tools/Makefile` (`all`/`install`/`clean`).
