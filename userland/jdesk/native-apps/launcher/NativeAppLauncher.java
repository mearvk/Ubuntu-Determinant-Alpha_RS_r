/*
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 *
 * JDesk Native Application Launcher
 *
 * Detects binary format (ELF, PE, Mach-O, script) and launches under the
 * JVM Memory Proxy with appropriate resource profiles. Provides the bridge
 * between JDesk desktop icons and native binary execution across all three
 * major operating systems.
 *
 * License: GPL-2.0
 */

package us.mearvk.jdesk.launcher;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.concurrent.*;

/**
 * NativeAppLauncher — Detects binary format and launches native applications
 * under the JVM Memory Proxy governance layer.
 *
 * Supports:
 *   - ELF (Linux, 32/64-bit) → direct execution
 *   - PE/PE32+ (Windows) → Wine + memory-guard
 *   - Mach-O (macOS) → Darling + memory-guard
 *   - Shebang scripts → interpreter dispatch + memory-guard
 */
public class NativeAppLauncher {

    // =========================================================================
    //  Binary Format Magic Numbers
    // =========================================================================

    private static final byte[] MAGIC_ELF     = { 0x7F, 'E', 'L', 'F' };
    private static final byte[] MAGIC_PE      = { 'M', 'Z' };
    private static final byte[] MAGIC_MACHO64 = { (byte)0xFE, (byte)0xED, (byte)0xFA, (byte)0xCF };
    private static final byte[] MAGIC_MACHO32 = { (byte)0xFE, (byte)0xED, (byte)0xFA, (byte)0xCE };
    private static final byte[] MAGIC_FAT     = { (byte)0xCA, (byte)0xFE, (byte)0xBA, (byte)0xBE };
    private static final byte[] MAGIC_SHEBANG = { '#', '!' };

    // =========================================================================
    //  Binary Format Enum
    // =========================================================================

    public enum BinaryFormat {
        ELF_64("ELF 64-bit", "linux"),
        ELF_32("ELF 32-bit", "linux"),
        PE("PE/PE32+", "windows"),
        MACHO_64("Mach-O 64-bit", "macos"),
        MACHO_32("Mach-O 32-bit", "macos"),
        MACHO_FAT("Mach-O Fat/Universal", "macos"),
        SCRIPT("Shebang Script", "linux"),
        UNKNOWN("Unknown", null);

        private final String description;
        private final String platform;

        BinaryFormat(String description, String platform) {
            this.description = description;
            this.platform = platform;
        }

        public String getDescription() { return description; }
        public String getPlatform() { return platform; }
    }

    // =========================================================================
    //  Application Manifest
    // =========================================================================

    /**
     * Represents a .jdesk-app desktop application manifest.
     */
    public static class AppManifest {
        public String name;             // Display name
        public String binaryPath;       // Path to native binary
        public String[] arguments;      // Command-line arguments
        public String iconPath;         // SVG icon path
        public String profile;          // Memory Proxy resource profile name
        public String category;         // Desktop category (office, development, internet, system)
        public boolean startOnDesktop;  // Show icon on desktop at startup
        public boolean startOnPanel;    // Show in panel/taskbar

        // Resource overrides (null = use profile defaults)
        public Long ramSoft;
        public Long ramHard;
        public Integer cpuPercent;
        public Integer threadsMax;
        public Long diskWriteRate;

        public static AppManifest load(Path manifestPath) throws IOException {
            AppManifest m = new AppManifest();
            Properties props = new Properties();
            try (InputStream is = Files.newInputStream(manifestPath)) {
                props.load(is);
            }

            m.name = props.getProperty("name", "Unknown");
            m.binaryPath = props.getProperty("binary");
            m.arguments = props.getProperty("args", "").split("\\s+");
            m.iconPath = props.getProperty("icon");
            m.profile = props.getProperty("profile", "default");
            m.category = props.getProperty("category", "other");
            m.startOnDesktop = Boolean.parseBoolean(props.getProperty("desktop", "true"));
            m.startOnPanel = Boolean.parseBoolean(props.getProperty("panel", "true"));

            String ramS = props.getProperty("ram-soft");
            if (ramS != null) m.ramSoft = parseSize(ramS);
            String ramH = props.getProperty("ram-hard");
            if (ramH != null) m.ramHard = parseSize(ramH);
            String cpu = props.getProperty("cpu");
            if (cpu != null) m.cpuPercent = Integer.parseInt(cpu);
            String threads = props.getProperty("threads");
            if (threads != null) m.threadsMax = Integer.parseInt(threads);
            String diskW = props.getProperty("disk-write");
            if (diskW != null) m.diskWriteRate = parseSize(diskW);

            return m;
        }
    }

    // =========================================================================
    //  Format Detection
    // =========================================================================

    /**
     * Detect the binary format of a file by reading its magic bytes.
     */
    public static BinaryFormat detectFormat(Path binaryPath) throws IOException {
        byte[] header = new byte[64];
        int bytesRead;
        try (InputStream is = Files.newInputStream(binaryPath)) {
            bytesRead = is.read(header);
        }

        if (bytesRead < 4) return BinaryFormat.UNKNOWN;

        // ELF: \x7fELF
        if (matches(header, MAGIC_ELF)) {
            if (bytesRead >= 5) {
                // EI_CLASS: 1 = 32-bit, 2 = 64-bit
                return header[4] == 2 ? BinaryFormat.ELF_64 : BinaryFormat.ELF_32;
            }
            return BinaryFormat.ELF_64;
        }

        // PE: MZ (DOS stub)
        if (matches(header, MAGIC_PE)) {
            return BinaryFormat.PE;
        }

        // Mach-O 64-bit
        if (matches(header, MAGIC_MACHO64)) {
            return BinaryFormat.MACHO_64;
        }

        // Mach-O 32-bit
        if (matches(header, MAGIC_MACHO32)) {
            return BinaryFormat.MACHO_32;
        }

        // Mach-O Fat/Universal
        if (matches(header, MAGIC_FAT)) {
            return BinaryFormat.MACHO_FAT;
        }

        // Shebang script
        if (matches(header, MAGIC_SHEBANG)) {
            return BinaryFormat.SCRIPT;
        }

        return BinaryFormat.UNKNOWN;
    }

    // =========================================================================
    //  Launch Engine
    // =========================================================================

    /**
     * Launch a native application under JVM Memory Proxy governance.
     *
     * @param manifest Application manifest
     * @return Process handle for the launched application
     */
    public static Process launch(AppManifest manifest) throws IOException {
        Path binaryPath = Path.of(manifest.binaryPath);

        if (!Files.exists(binaryPath)) {
            throw new FileNotFoundException("Binary not found: " + manifest.binaryPath);
        }

        BinaryFormat format = detectFormat(binaryPath);
        List<String> command = buildCommand(format, manifest);

        ProcessBuilder pb = new ProcessBuilder(command);
        pb.inheritIO();
        pb.environment().put("JDESK_APP_NAME", manifest.name);
        pb.environment().put("JDESK_APP_PROFILE", manifest.profile);

        System.out.printf("[JDesk] Launching: %s (%s)%n", manifest.name, format.getDescription());
        System.out.printf("[JDesk] Profile: %s | RAM: %s/%s | CPU: %s%%%n",
                manifest.profile,
                formatSize(manifest.ramSoft),
                formatSize(manifest.ramHard),
                manifest.cpuPercent != null ? manifest.cpuPercent : "default");

        return pb.start();
    }

    /**
     * Build the full command line based on binary format.
     */
    private static List<String> buildCommand(BinaryFormat format, AppManifest manifest) {
        List<String> cmd = new ArrayList<>();

        // JVM memory-guard prefix
        cmd.add("java");
        cmd.add("-memory-guard");

        // Resource profile
        cmd.add("-Xguard:profile=" + manifest.profile);

        // Resource overrides
        if (manifest.ramSoft != null) {
            cmd.add("-Xguard:ram-soft=" + formatSizeFlag(manifest.ramSoft));
        }
        if (manifest.ramHard != null) {
            cmd.add("-Xguard:ram-hard=" + formatSizeFlag(manifest.ramHard));
        }
        if (manifest.cpuPercent != null) {
            cmd.add("-Xguard:cpu=" + manifest.cpuPercent);
        }
        if (manifest.threadsMax != null) {
            cmd.add("-Xguard:threads=" + manifest.threadsMax);
        }
        if (manifest.diskWriteRate != null) {
            cmd.add("-Xguard:disk-write=" + formatSizeFlag(manifest.diskWriteRate));
        }

        // Status reporting to JDesk panel
        cmd.add("-Xguard:status=5s");

        // Platform-specific execution wrapper
        switch (format) {
            case ELF_64:
            case ELF_32:
            case SCRIPT:
                // Direct execution — no translation layer needed
                cmd.add(manifest.binaryPath);
                break;

            case PE:
                // Windows binary — invoke via Wine
                cmd.add("wine");
                cmd.add(manifest.binaryPath);
                break;

            case MACHO_64:
            case MACHO_32:
            case MACHO_FAT:
                // macOS binary — invoke via Darling
                cmd.add("darling");
                cmd.add("shell");
                cmd.add(manifest.binaryPath);
                break;

            default:
                // Try direct execution for unknown formats with +x bit
                cmd.add(manifest.binaryPath);
                break;
        }

        // Application arguments
        if (manifest.arguments != null) {
            for (String arg : manifest.arguments) {
                if (!arg.isEmpty()) {
                    cmd.add(arg);
                }
            }
        }

        return cmd;
    }

    // =========================================================================
    //  Desktop Icon Registration
    // =========================================================================

    private static final Path MANIFESTS_DIR = Path.of("/opt/jdesk/manifests");
    private static final Path ICONS_DIR = Path.of("/opt/jdesk/icons");

    /**
     * Load all registered desktop applications (for startup icon placement).
     */
    public static List<AppManifest> loadAllManifests() throws IOException {
        List<AppManifest> apps = new ArrayList<>();

        if (!Files.isDirectory(MANIFESTS_DIR)) {
            return apps;
        }

        try (DirectoryStream<Path> stream = Files.newDirectoryStream(MANIFESTS_DIR, "*.jdesk-app")) {
            for (Path entry : stream) {
                try {
                    AppManifest m = AppManifest.load(entry);
                    apps.add(m);
                } catch (Exception e) {
                    System.err.printf("[JDesk] Warning: Failed to load manifest %s: %s%n",
                            entry.getFileName(), e.getMessage());
                }
            }
        }

        return apps;
    }

    /**
     * Get applications that should appear on the desktop at startup.
     */
    public static List<AppManifest> getDesktopApps() throws IOException {
        List<AppManifest> all = loadAllManifests();
        List<AppManifest> desktop = new ArrayList<>();
        for (AppManifest m : all) {
            if (m.startOnDesktop) desktop.add(m);
        }
        return desktop;
    }

    /**
     * Get applications that should appear in the panel/taskbar.
     */
    public static List<AppManifest> getPanelApps() throws IOException {
        List<AppManifest> all = loadAllManifests();
        List<AppManifest> panel = new ArrayList<>();
        for (AppManifest m : all) {
            if (m.startOnPanel) panel.add(m);
        }
        return panel;
    }

    // =========================================================================
    //  Utility Methods
    // =========================================================================

    private static boolean matches(byte[] data, byte[] magic) {
        if (data.length < magic.length) return false;
        for (int i = 0; i < magic.length; i++) {
            if (data[i] != magic[i]) return false;
        }
        return true;
    }

    /**
     * Parse human-readable size string (e.g., "512m", "4g", "100k").
     */
    private static long parseSize(String s) {
        s = s.trim().toLowerCase();
        long multiplier = 1;
        if (s.endsWith("k")) { multiplier = 1024L; s = s.substring(0, s.length() - 1); }
        else if (s.endsWith("m")) { multiplier = 1024L * 1024; s = s.substring(0, s.length() - 1); }
        else if (s.endsWith("g")) { multiplier = 1024L * 1024 * 1024; s = s.substring(0, s.length() - 1); }
        return Long.parseLong(s) * multiplier;
    }

    private static String formatSize(Long bytes) {
        if (bytes == null) return "default";
        if (bytes >= 1024L * 1024 * 1024) return (bytes / (1024L * 1024 * 1024)) + " GB";
        if (bytes >= 1024L * 1024) return (bytes / (1024L * 1024)) + " MB";
        if (bytes >= 1024L) return (bytes / 1024L) + " KB";
        return bytes + " B";
    }

    private static String formatSizeFlag(Long bytes) {
        if (bytes >= 1024L * 1024 * 1024) return (bytes / (1024L * 1024 * 1024)) + "g";
        if (bytes >= 1024L * 1024) return (bytes / (1024L * 1024)) + "m";
        return bytes.toString();
    }

    // =========================================================================
    //  Main (for testing / CLI usage)
    // =========================================================================

    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.out.println("Usage: NativeAppLauncher <manifest.jdesk-app>");
            System.out.println("       NativeAppLauncher --detect <binary>");
            System.out.println("       NativeAppLauncher --list");
            System.exit(1);
        }

        if ("--detect".equals(args[0]) && args.length >= 2) {
            Path p = Path.of(args[1]);
            BinaryFormat fmt = detectFormat(p);
            System.out.printf("File: %s%nFormat: %s%nPlatform: %s%n",
                    p, fmt.getDescription(), fmt.getPlatform());
            return;
        }

        if ("--list".equals(args[0])) {
            List<AppManifest> apps = loadAllManifests();
            System.out.printf("Registered applications: %d%n%n", apps.size());
            for (AppManifest m : apps) {
                Path bp = Path.of(m.binaryPath);
                BinaryFormat fmt = Files.exists(bp) ? detectFormat(bp) : BinaryFormat.UNKNOWN;
                System.out.printf("  %-20s  %-15s  %s%n", m.name, fmt.getDescription(), m.binaryPath);
            }
            return;
        }

        // Load manifest and launch
        AppManifest manifest = AppManifest.load(Path.of(args[0]));
        Process proc = launch(manifest);
        proc.waitFor();
        System.out.printf("[JDesk] %s exited with code %d%n", manifest.name, proc.exitValue());
    }
}
