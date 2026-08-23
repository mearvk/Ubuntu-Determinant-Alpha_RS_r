package com.securejdk.installer;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Performs the non-UI portion of installation.
 *
 * The first implementation deliberately creates a manifest/staging area rather
 * than pretending to install a JDK artifact that has not yet been selected.
 */
public final class InstallerEngine {
    public void stage(InstallerConfig config, ProgressListener listener) throws IOException {
        Path root = config.getInstallDirectory();
        Files.createDirectories(root);
        listener.update(0.20, "Preparing Secure JDK 28 destination");

        Files.createDirectories(root.resolve("conf"));
        Files.createDirectories(root.resolve("lib"));
        Files.createDirectories(root.resolve("legal"));
        listener.update(0.45, "Preparing configuration and legal metadata");

        String manifest = "Secure JDK 28\n"
                + "profile=" + config.getProfile() + "\n"
                + "memoryProfile=" + config.getMemoryProfile() + "\n"
                + "hardenedSecurity=" + config.isHardenedSecurity() + "\n"
                + "javafx=" + config.isInstallJavaFx() + "\n";
        Files.writeString(root.resolve("conf/securejdk-installer.manifest"), manifest);
        listener.update(0.75, "Writing Secure JDK configuration manifest");

        listener.update(1.0, "Staging complete");
    }

    @FunctionalInterface
    public interface ProgressListener {
        void update(double progress, String message);
    }
}
