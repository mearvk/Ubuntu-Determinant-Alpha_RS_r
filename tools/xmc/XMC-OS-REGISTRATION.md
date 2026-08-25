# XMC ASYSMA OS Registration Contract

Every XMC compilation that produces an `.asysma` application must establish an OS integration handshake for the generated application.

## Linux

Register `application/x-asysma`, install the application's `.desktop` launcher in the user's application directory, refresh the desktop database when available, and ensure the launcher identifies the generated `.asysma` executable and XMC icon.

## Windows

Register `.asysma` under the current user's Classes hive with the `XMC.ASYSMA` ProgID and an open command that launches the generated artifact. User-level registration avoids requiring administrator privileges for ordinary compilation.

## macOS

Register the generated application bundle with Launch Services. The application bundle should declare the ASYSMA document type and icon through its Info.plist/UTExportedTypeDeclarations as part of the final packaging stage.

## Compilation requirement

OS registration is part of ASYSMA composition, not an optional afterthought. If registration cannot be performed, XMC must report the failure clearly. Compilation must not silently claim that desktop/file integration succeeded.

The registration layer is target-specific but is called from the same XMC C integration path. It must never silently elevate privileges or overwrite unrelated file associations.
