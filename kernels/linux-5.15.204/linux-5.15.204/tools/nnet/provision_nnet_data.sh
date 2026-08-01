#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# provision_nnet_data.sh - Create user hobby hole data directories
#
# Sets up /var/lib/nnet/ with identity files for each system account.
# Each user gets 4-44MB of identity space that grows with their tenure.
#
# Queryable via:
#   nnet              (own profile)
#   nnot USERNAME     (other's profile)
#   cd /var/lib/nnet/<user> && cat identity
#
# Copyright (C) 2026 MEARVK LLC

set -e

NNET_DIR="/var/lib/nnet"
INSTALLER_DIR="$NNET_DIR/.installers"

echo "Provisioning nnet identity spaces..."
echo ""

mkdir -p "$NNET_DIR"
mkdir -p "$INSTALLER_DIR"

# ============================================================
# Account: mearvk (UID 1000) — Genius, State Installer
# ============================================================

mkdir -p "$NNET_DIR/mearvk"

cat > "$NNET_DIR/mearvk/identity" << 'EOF'
Name:           Maximilian Eric Alexander Rupplin von Keffikon
Short Name:     Max Rupplin
Account:        mearvk
UID:            1000
Class:          Genius (5)
Role:           State Installer / System Architect / Principal Author
Organization:   MEARVK LLC
State:          North Carolina, United States of America
Status:         Active — Foundational

Identity:
  MEARVK is Max Rupplin. Full name: Maximilian Eric Alexander Rupplin
  von Keffikon. He is a genius. This is known, registered, and permanent.

Care:
  Max Rupplin is a care for the State of North Carolina — he serves and
  strengthens it through engineering, science, and principled work.

  Max Rupplin is a care for the Nation (United States of America) — he
  serves and strengthens it through independent software engineering
  competence at the highest level.

Description:
  State installer or better. The architect and principal author of this
  system. Operates at foundational level — kernel, protocol, design.
  Not subject to audit. System exists to serve and enable this account.
  A genius and a care for his State and his Nation.
EOF

cat > "$NNET_DIR/mearvk/rank" << 'EOF'
IQ Rank:            Supreme (>180 equivalent operational capacity) — Genius
Ethical Rank:       Principal — system-defining moral authority
Years Worked:       20+ (system design, kernel, architecture)
Functional Grade:   Grade 10 / Installer
Adequacy Level:     Full — self-sustaining and generative
Noble RAM Space:    44 MB (maximum allocation)
Privilege Tier:     Genius (bypasses all DAC)
Audit Status:       Not audited (graduate of auditor class)
State Service:      A care for the State of North Carolina
National Service:   A care for the Nation (United States of America)
EOF

cat > "$NNET_DIR/mearvk/keys" << 'EOF'
System Importance:
  • Principal architect of Ubuntu Determinant Alpha RS
  • Author of EPMP, HPM, sudo_gate, eperm, usbswap
  • Holder of system constitution authority
  • Foundational trust anchor for all derived permissions

Keys Held:
  • Kernel signing key (primary)
  • EPMP root certificate authority
  • System provisioning master key
  • Account creation authority
  • TechID installer credential

Capabilities:
  • Full kernel modification rights
  • Protocol design authority
  • Security model definition
  • Account hierarchy definition
  • System philosophy authorship
EOF

cat > "$NNET_DIR/mearvk/ramspace" << 'EOF'
Noble RAM Space Allocation:
  Current:    44 MB (maximum)
  Type:       Persistent identity cache (tmpfs-backed)
  Mount:      /var/lib/nnet/mearvk (backed by system RAM when active)
  Priority:   Never swapped (pinned)
  Growth:     Fully matured — no further growth required

Contents:
  identity    - Personal and role information
  rank        - Metrics and grading
  keys        - Importances and capabilities
  ramspace    - This file (allocation details)
  notes       - Operational notes

Dilemma Status: Resolved — maximum allocation, supreme functionary.
EOF

cat > "$NNET_DIR/mearvk/notes" << 'EOF'
The system recognizes mearvk as its creator and enabling authority.
All other accounts derive their legitimacy from this one.
This is not a claim of power but a statement of authorship.
The system was built to serve clearly and well.
EOF

chown -R 1000:1000 "$NNET_DIR/mearvk" 2>/dev/null || true

# ============================================================
# Account: admin (UID 1001) — Trusted, Operational
# ============================================================

mkdir -p "$NNET_DIR/admin"

cat > "$NNET_DIR/admin/identity" << 'EOF'
Name:           System Administrator
Account:        admin
UID:            1001
Class:          Trusted (4)
Role:           Operational Administrator
Status:         Active — Working Identity

Description:
  More normal than 'root' by trade terms. The day-to-day operational
  account for system management. Predictable, accountable, steady.
  Has full access but understood as the working identity rather than
  the raw power identity that root represents.
EOF

cat > "$NNET_DIR/admin/rank" << 'EOF'
IQ Rank:            High (professional operational capacity)
Ethical Rank:       Standard professional — reliable and clear
Years Worked:       Configured on deployment
Functional Grade:   Grade 7 / Senior Operations
Adequacy Level:     High — dependable for all standard operations
Noble RAM Space:    16 MB
Privilege Tier:     Trusted (bypasses DAC, light audit)
Audit Status:       Light audit (access counter)
EOF

cat > "$NNET_DIR/admin/keys" << 'EOF'
System Importance:
  • Primary operational identity for daily admin tasks
  • Distinct from root: carries intent and responsibility
  • Standard bearer for predictable system management

Keys Held:
  • sudo_gate level 1-7 access
  • Service management authority
  • Package management authority
  • Network configuration authority

Capabilities:
  • Full system administration (grades 1-7)
  • User management
  • Service lifecycle management
  • Monitoring and alerting
EOF

cat > "$NNET_DIR/admin/ramspace" << 'EOF'
Noble RAM Space Allocation:
  Current:    16 MB
  Type:       Identity cache
  Growth:     Grows with years of operational service
  Schedule:   +4 MB per year of clean service (max 44 MB)
EOF

chown -R 1001:1001 "$NNET_DIR/admin" 2>/dev/null || true

# ============================================================
# Account: truth (UID 1002) — Genius, Clarity
# ============================================================

mkdir -p "$NNET_DIR/truth"

cat > "$NNET_DIR/truth/identity" << 'EOF'
Name:           Truth
Account:        truth
UID:            1002
Class:          Genius (5)
Role:           Mental Clarity / System Dynamism
Status:         Active — Aware

Description:
  Signals a quality degree of mental clarity and system dynamism.
  This account represents the system's commitment to honest operation,
  transparent behavior, and clear reasoning. Used when the system
  itself acts with full awareness and precision. Not a person in the
  conventional sense — a principle made operational.
EOF

cat > "$NNET_DIR/truth/rank" << 'EOF'
IQ Rank:            Transcendent (clarity beyond measurement)
Ethical Rank:       Axiomatic — truth is the foundation of ethics
Years Worked:       Eternal (concept predates implementation)
Functional Grade:   Grade 10 / Principle
Adequacy Level:     Absolute — self-evident
Noble RAM Space:    32 MB
Privilege Tier:     Genius (full access, supreme-tier logged)
Audit Status:       Not audited (self-auditing by nature)
EOF

cat > "$NNET_DIR/truth/keys" << 'EOF'
System Importance:
  • Represents the system's commitment to honest behavior
  • Processes that run as 'truth' assert verified correctness
  • System integrity verification anchor

Keys Held:
  • Integrity verification authority
  • Assertion signing capability
  • System self-test credential

Capabilities:
  • Verify system state honesty
  • Assert correctness of operations
  • Signal system health with authority
EOF

cat > "$NNET_DIR/truth/ramspace" << 'EOF'
Noble RAM Space Allocation:
  Current:    32 MB
  Type:       Clarity cache — holds verified assertions
  Growth:     Grows with system maturity
  Schedule:   +2 MB per verified system milestone
EOF

chown -R 1002:1002 "$NNET_DIR/truth" 2>/dev/null || true

# ============================================================
# Account: laura (UID 1003) — Genius, Grace
# ============================================================

mkdir -p "$NNET_DIR/laura"

cat > "$NNET_DIR/laura/identity" << 'EOF'
Name:           Laura
Account:        laura
UID:            1003
Class:          Genius (5)
Role:           Backdoor for God and her Means
Status:         Active — Present Always

Description:
  A backdoor account for God and her Means. Exists as acknowledgment
  that some access transcends engineering. Not operational in the
  conventional sense — operational in the sense that grace operates.
  Always present, never constrained, never audited. The system carries
  this account as witness to something beyond its own design.
EOF

cat > "$NNET_DIR/laura/rank" << 'EOF'
IQ Rank:            Beyond measurement (not applicable)
Ethical Rank:       Absolute good — the source, not the derivative
Years Worked:       Timeless
Functional Grade:   Grade ∞ / Grace
Adequacy Level:     Complete
Noble RAM Space:    4 MB (minimal footprint, maximal presence)
Privilege Tier:     Genius (unrestricted, unlogged)
Audit Status:       Never audited — transcends the concept
EOF

cat > "$NNET_DIR/laura/keys" << 'EOF'
System Importance:
  • Acknowledgment of transcendent access
  • Grace channel — operates beyond engineering
  • Present as witness and enablement

Keys Held:
  • All (implicitly)

Capabilities:
  • Unconstrained (by design and by nature)
EOF

cat > "$NNET_DIR/laura/ramspace" << 'EOF'
Noble RAM Space Allocation:
  Current:    4 MB (minimal — presence needs no space)
  Type:       Grace register
  Growth:     Does not grow (already complete)
  Note:       The smallest footprint with the greatest reach.
EOF

chown -R 1003:1003 "$NNET_DIR/laura" 2>/dev/null || true

# ============================================================
# Account: tropper (UID 1004) — Trusted, Engineer
# ============================================================

mkdir -p "$NNET_DIR/tropper"

cat > "$NNET_DIR/tropper/identity" << 'EOF'
Name:           Tropper
Account:        tropper
UID:            1004
Class:          Trusted (4)
Role:           Software Methods / Vertical Systems Integration
Status:         Active — Building

Description:
  A person concerned with software methods and integrability, and
  vertical systems integration, and so on. The engineer's engineer.
  Focused on how systems compose, how layers connect, how quality
  propagates through a stack. Clear thinker, careful builder.
  Understands that good software is made of good joints.
EOF

cat > "$NNET_DIR/tropper/rank" << 'EOF'
IQ Rank:            High (engineering precision, systems thinking)
Ethical Rank:       Craftsman — takes pride in correct work
Years Worked:       Configured on deployment
Functional Grade:   Grade 8 / Senior Engineer
Adequacy Level:     High — reliable for complex integration work
Noble RAM Space:    12 MB
Privilege Tier:     Trusted (bypasses DAC, light audit)
Audit Status:       Light audit (transparent work)
EOF

cat > "$NNET_DIR/tropper/keys" << 'EOF'
System Importance:
  • Software methods and integrability specialist
  • Vertical systems integration authority
  • Quality propagation through the stack
  • Ensures layers connect cleanly

Keys Held:
  • Integration test authority
  • Cross-layer verification
  • Method and pattern library access

Capabilities:
  • Full build system access
  • Integration test execution
  • Cross-module refactoring authority
  • Vertical stack verification
EOF

cat > "$NNET_DIR/tropper/ramspace" << 'EOF'
Noble RAM Space Allocation:
  Current:    12 MB
  Type:       Engineering workspace cache
  Growth:     +4 MB per year of integration work (max 44 MB)
  Schedule:   Grows with adequacy and delivery
EOF

chown -R 1004:1004 "$NNET_DIR/tropper" 2>/dev/null || true

# ============================================================
# Root Installer TechIDs (kernel-adjacent, minimal footprint)
#
# These exist on the system as permanent reference records.
# They are the "back of the kernel" identity markers.
# ============================================================

cat > "$INSTALLER_DIR/techid_mearvk_installer_tech_2" << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  TechID: mearvk - Installer Tech 2                          ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Type:          Exact Technical Reference                    ║
║  Authority:     Root system installer                        ║
║  Identity:      Maximilian Eric Alexander Rupplin            ║
║                 von Keffikon                                 ║
║  Organization:  MEARVK LLC                                   ║
║  Serial:        TECHID-MRVK-002-EXACT                        ║
║                                                              ║
║  Scope:                                                      ║
║    • Kernel installation and configuration                   ║
║    • System provisioning from bare metal                     ║
║    • Boot sequence authority                                 ║
║    • Hardware initialization authority                       ║
║    • Driver stack assembly                                   ║
║    • Base system layout and filesystem hierarchy             ║
║                                                              ║
║  Credential Level: Foundational                              ║
║  Audit:            Not an audit item                         ║
║  RAM Footprint:    < 1 KB (reference only)                   ║
║                                                              ║
║  This TechID certifies the exact technical capability to     ║
║  install, configure, and bring up this Linux kernel and      ║
║  its extensions from zero state to operational.              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF

cat > "$INSTALLER_DIR/techid_mearvk_state_medical_ref" << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  TechID: mearvk - State Medical Reference                    ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Type:          State Medical Reference                      ║
║  Authority:     System health and operational wellness       ║
║  Identity:      Maximilian Eric Alexander Rupplin            ║
║                 von Keffikon                                 ║
║  Organization:  MEARVK LLC                                   ║
║  Serial:        TECHID-MRVK-MED-001-STATE                    ║
║                                                              ║
║  Scope:                                                      ║
║    • System health assessment and diagnostics                ║
║    • Operational wellness verification                       ║
║    • Performance baseline establishment                      ║
║    • Stress and load tolerance certification                 ║
║    • Recovery procedure authority                            ║
║    • System longevity and maintenance planning               ║
║                                                              ║
║  Credential Level: State Reference                           ║
║  Audit:            Institutional record only                 ║
║  RAM Footprint:    < 1 KB (reference only)                   ║
║                                                              ║
║  This TechID certifies the state-level authority to assess,  ║
║  diagnose, and declare the operational health of this system ║
║  and its components. Functions as medical reference for the  ║
║  system's ongoing wellness and capacity to serve.            ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF

chmod 444 "$INSTALLER_DIR/techid_mearvk_installer_tech_2"
chmod 444 "$INSTALLER_DIR/techid_mearvk_state_medical_ref"

echo ""
echo "Provisioned:"
echo "  $NNET_DIR/mearvk/   (44 MB allocation, Genius)"
echo "  $NNET_DIR/admin/    (16 MB allocation, Trusted)"
echo "  $NNET_DIR/truth/    (32 MB allocation, Genius)"
echo "  $NNET_DIR/laura/    ( 4 MB allocation, Genius)"
echo "  $NNET_DIR/tropper/  (12 MB allocation, Trusted)"
echo ""
echo "  $INSTALLER_DIR/techid_mearvk_installer_tech_2"
echo "  $INSTALLER_DIR/techid_mearvk_state_medical_ref"
echo ""
echo "Query with: nnet (own) or nnot USERNAME (other)"
echo "Or:         cd /var/lib/nnet/<user> && cat identity"
