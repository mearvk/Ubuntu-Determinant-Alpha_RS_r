# sudo_gate - Privilege Grade System for sudo
## MEARVK LLC

A wrapper for the `sudo` binary that enforces an 8-level privilege grading
system. Standard `sudo` behavior is preserved for routine operations (grades
1-6). Critical and irreversible operations require explicit gate invocations.

### Invocation Summary

| Grade | Scope | Invocation |
|-------|-------|------------|
| 1 | Routine inspection (ls, ps, cat, ping) | `sudo <cmd>` |
| 2 | Service management (systemctl, journalctl) | `sudo <cmd>` |
| 3 | Package/user management (apt, useradd) | `sudo <cmd>` |
| 4 | Network configuration (iptables, ip, ufw) | `sudo <cmd>` |
| 5 | Storage operations (mount, fdisk, mkfs*) | `sudo <cmd>` |
| 6 | Kernel tuning (sysctl, modprobe, insmod) | `sudo <cmd>` |
| 7 | Critical system (passwd root, /etc/shadow, grub) | `sudo touch system <cmd>` |
| 8 | Irreversible/security (dd, flush rules, rm -rf /) | `sudo touch system gate <cmd>` |

### Examples

```bash
# Grade 1-6: works exactly like normal sudo
sudo systemctl restart nginx
sudo apt install htop
sudo modprobe vfio

# Grade 7: requires "touch system" gate
sudo touch system visudo
sudo touch system passwd root
sudo touch system vim /etc/fstab

# Grade 8: requires "touch system gate"
sudo touch system gate dd if=/dev/zero of=/dev/sda
sudo touch system gate iptables -F
sudo touch system gate rm -rf /var/lib/important
```

### What Happens Without the Gate

```
$ sudo visudo

╔══════════════════════════════════════════════════════╗
║  SUDO GATE: Grade 7 - Critical System Operation     ║
╠══════════════════════════════════════════════════════╣
║  This command modifies critical system state.        ║
║                                                      ║
║  Required invocation:                                ║
║    sudo touch system visudo                          ║
║                                                      ║
║  Command classified as: GRADE 7 (Critical)          ║
║  Standard 'sudo' is insufficient for this action.   ║
╚══════════════════════════════════════════════════════╝
```

### System Constitution Assumptions

1. Production or near-production Linux host
2. Multiple administrators may have sudo access
3. Grading reflects increasing potential for irreversible harm
4. A careful admin knows which gate to use deliberately
5. System values availability and integrity over convenience
6. Audit trail is mandatory for grades 7-8
7. Grade escalation requires explicit intent

### Installation

```bash
cd tools/sudo_gate
make
sudo make install
```

This moves the original sudo to `/usr/bin/sudo.real` and installs sudo_gate
as `/usr/bin/sudo`. To bypass: use `/usr/bin/sudo.real` directly.

### Uninstall

```bash
sudo make uninstall   # Restores original sudo
```

### Configuration

Edit `/etc/sudo_gate.conf` to:
- Disable gate enforcement entirely
- Override grade classification for specific commands
- Restrict which users can use grade 7-8 gates
- Set time windows for elevated operations
- Enable/disable grade-8 interactive confirmation

### Audit Log

All grade 7-8 operations (allowed or denied) are logged to:
- `/var/log/sudo_gate.log`
- syslog (AUTH facility)

Format:
```
2026-07-27 21:45:00 grade=7 user=admin gate=touch_system allowed=1 cmd=visudo
2026-07-27 21:46:12 grade=8 user=admin gate=insufficient allowed=0 cmd=dd if=/dev/zero of=/dev/sda
```
