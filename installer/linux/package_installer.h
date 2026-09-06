/* SPDX-License-Identifier: GPL-2.0 */
/*
 * package_installer.h — constants for the White Edition package-installer ELF.
 *
 * package-installer installs the repository's package software either by
 * "disc" (a named bundle of components) or by "function" (all components whose
 * declared role/function matches a requested keyword). Unlike white-installer,
 * which is a control plane that delegates to the Bash engine, package-installer
 * installs DIRECTLY: it copies the resolved install artifacts into the target
 * location families under /user and /deck.
 *
 * The component/source/name/default data is single-sourced from
 * installer/install-manifest.txt so this binary and the rest of the installer
 * stay in sync.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */
#ifndef PACKAGE_INSTALLER_H
#define PACKAGE_INSTALLER_H

#define PKG_VERSION "1.0"
#define PKG_PROGRAM "package-installer"
#define PKG_EDITION "Ubuntu Determinant — White Edition Package Installer"

/* Manifest describing the installable package software (component|source|name|default). */
#define PKG_INSTALL_MANIFEST "installer/install-manifest.txt"

/*
 * Direct-install destination roots. Per the White Edition install contract the
 * package software is installed into BOTH the /user and /deck trees.
 */
#define PKG_USER_ROOT "/user"
#define PKG_DECK_ROOT "/deck"
#define PKG_BIN_SUBDIR "bin"

/* Upper bounds kept generous but fixed so the binary needs no heap growth. */
#define PKG_MAX_COMPONENTS 256
#define PKG_MAX_FIELD 256

#endif /* PACKAGE_INSTALLER_H */
