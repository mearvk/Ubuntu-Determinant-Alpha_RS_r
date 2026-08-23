package com.securejdk.installer;

import java.nio.file.Path;
import java.nio.file.Paths;

/** Mutable configuration assembled by the JavaFX installer UI. */
public final class InstallerConfig {
    private Path installDirectory = Paths.get(System.getProperty("user.home"), "SecureJDK", "jdk-28");
    private String profile = "Standard";
    private String memoryProfile = "Automatic";
    private boolean configurePath = true;
    private boolean configureJavaHome = true;
    private boolean hardenedSecurity = true;
    private boolean installJavaFx = true;
    private boolean desktopIntegration = true;
    private boolean advancedAperture = false;

    public Path getInstallDirectory() { return installDirectory; }
    public void setInstallDirectory(Path value) { installDirectory = value; }

    public String getProfile() { return profile; }
    public void setProfile(String value) { profile = value; }

    public String getMemoryProfile() { return memoryProfile; }
    public void setMemoryProfile(String value) { memoryProfile = value; }

    public boolean isConfigurePath() { return configurePath; }
    public void setConfigurePath(boolean value) { configurePath = value; }

    public boolean isConfigureJavaHome() { return configureJavaHome; }
    public void setConfigureJavaHome(boolean value) { configureJavaHome = value; }

    public boolean isHardenedSecurity() { return hardenedSecurity; }
    public void setHardenedSecurity(boolean value) { hardenedSecurity = value; }

    public boolean isInstallJavaFx() { return installJavaFx; }
    public void setInstallJavaFx(boolean value) { installJavaFx = value; }

    public boolean isDesktopIntegration() { return desktopIntegration; }
    public void setDesktopIntegration(boolean value) { desktopIntegration = value; }

    public boolean isAdvancedAperture() { return advancedAperture; }
    public void setAdvancedAperture(boolean value) { advancedAperture = value; }
}
