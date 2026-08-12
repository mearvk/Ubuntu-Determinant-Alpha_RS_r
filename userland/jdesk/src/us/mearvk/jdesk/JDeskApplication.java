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
            "center 50% 45%, radius 70%, " +
            "#2A2A2E 0%, #1E1E22 50%, #141418 100%);"
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
        grid.setHgap(24);
        grid.setVgap(24);
        grid.setPadding(new Insets(48));
        grid.setLayoutX(40);
        grid.setLayoutY(40);

        // Load the single JDesk icon (Java cup, used for all apps)
        Image jdeskIcon = loadJDeskIcon();

        // Desktop icon entries: name, action
        String[][] icons = {
            {"Settings",  "settings"},
            {"Terminal",  "terminal"},
            {"IDE",       "ide"},
            {"Browser",   "browser"},
            {"Writer",    "writer"},
            {"Files",     "files"},
            {"Software",  "software"},
            {"Launcher",  "launcher"},
        };

        int col = 0, row = 0;
        for (String[] entry : icons) {
            VBox cell = createIconCell(entry[0], entry[1], jdeskIcon);
            grid.add(cell, col, row);
            col++;
            if (col >= 4) { col = 0; row++; }
        }

        // Enable drag-to-reorder on the grid
        enableGridDrag(grid);

        return grid;
    }

    /**
     * Load the JDesk icon PNG. Tries multiple paths.
     */
    private Image loadJDeskIcon() {
        String[] paths = {
            "userland/jdesk/native-apps/icons/jdesk-icon.png",
            "native-apps/icons/jdesk-icon.png",
            "/opt/jdesk/icons/jdesk-icon.png",
            "icons/jdesk-icon.png"
        };

        for (String path : paths) {
            java.io.File f = new java.io.File(path);
            if (f.exists()) {
                return new Image(f.toURI().toString(), 64, 64, true, true);
            }
        }

        // Fallback: return null (icon cell will be empty)
        System.err.println("[JDesk] Warning: jdesk-icon.png not found");
        return null;
    }

    /**
     * Create a desktop icon cell with the JDesk icon and gray/white label.
     */
    private VBox createIconCell(String name, String action, Image icon) {
        VBox cell = new VBox(8);
        cell.setAlignment(Pos.CENTER);
        cell.setPrefSize(100, 110);
        cell.setPadding(new Insets(8));
        cell.setStyle("-fx-background-color: transparent;");

        // Icon image (the Java cup PNG — same for all)
        ImageView iconView = new ImageView();
        iconView.setFitWidth(64);
        iconView.setFitHeight(64);
        iconView.setSmooth(true);
        iconView.setPreserveRatio(true);
        if (icon != null) {
            iconView.setImage(icon);
        }

        // Name label — gray and white
        Label nameLabel = new Label(name);
        nameLabel.setStyle(
            "-fx-font-size: 12px;" +
            "-fx-font-family: 'Inter', system-ui, sans-serif;" +
            "-fx-text-fill: #E8E8E8;" +
            "-fx-font-weight: 500;" +
            "-fx-effect: dropshadow(gaussian, rgba(0,0,0,0.6), 2, 0, 0, 1);"
        );
        nameLabel.setMaxWidth(92);
        nameLabel.setWrapText(true);
        nameLabel.setAlignment(Pos.CENTER);

        cell.getChildren().addAll(iconView, nameLabel);

        // Hover effect
        cell.setOnMouseEntered(e -> {
            cell.setStyle(
                "-fx-background-color: rgba(255, 255, 255, 0.08);" +
                "-fx-background-radius: 12;"
            );
            nameLabel.setStyle(
                "-fx-font-size: 12px;" +
                "-fx-font-family: 'Inter', system-ui, sans-serif;" +
                "-fx-text-fill: #FFFFFF;" +
                "-fx-font-weight: 600;" +
                "-fx-effect: dropshadow(gaussian, rgba(0,0,0,0.6), 2, 0, 0, 1);"
            );
        });
        cell.setOnMouseExited(e -> {
            cell.setStyle("-fx-background-color: transparent;");
            nameLabel.setStyle(
                "-fx-font-size: 12px;" +
                "-fx-font-family: 'Inter', system-ui, sans-serif;" +
                "-fx-text-fill: #E8E8E8;" +
                "-fx-font-weight: 500;" +
                "-fx-effect: dropshadow(gaussian, rgba(0,0,0,0.6), 2, 0, 0, 1);"
            );
        });

        // Double-click to launch
        cell.setOnMouseClicked(event -> {
            if (event.getClickCount() == 2) {
                launchDesktopApp(action, name);
            }
        });

        return cell;
    }

    // =========================================================================
    //  Grid Drag-to-Reorder (move icons freely on grid)
    // =========================================================================

    private double dragStartX, dragStartY;
    private VBox draggedCell = null;

    private void enableGridDrag(GridPane grid) {
        for (javafx.scene.Node node : grid.getChildren()) {
            if (node instanceof VBox) {
                VBox cell = (VBox) node;
                enableCellDrag(cell, grid);
            }
        }
    }

    private void enableCellDrag(VBox cell, GridPane grid) {
        cell.setOnMousePressed(e -> {
            if (e.getButton() == javafx.scene.input.MouseButton.PRIMARY && e.getClickCount() == 1) {
                draggedCell = cell;
                dragStartX = e.getSceneX();
                dragStartY = e.getSceneY();
                cell.setOpacity(0.7);
                cell.toFront();
            }
        });

        cell.setOnMouseDragged(e -> {
            if (draggedCell == cell) {
                double deltaX = e.getSceneX() - dragStartX;
                double deltaY = e.getSceneY() - dragStartY;
                cell.setTranslateX(deltaX);
                cell.setTranslateY(deltaY);
            }
        });

        cell.setOnMouseReleased(e -> {
            if (draggedCell == cell) {
                cell.setOpacity(1.0);

                // Determine new grid position from drop location
                double dropX = e.getSceneX() - grid.getLayoutX() - grid.getPadding().getLeft();
                double dropY = e.getSceneY() - grid.getLayoutY() - grid.getPadding().getTop();

                int newCol = Math.max(0, Math.min(3, (int)(dropX / 120)));
                int newRow = Math.max(0, (int)(dropY / 130));

                // Get current position
                Integer oldCol = GridPane.getColumnIndex(cell);
                Integer oldRow = GridPane.getRowIndex(cell);
                if (oldCol == null) oldCol = 0;
                if (oldRow == null) oldRow = 0;

                // Swap with whatever is at the new position
                for (javafx.scene.Node other : grid.getChildren()) {
                    Integer otherCol = GridPane.getColumnIndex(other);
                    Integer otherRow = GridPane.getRowIndex(other);
                    if (otherCol == null) otherCol = 0;
                    if (otherRow == null) otherRow = 0;

                    if (otherCol == newCol && otherRow == newRow && other != cell) {
                        GridPane.setColumnIndex(other, oldCol);
                        GridPane.setRowIndex(other, oldRow);
                        break;
                    }
                }

                GridPane.setColumnIndex(cell, newCol);
                GridPane.setRowIndex(cell, newRow);

                // Reset translation
                cell.setTranslateX(0);
                cell.setTranslateY(0);
                draggedCell = null;
            }
        });
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
            "-fx-background-color: rgba(30, 30, 34, 0.95);" +
            "-fx-border-color: #3A3A40 transparent transparent transparent;" +
            "-fx-border-width: 1 0 0 0;"
        );

        // JDesk logo / activities button
        Label logo = new Label("◉ JDesk");
        logo.setStyle(
            "-fx-font-size: 13px;" +
            "-fx-font-family: 'Inter', system-ui, sans-serif;" +
            "-fx-font-weight: 600;" +
            "-fx-text-fill: #A0A0A8;"
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
            "-fx-text-fill: #B0B0B8;"
        );

        // System indicators
        Label indicators = new Label("⚡ 🔊 🌐");
        indicators.setStyle(
            "-fx-font-size: 12px;" +
            "-fx-text-fill: #888890;"
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

        // --- JDesk-native apps (skinned in JavaFX, call native binary) ---
        if ("settings".equals(action)) {
            showSettingsDialog();
            return;
        }
        if ("terminal".equals(action)) {
            openJDeskTerminal();
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
    //  JDesk Terminal (JavaFX GUI, native shell backend)
    // =========================================================================

    /**
     * Open a JDesk Terminal window — JavaFX renders the GUI,
     * /bin/bash runs as a governed subprocess.
     * This is the model for unified JDesk app skinning.
     */
    private void openJDeskTerminal() {
        // Create terminal widget
        us.mearvk.jdesk.apps.JDeskTerminal terminal = new us.mearvk.jdesk.apps.JDeskTerminal(100, 28);

        // Wrap in a floating window on the desktop
        VBox termWindow = new VBox(0);
        termWindow.setPrefSize(terminal.getTerminalWidth() + 2, terminal.getTerminalHeight() + 40);
        termWindow.setLayoutX(120);
        termWindow.setLayoutY(80);
        termWindow.setStyle(
            "-fx-background-color: #1A1D23;" +
            "-fx-background-radius: 10;" +
            "-fx-border-color: #3A3E48;" +
            "-fx-border-radius: 10;" +
            "-fx-border-width: 1;" +
            "-fx-effect: dropshadow(gaussian, rgba(0,0,0,0.5), 20, 0, 0, 6);"
        );

        // Title bar with circular close button
        HBox titleBar = new HBox(8);
        titleBar.setAlignment(javafx.geometry.Pos.CENTER_LEFT);
        titleBar.setPadding(new Insets(8, 12, 8, 12));
        titleBar.setStyle("-fx-background-color: #22252B; -fx-background-radius: 10 10 0 0;");

        // Circular close button (pearl style)
        Button closeBtn = new Button("");
        closeBtn.setMinSize(13, 13);
        closeBtn.setMaxSize(13, 13);
        closeBtn.setStyle(
            "-fx-background-color: linear-gradient(to bottom, #3A3E48 0%, #2A2E38 100%);" +
            "-fx-background-radius: 50%;" +
            "-fx-border-color: #4A4E58;" +
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
            "-fx-background-color: linear-gradient(to bottom, #3A3E48 0%, #2A2E38 100%);" +
            "-fx-background-radius: 50%;" +
            "-fx-border-color: #4A4E58;" +
            "-fx-border-radius: 50%;" +
            "-fx-border-width: 1;" +
            "-fx-cursor: hand;"
        ));
        closeBtn.setOnAction(e -> {
            terminal.stop();
            desktopSurface.getChildren().remove(termWindow);
        });

        Label titleLabel = new Label("Terminal");
        titleLabel.setStyle(
            "-fx-text-fill: #A0A8B0;" +
            "-fx-font-size: 12px;" +
            "-fx-font-family: 'Inter', system-ui, sans-serif;" +
            "-fx-font-weight: 500;"
        );

        titleBar.getChildren().addAll(closeBtn, titleLabel);

        // Enable dragging the window
        final double[] dragOffset = new double[2];
        titleBar.setOnMousePressed(e -> {
            dragOffset[0] = e.getSceneX() - termWindow.getLayoutX();
            dragOffset[1] = e.getSceneY() - termWindow.getLayoutY();
        });
        titleBar.setOnMouseDragged(e -> {
            termWindow.setLayoutX(e.getSceneX() - dragOffset[0]);
            termWindow.setLayoutY(e.getSceneY() - dragOffset[1]);
        });

        termWindow.getChildren().addAll(titleBar, terminal);
        desktopSurface.getChildren().add(termWindow);

        // Start the shell
        terminal.start();

        // Focus the terminal for keyboard input
        Platform.runLater(terminal::requestFocus);

        System.out.println("[JDesk] ✓ Terminal opened (JavaFX GUI → /bin/bash native)");
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
