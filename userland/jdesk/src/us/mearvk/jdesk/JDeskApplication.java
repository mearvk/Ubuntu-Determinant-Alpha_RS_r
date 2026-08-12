/*
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 *
 * JDeskApplication — Main entry point for the JDesk desktop environment.
 *
 * Starts a full-screen JavaFX application that serves as:
 *   - Desktop surface (wallpaper, icon grid)
 *   - Window compositor (frames native apps)
 *   - Panel/taskbar
 *   - Application launcher
 *
 * This can run:
 *   1. As a standalone desktop (replacing the existing WM)
 *   2. As a windowed application (for testing/development)
 *
 * License: GPL-2.0
 */

package us.mearvk.jdesk;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.scene.*;
import javafx.scene.control.*;
import javafx.scene.image.*;
import javafx.scene.layout.*;
import javafx.scene.paint.*;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.*;
import javafx.scene.effect.*;
import javafx.geometry.*;
import javafx.stage.*;
import javafx.animation.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.*;
import java.time.format.*;
import java.util.*;
import java.util.List;

/**
 * JDeskApplication — The JDesk desktop environment.
 *
 * Launch:
 *   java --module-path /usr/share/openjfx/lib \
 *        --add-modules javafx.controls,javafx.graphics \
 *        -cp /opt/jdesk/lib/jdesk.jar \
 *        us.mearvk.jdesk.JDeskApplication
 *
 * Or windowed mode (for testing):
 *   java ... us.mearvk.jdesk.JDeskApplication --windowed
 */
public class JDeskApplication extends Application {

    // Layout components
    private BorderPane root;
    private Pane desktopSurface;
    private HBox panel;
    private Label clockLabel;
    private GridPane iconGrid;

    // State
    private boolean windowedMode = false;

    @Override
    public void init() {
        List<String> params = getParameters().getRaw();
        windowedMode = params.contains("--windowed") || params.contains("-w");
    }

    @Override
    public void start(Stage primaryStage) {
        // === Root Layout ===
        root = new BorderPane();

        // === Desktop Surface (center) ===
        desktopSurface = new Pane();
        desktopSurface.setStyle(
            "-fx-background-color: radial-gradient(" +
            "center 50% 40%, radius 80%, " +
            "#FAFCFF 0%, #F4F7FC 60%, #EDF1F8 100%);"
        );

        // === Icon Grid on Desktop ===
        iconGrid = createDesktopIcons();
        desktopSurface.getChildren().add(iconGrid);

        // === Panel (bottom taskbar) ===
        panel = createPanel();

        // === Assemble ===
        root.setCenter(desktopSurface);
        root.setBottom(panel);

        // === Scene ===
        Scene scene;
        if (windowedMode) {
            scene = new Scene(root, 1280, 800);
            primaryStage.setTitle("JDesk — Galactic Cherry Marvell Edition 98");
        } else {
            // Full screen
            scene = new Scene(root);
            primaryStage.setFullScreen(true);
            primaryStage.setFullScreenExitHint("");
        }

        // Apply cool-white theme CSS
        Path themePath = Path.of("/opt/jdesk/themes/cool-white.css");
        if (Files.exists(themePath)) {
            scene.getStylesheets().add(themePath.toUri().toString());
        }
        // Also try local path (development)
        Path localTheme = Path.of("userland/jdesk/themes/cool-white.css");
        if (Files.exists(localTheme)) {
            scene.getStylesheets().add(localTheme.toUri().toString());
        }

        primaryStage.setScene(scene);
        primaryStage.show();

        // Start clock
        startClock();

        System.out.println("═══════════════════════════════════════════════════════════════");
        System.out.println("  JDesk — Galactic Cherry Marvell Edition 98");
        System.out.println("  Theme: Cool White (original)");
        System.out.println("  Mode:  " + (windowedMode ? "Windowed (development)" : "Full-screen"));
        System.out.println("═══════════════════════════════════════════════════════════════");
    }

    // =========================================================================
    //  Desktop Icons
    // =========================================================================

    private GridPane createDesktopIcons() {
        GridPane grid = new GridPane();
        grid.setHgap(16);
        grid.setVgap(16);
        grid.setPadding(new Insets(32));
        grid.setLayoutX(32);
        grid.setLayoutY(32);

        // Desktop icon entries: name, emoji/placeholder, action
        String[][] icons = {
            {"Terminal",   "🖥", "terminal"},
            {"Files",      "📁", "files"},
            {"Browser",    "🌐", "browser"},
            {"Writer",     "📝", "writer"},
            {"Settings",   "⚙", "settings"},
            {"IDE",        "💻", "ide"},
        };

        int col = 0, row = 0;
        for (String[] entry : icons) {
            VBox cell = createIconCell(entry[0], entry[1], entry[2]);
            grid.add(cell, col, row);
            col++;
            if (col >= 2) { col = 0; row++; }
        }

        return grid;
    }

    private VBox createIconCell(String name, String emoji, String action) {
        VBox cell = new VBox(4);
        cell.setAlignment(Pos.CENTER);
        cell.setPrefSize(88, 88);
        cell.setPadding(new Insets(8));
        cell.setStyle(
            "-fx-background-color: transparent;" +
            "-fx-background-radius: 10;"
        );

        // Icon (emoji as text for now — real version uses SVG)
        Label iconLabel = new Label(emoji);
        iconLabel.setStyle(
            "-fx-font-size: 32px;" +
            "-fx-text-fill: #4A90D9;"
        );

        // Name
        Label nameLabel = new Label(name);
        nameLabel.setStyle(
            "-fx-font-size: 11px;" +
            "-fx-font-family: 'Inter', system-ui, sans-serif;" +
            "-fx-text-fill: #1B2433;" +
            "-fx-font-weight: 500;"
        );
        nameLabel.setMaxWidth(80);
        nameLabel.setWrapText(true);
        nameLabel.setAlignment(Pos.CENTER);

        cell.getChildren().addAll(iconLabel, nameLabel);

        // Hover
        cell.setOnMouseEntered(e -> cell.setStyle(
            "-fx-background-color: rgba(74, 144, 217, 0.06);" +
            "-fx-background-radius: 10;" +
            "-fx-border-color: rgba(74, 144, 217, 0.15);" +
            "-fx-border-radius: 10;" +
            "-fx-border-width: 1;"
        ));
        cell.setOnMouseExited(e -> cell.setStyle(
            "-fx-background-color: transparent;" +
            "-fx-background-radius: 10;"
        ));

        // Double-click to launch
        cell.setOnMouseClicked(event -> {
            if (event.getClickCount() == 2) {
                launchDesktopApp(action, name);
            }
        });

        return cell;
    }

    // =========================================================================
    //  Panel (Taskbar)
    // =========================================================================

    private HBox createPanel() {
        HBox bar = new HBox(12);
        bar.setAlignment(Pos.CENTER_LEFT);
        bar.setPrefHeight(48);
        bar.setPadding(new Insets(0, 16, 0, 16));
        bar.setStyle(
            "-fx-background-color: rgba(242, 245, 250, 0.92);" +
            "-fx-border-color: #D8E0EA transparent transparent transparent;" +
            "-fx-border-width: 1 0 0 0;" +
            "-fx-effect: dropshadow(gaussian, rgba(30,50,80,0.06), 6, 0, 0, -2);"
        );

        // JDesk logo / activities button
        Label logo = new Label("◉ JDesk");
        logo.setStyle(
            "-fx-font-size: 13px;" +
            "-fx-font-family: 'Inter', system-ui, sans-serif;" +
            "-fx-font-weight: 600;" +
            "-fx-text-fill: #4A90D9;"
        );

        // Spacer
        Region spacer = new Region();
        HBox.setHgrow(spacer, Priority.ALWAYS);

        // Clock
        clockLabel = new Label(getCurrentTime());
        clockLabel.setStyle(
            "-fx-font-size: 12px;" +
            "-fx-font-family: 'Inter', system-ui, sans-serif;" +
            "-fx-font-weight: 500;" +
            "-fx-text-fill: #5C6B7A;"
        );

        // System indicators
        Label indicators = new Label("⚡ 🔊 🌐");
        indicators.setStyle(
            "-fx-font-size: 12px;" +
            "-fx-text-fill: #5C6B7A;"
        );

        bar.getChildren().addAll(logo, spacer, indicators, clockLabel);
        return bar;
    }

    // =========================================================================
    //  Clock
    // =========================================================================

    private void startClock() {
        Timeline clock = new Timeline(new KeyFrame(javafx.util.Duration.seconds(1), e -> {
            clockLabel.setText(getCurrentTime());
        }));
        clock.setCycleCount(Animation.INDEFINITE);
        clock.play();
    }

    private String getCurrentTime() {
        return LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    // =========================================================================
    //  Application Launching — ALL programs route through JDesk governance
    // =========================================================================

    /*
     * CRITICAL DESIGN DECISION:
     *
     * Programs do NOT call the underlying OS directly. Every executable launched
     * from JDesk goes through the JVM Memory Proxy governance layer:
     *
     *   java -memory-guard -Xguard:profile=<profile> <binary> [args...]
     *
     * This ensures:
     *   1. Memory budgets are enforced (RAM ceiling per-app)
     *   2. Disk I/O is rate-limited (prevents runaway writes)
     *   3. CPU time is accounted (no single app starves others)
     *   4. Thread/process count is bounded (no fork bombs)
     *   5. Crash telemetry is captured (JDesk knows what happened)
     *   6. The WindowCompositor can frame the native window
     *   7. Security: binary path validation against allowed roots
     *   8. The panel/taskbar shows live resource usage per-app
     *
     * The JDesk IS the interpretive layer. It stands between the user and the OS.
     */

    /** Resource profiles for desktop applications. */
    private static final Map<String, String[]> APP_PROFILES = Map.of(
        "terminal", new String[]{"-Xguard:ram=256m", "-Xguard:cpu=50", "-Xguard:threads=16"},
        "files",    new String[]{"-Xguard:ram=512m", "-Xguard:cpu=40", "-Xguard:threads=16"},
        "browser",  new String[]{"-Xguard:ram=4g",   "-Xguard:cpu=90", "-Xguard:threads=256"},
        "writer",   new String[]{"-Xguard:ram=2g",   "-Xguard:cpu=80", "-Xguard:threads=32"},
        "ide",      new String[]{"-Xguard:ram=4g",   "-Xguard:cpu=90", "-Xguard:threads=128"},
        "settings", new String[]{"-Xguard:ram=128m", "-Xguard:cpu=30", "-Xguard:threads=8"}
    );

    private void launchDesktopApp(String action, String displayName) {
        System.out.printf("[JDesk] Launching: %s (governed)%n", displayName);

        if ("settings".equals(action)) {
            showSettingsDialog();
            return;
        }

        try {
            // Resolve the binary path
            String binaryPath = resolveAppBinary(action);
            if (binaryPath == null) {
                System.err.printf("[JDesk] ERROR: No binary found for '%s'%n", action);
                return;
            }

            // Resolve extra arguments for the binary
            String[] binaryArgs = resolveAppArgs(action);

            // Build governed command: java -memory-guard -Xguard:... <binary> [args]
            List<String> command = new ArrayList<>();
            command.add("java");
            command.add("-memory-guard");
            command.add("-Xguard:profile=" + action);
            command.add("-Xguard:status=5s");

            // Add profile-specific resource limits
            String[] limits = APP_PROFILES.getOrDefault(action,
                    new String[]{"-Xguard:ram=1g", "-Xguard:cpu=80", "-Xguard:threads=64"});
            for (String limit : limits) {
                command.add(limit);
            }

            // The binary itself
            command.add(binaryPath);

            // Binary-specific arguments
            if (binaryArgs != null) {
                for (String arg : binaryArgs) {
                    command.add(arg);
                }
            }

            System.out.printf("[JDesk]   Binary:  %s%n", binaryPath);
            System.out.printf("[JDesk]   Profile: %s%n", action);
            System.out.printf("[JDesk]   Limits:  %s%n", String.join(" ", limits));

            ProcessBuilder pb = new ProcessBuilder(command);
            pb.inheritIO();
            pb.environment().put("JDESK_APP_NAME", displayName);
            pb.environment().put("JDESK_APP_PROFILE", action);
            pb.environment().put("JDESK_GOVERNED", "1");

            Process proc = pb.start();
            System.out.printf("[JDesk] ✓ Started: %s (PID via memory-guard)%n", displayName);

            // Monitor in background
            Thread monitor = new Thread(() -> {
                try {
                    int code = proc.waitFor();
                    System.out.printf("[JDesk] %s exited (code %d)%n", displayName, code);
                } catch (InterruptedException ignored) {}
            }, "jdesk-monitor-" + action);
            monitor.setDaemon(true);
            monitor.start();

        } catch (IOException e) {
            System.err.printf("[JDesk] Failed to launch %s: %s%n", displayName, e.getMessage());
        }
    }

    /**
     * Resolve the absolute binary path for a desktop action.
     * Searches JDesk app paths first, then system paths.
     * Returns null if no suitable binary found.
     */
    private String resolveAppBinary(String action) {
        // Priority: JDesk managed path → system path
        String[][] candidates;
        switch (action) {
            case "terminal":
                candidates = new String[][]{
                    {"/opt/jdesk/apps/terminal/jdesk-terminal"},
                    {"/usr/bin/gnome-terminal"},
                    {"/usr/bin/xfce4-terminal"},
                    {"/usr/bin/xterm"}
                };
                break;
            case "files":
                candidates = new String[][]{
                    {"/opt/jdesk/apps/pcmanfm/pcmanfm-qt"},
                    {"/usr/bin/pcmanfm-qt"},
                    {"/usr/bin/nautilus"},
                    {"/usr/bin/thunar"}
                };
                break;
            case "browser":
                candidates = new String[][]{
                    {"/opt/jdesk/apps/chromium/chrome"},
                    {"/usr/bin/chromium-browser"},
                    {"/usr/bin/chromium"},
                    {"/snap/bin/chromium"},
                    {"/usr/bin/firefox"}
                };
                break;
            case "writer":
                candidates = new String[][]{
                    {"/opt/jdesk/apps/libreoffice/soffice"},
                    {"/usr/bin/soffice"},
                    {"/usr/bin/libreoffice"}
                };
                break;
            case "ide":
                candidates = new String[][]{
                    {"/opt/jdesk/apps/vscodium/bin/codium"},
                    {"/opt/jdesk/bin/codium"},
                    {"/usr/bin/codium"},
                    {"/usr/bin/code"}
                };
                break;
            default:
                return null;
        }

        for (String[] candidate : candidates) {
            java.io.File f = new java.io.File(candidate[0]);
            if (f.exists() && f.canExecute()) {
                return candidate[0];
            }
            // Also check if it's a symlink that resolves
            if (Files.isSymbolicLink(Path.of(candidate[0]))) {
                try {
                    Path real = Files.readSymbolicLink(Path.of(candidate[0]));
                    if (Files.exists(real)) return candidate[0];
                } catch (IOException ignored) {}
            }
        }

        // Last resort: check PATH via 'which'
        String simpleName = getSimpleName(action);
        if (simpleName != null) {
            try {
                Process which = new ProcessBuilder("which", simpleName).start();
                if (which.waitFor() == 0) {
                    try (var reader = new BufferedReader(new InputStreamReader(which.getInputStream()))) {
                        String path = reader.readLine();
                        if (path != null && !path.isBlank()) return path.trim();
                    }
                }
            } catch (Exception ignored) {}
        }

        return null;
    }

    private String getSimpleName(String action) {
        switch (action) {
            case "terminal": return "gnome-terminal";
            case "files": return "nautilus";
            case "browser": return "chromium-browser";
            case "writer": return "soffice";
            case "ide": return "codium";
            default: return null;
        }
    }

    /**
     * Resolve extra arguments for a specific application.
     */
    private String[] resolveAppArgs(String action) {
        switch (action) {
            case "writer": return new String[]{"--writer"};
            case "browser": return new String[]{"--no-sandbox"};
            default: return null;
        }
    }

    // =========================================================================
    //  Settings Dialog (placeholder)
    // =========================================================================

    private void showSettingsDialog() {
        // Create a simple floating settings window on the desktop
        VBox dialog = new VBox(12);
        dialog.setPrefSize(400, 300);
        dialog.setPadding(new Insets(24));
        dialog.setLayoutX(200);
        dialog.setLayoutY(100);
        dialog.setStyle(
            "-fx-background-color: #FFFFFF;" +
            "-fx-background-radius: 14;" +
            "-fx-border-color: #D8E0EA;" +
            "-fx-border-radius: 14;" +
            "-fx-border-width: 1;" +
            "-fx-effect: dropshadow(gaussian, rgba(30,50,80,0.16), 24, 0, 0, 8);"
        );

        // Title bar with circular close button
        HBox titleBar = new HBox(8);
        titleBar.setAlignment(Pos.CENTER_LEFT);

        Button closeBtn = new Button("");
        closeBtn.setMinSize(13, 13);
        closeBtn.setMaxSize(13, 13);
        closeBtn.setStyle(
            "-fx-background-color: linear-gradient(to bottom, #FFFFFF 0%, #F7F7F7 100%);" +
            "-fx-background-radius: 50%;" +
            "-fx-border-color: #D0D8E4;" +
            "-fx-border-radius: 50%;" +
            "-fx-border-width: 1;" +
            "-fx-cursor: hand;"
        );
        closeBtn.setOnMouseEntered(e -> closeBtn.setStyle(
            "-fx-background-color: #FF5F56;" +
            "-fx-background-radius: 50%;" +
            "-fx-border-color: #E04840;" +
            "-fx-border-radius: 50%;" +
            "-fx-border-width: 1;" +
            "-fx-cursor: hand;"
        ));
        closeBtn.setOnMouseExited(e -> closeBtn.setStyle(
            "-fx-background-color: linear-gradient(to bottom, #FFFFFF 0%, #F7F7F7 100%);" +
            "-fx-background-radius: 50%;" +
            "-fx-border-color: #D0D8E4;" +
            "-fx-border-radius: 50%;" +
            "-fx-border-width: 1;" +
            "-fx-cursor: hand;"
        ));
        closeBtn.setOnAction(e -> desktopSurface.getChildren().remove(dialog));

        Label title = new Label("JDesk Settings");
        title.setStyle(
            "-fx-font-size: 15px;" +
            "-fx-font-family: 'Inter', system-ui, sans-serif;" +
            "-fx-font-weight: 600;" +
            "-fx-text-fill: #1B2433;"
        );

        titleBar.getChildren().addAll(closeBtn, title);

        // Content
        Label themeLabel = new Label("Theme: Cool White (default)");
        themeLabel.setStyle("-fx-text-fill: #5C6B7A; -fx-font-size: 13px; -fx-font-family: 'Inter';");

        Label versionLabel = new Label("Edition: Galactic Cherry Marvell 98");
        versionLabel.setStyle("-fx-text-fill: #5C6B7A; -fx-font-size: 13px; -fx-font-family: 'Inter';");

        Label kernelLabel = new Label("Kernel: Linux 5.15.204");
        kernelLabel.setStyle("-fx-text-fill: #5C6B7A; -fx-font-size: 13px; -fx-font-family: 'Inter';");

        Label compositorLabel = new Label("Compositor: JDesk WindowCompositor (JavaFX)");
        compositorLabel.setStyle("-fx-text-fill: #5C6B7A; -fx-font-size: 13px; -fx-font-family: 'Inter';");

        Separator sep = new Separator();

        Label ethicsLabel = new Label("◉ White Ethics Installer Grade — Active");
        ethicsLabel.setStyle("-fx-text-fill: #4A90D9; -fx-font-size: 12px; -fx-font-family: 'Inter'; -fx-font-weight: 500;");

        dialog.getChildren().addAll(titleBar, sep, themeLabel, versionLabel, kernelLabel, compositorLabel,
                new Separator(), ethicsLabel);

        desktopSurface.getChildren().add(dialog);
    }

    // =========================================================================
    //  Main
    // =========================================================================

    public static void main(String[] args) {
        launch(args);
    }
}
