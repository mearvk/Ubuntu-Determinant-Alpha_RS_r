/*
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 *
 * JDesk Desktop Startup — Places native application icons on the desktop
 * and registers them with the panel at JDesk startup.
 *
 * License: GPL-2.0
 */

package us.mearvk.jdesk.desktop;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import javafx.scene.layout.*;
import javafx.scene.image.*;
import javafx.scene.control.*;
import javafx.scene.input.*;
import javafx.geometry.*;

import us.mearvk.jdesk.launcher.NativeAppLauncher;
import us.mearvk.jdesk.launcher.NativeAppLauncher.AppManifest;
import us.mearvk.jdesk.launcher.NativeAppLauncher.BinaryFormat;
import us.mearvk.jdesk.theme.WhiteTheme;

/**
 * DesktopIconGrid — Manages desktop icon placement and interaction.
 *
 * At startup:
 *   1. Loads all .jdesk-app manifests from /opt/jdesk/manifests/
 *   2. Filters for desktop=true applications
 *   3. Places icons in a grid on the desktop surface
 *   4. Registers double-click → launch via NativeAppLauncher
 *
 * Default startup icons (in grid order):
 *   [Writer]   [IDE]      [Browser]   [Terminal]
 *   [Files]    [Settings]
 */
public class DesktopIconGrid extends GridPane {

    // Grid configuration
    private static final int ICON_SIZE = 64;
    private static final int CELL_WIDTH = 96;
    private static final int CELL_HEIGHT = 96;
    private static final int GRID_COLUMNS = 6;
    private static final int GRID_PADDING = 24;
    private static final int LABEL_MAX_WIDTH = 80;

    // Running processes (tracked for panel status)
    private final Map<String, Process> runningApps = new LinkedHashMap<>();

    // Panel reference for status updates
    private Pane panel;

    public DesktopIconGrid() {
        setHgap(16);
        setVgap(16);
        setPadding(new Insets(GRID_PADDING));
        setAlignment(Pos.TOP_LEFT);
    }

    /**
     * Load and place all desktop application icons.
     * Called once at JDesk startup.
     */
    public void loadDesktopApps() {
        try {
            List<AppManifest> apps = NativeAppLauncher.getDesktopApps();

            int col = 0;
            int row = 0;

            for (AppManifest app : apps) {
                VBox iconCell = createIconCell(app);
                add(iconCell, col, row);

                col++;
                if (col >= GRID_COLUMNS) {
                    col = 0;
                    row++;
                }
            }

            System.out.printf("[JDesk] Desktop: %d application icons placed%n", apps.size());

        } catch (IOException e) {
            System.err.printf("[JDesk] Error loading desktop apps: %s%n", e.getMessage());
        }
    }

    /**
     * Create a single desktop icon cell (icon + label).
     */
    private VBox createIconCell(AppManifest app) {
        VBox cell = new VBox(4);
        cell.setAlignment(Pos.CENTER);
        cell.setPrefSize(CELL_WIDTH, CELL_HEIGHT);

        // Load SVG icon
        ImageView icon = loadIcon(app.iconPath, ICON_SIZE);

        // Application name label
        Label label = new Label(app.name);
        label.setMaxWidth(LABEL_MAX_WIDTH);
        label.setWrapText(true);
        label.setAlignment(Pos.CENTER);
        label.setStyle("-fx-text-fill: #202124; -fx-font-size: 11px; -fx-font-family: 'Inter';");

        cell.getChildren().addAll(icon, label);

        // Hover effect
        cell.setOnMouseEntered(e -> cell.setStyle("-fx-background-color: #F1F3F4; -fx-background-radius: 8;"));
        cell.setOnMouseExited(e -> cell.setStyle(""));

        // Double-click to launch
        cell.setOnMouseClicked(event -> {
            if (event.getClickCount() == 2) {
                launchApp(app);
            }
        });

        return cell;
    }

    /**
     * Launch an application via the NativeAppLauncher.
     */
    private void launchApp(AppManifest app) {
        try {
            // Check if already running
            if (runningApps.containsKey(app.name)) {
                Process existing = runningApps.get(app.name);
                if (existing.isAlive()) {
                    System.out.printf("[JDesk] %s is already running (PID active)%n", app.name);
                    // TODO: bring window to front via NativeBridge
                    return;
                }
                runningApps.remove(app.name);
            }

            // Detect binary format for logging
            Path binaryPath = Path.of(app.binaryPath);
            if (Files.exists(binaryPath)) {
                BinaryFormat fmt = NativeAppLauncher.detectFormat(binaryPath);
                System.out.printf("[JDesk] Launching %s (%s)%n", app.name, fmt.getDescription());
            }

            // Launch under Memory Proxy governance
            Process proc = NativeAppLauncher.launch(app);
            runningApps.put(app.name, proc);

            // Monitor process in background thread
            Thread monitor = new Thread(() -> {
                try {
                    int exitCode = proc.waitFor();
                    runningApps.remove(app.name);
                    System.out.printf("[JDesk] %s exited (code %d)%n", app.name, exitCode);
                } catch (InterruptedException ignored) {}
            }, "jdesk-monitor-" + app.name);
            monitor.setDaemon(true);
            monitor.start();

        } catch (IOException e) {
            System.err.printf("[JDesk] Failed to launch %s: %s%n", app.name, e.getMessage());
            showErrorDialog(app.name, e.getMessage());
        }
    }

    /**
     * Load an SVG icon at the specified size.
     */
    private ImageView loadIcon(String iconPath, int size) {
        ImageView iv = new ImageView();
        iv.setFitWidth(size);
        iv.setFitHeight(size);
        iv.setSmooth(true);

        if (iconPath != null && Files.exists(Path.of(iconPath))) {
            try {
                Image img = new Image(new FileInputStream(iconPath), size, size, true, true);
                iv.setImage(img);
            } catch (FileNotFoundException e) {
                setPlaceholderIcon(iv, size);
            }
        } else {
            setPlaceholderIcon(iv, size);
        }

        return iv;
    }

    /**
     * Fallback: generate a colored placeholder icon.
     */
    private void setPlaceholderIcon(ImageView iv, int size) {
        // Simple colored square as placeholder
        javafx.scene.shape.Rectangle rect = new javafx.scene.shape.Rectangle(size, size);
        rect.setFill(javafx.scene.paint.Color.web("#1A73E8"));
        rect.setArcWidth(12);
        rect.setArcHeight(12);
        // Convert to image via snapshot would go here in full implementation
    }

    /**
     * Show error dialog when launch fails.
     */
    private void showErrorDialog(String appName, String errorMessage) {
        // In full JDesk, this would show a themed dialog.
        // For now, stdout logging.
        System.err.printf("""
            ═══════════════════════════════════════════════
              JDesk Launch Error
            ═══════════════════════════════════════════════
              Application: %s
              Error: %s
            
              Check:
                • Binary exists at declared path
                • Binary has +x permission
                • Memory Proxy profile is valid
                • Wine/Darling installed (for PE/Mach-O)
            ═══════════════════════════════════════════════
            %n""", appName, errorMessage);
    }

    /**
     * Get list of currently running applications (for panel display).
     */
    public List<String> getRunningApps() {
        List<String> running = new ArrayList<>();
        for (Map.Entry<String, Process> entry : runningApps.entrySet()) {
            if (entry.getValue().isAlive()) {
                running.add(entry.getKey());
            }
        }
        return running;
    }

    /**
     * Kill a running application by name.
     */
    public boolean killApp(String appName) {
        Process proc = runningApps.get(appName);
        if (proc != null && proc.isAlive()) {
            proc.destroyForcibly();
            runningApps.remove(appName);
            return true;
        }
        return false;
    }

    /**
     * Shutdown all running applications (called on JDesk exit).
     */
    public void shutdownAll() {
        for (Map.Entry<String, Process> entry : runningApps.entrySet()) {
            if (entry.getValue().isAlive()) {
                System.out.printf("[JDesk] Shutting down: %s%n", entry.getKey());
                entry.getValue().destroy();
            }
        }
        runningApps.clear();
    }
}
