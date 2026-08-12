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
    //  Application Launching
    // =========================================================================

    private void launchDesktopApp(String action, String displayName) {
        System.out.printf("[JDesk] Launching: %s%n", displayName);

        try {
            ProcessBuilder pb;
            switch (action) {
                case "terminal":
                    // Try multiple terminals
                    pb = findTerminal();
                    break;
                case "files":
                    pb = new ProcessBuilder("pcmanfm-qt");
                    if (!commandExists("pcmanfm-qt"))
                        pb = new ProcessBuilder("nautilus");
                    break;
                case "browser":
                    pb = new ProcessBuilder("chromium-browser");
                    if (!commandExists("chromium-browser"))
                        pb = new ProcessBuilder("chromium", "--no-sandbox");
                    if (!commandExists("chromium"))
                        pb = new ProcessBuilder("firefox");
                    break;
                case "writer":
                    pb = new ProcessBuilder("libreoffice", "--writer");
                    break;
                case "settings":
                    // JDesk settings would be a built-in JavaFX panel
                    showSettingsDialog();
                    return;
                case "ide":
                    pb = new ProcessBuilder("codium");
                    if (!commandExists("codium"))
                        pb = new ProcessBuilder("code");
                    break;
                default:
                    System.err.printf("[JDesk] Unknown action: %s%n", action);
                    return;
            }

            pb.inheritIO();
            pb.start();
            System.out.printf("[JDesk] ✓ Started: %s%n", displayName);

        } catch (IOException e) {
            System.err.printf("[JDesk] Failed to launch %s: %s%n", displayName, e.getMessage());
        }
    }

    private ProcessBuilder findTerminal() {
        if (commandExists("gnome-terminal")) return new ProcessBuilder("gnome-terminal");
        if (commandExists("xfce4-terminal")) return new ProcessBuilder("xfce4-terminal");
        if (commandExists("konsole")) return new ProcessBuilder("konsole");
        if (commandExists("xterm")) return new ProcessBuilder("xterm");
        return new ProcessBuilder("x-terminal-emulator");
    }

    private boolean commandExists(String cmd) {
        try {
            Process p = new ProcessBuilder("which", cmd).start();
            return p.waitFor() == 0;
        } catch (Exception e) {
            return false;
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
