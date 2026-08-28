package org.ubuntu.white.desktop;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.geometry.Pos;
import javafx.scene.Cursor;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.Dragboard;
import javafx.scene.input.KeyCode;
import javafx.scene.input.TransferMode;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.Pane;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/** Full-window Ubuntu White Linux-style desktop preview. */
public final class DesktopSynthesizer extends Application {
    private static final String WALLPAPER = "mediate-ubuntu-white-edition-001.jpeg";
    private static final int ICON_SIZE = 64;
    private static final double GRID_X = 132;
    private static final double GRID_Y = 112;
    private static final double MARGIN_X = 28;
    private static final double MARGIN_Y = 28;

    // Canonical Ubuntu White icon set. These are the normalized set-002 assets.
    private static final String[] ICONS = {
        "icon-001.png", "icon-002.png", "icon-003.png", "icon-004.png",
        "icon-005.png", "icon-006.png", "icon-007.png", "icon-008.png",
        "icon-009.png", "icon-010.png", "icon-011.png", "icon-012.png"
    };

    // One Smaug image is used everywhere Smaug is represented by this desktop.
    // Do not substitute or rotate among the other Smaug images.
    private static final String SMAUG_ICON = "smaug-icon-001.jpeg";

    private static final String[] LABELS = {
        "Desktop", "Documents", "Downloads", "Music",
        "Pictures", "Public", "Templates", "Videos",
        "Trash", "Applications", "Computer", "Settings"
    };

    @Override
    public void start(Stage stage) {
        stage.setTitle("Ubuntu White — Desktop Synthesizer");
        StackPane desktop = new StackPane();
        desktop.setStyle("-fx-background-color: black;");
        buildDesktop(desktop);

        BorderPane shell = new BorderPane(desktop);
        Label top = new Label("  Applications     Files     Settings");
        top.setStyle("-fx-background-color: rgba(255,255,255,0.90); -fx-text-fill: #333333; -fx-padding: 10px 18px; -fx-font-size: 14px;");
        shell.setTop(top);
        Label bottom = new Label("  Ubuntu White • Desktop Synthesizer    •    Drag icons to move • Grid snap enabled");
        bottom.setStyle("-fx-background-color: rgba(255,255,255,0.88); -fx-text-fill: #333333; -fx-padding: 8px 14px; -fx-font-size: 12px;");
        shell.setBottom(bottom);

        Scene scene = new Scene(shell, 1280, 800);
        scene.setOnKeyPressed(event -> {
            if (event.getCode() == KeyCode.ESCAPE || (event.isControlDown() && event.getCode() == KeyCode.TAB)) {
                Platform.exit();
            }
        });
        stage.setScene(scene);
        stage.setFullScreen(true);
        stage.setFullScreenExitHint("");
        stage.show();
    }

    private void buildDesktop(StackPane desktop) {
        Image wallpaper = loadWallpaper();
        if (wallpaper != null) {
            ImageView background = new ImageView(wallpaper);
            background.setPreserveRatio(true);
            background.setSmooth(true);
            background.setMouseTransparent(true);
            background.setManaged(false);
            desktop.getChildren().add(background);
            desktop.widthProperty().addListener((obs, oldV, newV) -> fitWallpaper(background, desktop));
            desktop.heightProperty().addListener((obs, oldV, newV) -> fitWallpaper(background, desktop));
            Platform.runLater(() -> fitWallpaper(background, desktop));
        }

        Pane iconLayer = new Pane();
        iconLayer.setPickOnBounds(false);
        desktop.getChildren().add(iconLayer);

        for (int i = 0; i < ICONS.length; i++) {
            iconLayer.getChildren().add(createIcon(ICONS[i], LABELS[i], i));
        }

        // Smaug is a single desktop identity and uses one canonical image only.
        iconLayer.getChildren().add(createIcon(SMAUG_ICON, "Smaug", ICONS.length));
        installExternalDrop(iconLayer);
    }

    private Image loadWallpaper() {
        Path[] candidates = {
            Path.of("images", WALLPAPER),
            Path.of("ubuntu-white", "images", WALLPAPER),
            Path.of("..", "..", "images", WALLPAPER),
            Path.of("..", "..", "..", "images", WALLPAPER)
        };
        for (Path path : candidates) {
            if (Files.isRegularFile(path)) return new Image(path.toAbsolutePath().toUri().toString());
        }
        var resource = getClass().getResource("/images/" + WALLPAPER);
        return resource == null ? null : new Image(resource.toExternalForm());
    }

    private Path iconPath(String filename) {
        Path[] candidates = {
            Path.of("ubuntu-white", "icons", "set-002", filename),
            Path.of("images", "desktop-icons", "set-002", filename),
            Path.of("..", "..", "ubuntu-white", "icons", "set-002", filename),
            Path.of("..", "..", "..", "ubuntu-white", "icons", "set-002", filename)
        };
        for (Path path : candidates) {
            if (Files.isRegularFile(path)) return path.toAbsolutePath();
        }
        return null;
    }

    private Path smaugIconPath() {
        Path[] candidates = {
            Path.of("ubuntu-white", "icons", "smaug", SMAUG_ICON),
            Path.of("..", "..", "ubuntu-white", "icons", "smaug", SMAUG_ICON),
            Path.of("..", "..", "..", "ubuntu-white", "icons", "smaug", SMAUG_ICON)
        };
        for (Path path : candidates) {
            if (Files.isRegularFile(path)) return path.toAbsolutePath();
        }
        return null;
    }

    private VBox createIcon(String filename, String labelText, int index) {
        VBox icon = new VBox(5);
        icon.setAlignment(Pos.CENTER);
        icon.setPrefSize(108, 88);
        icon.setCursor(Cursor.OPEN_HAND);

        Path path = "Smaug".equals(labelText) ? smaugIconPath() : iconPath(filename);
        if (path != null) {
            ImageView image = new ImageView(new Image(path.toUri().toString()));
            image.setFitWidth(ICON_SIZE);
            image.setFitHeight(ICON_SIZE);
            image.setPreserveRatio(true);
            image.setSmooth(true);
            image.setMouseTransparent(true);
            icon.getChildren().add(image);
        } else {
            Label missing = new Label("□");
            missing.setStyle("-fx-text-fill: white; -fx-font-size: 40px;");
            icon.getChildren().add(missing);
        }

        Label label = new Label(labelText);
        label.setStyle("-fx-text-fill: white; -fx-font-size: 13px; -fx-font-weight: bold; -fx-effect: dropshadow(gaussian, black, 3, 0.7, 0, 1);");
        icon.getChildren().add(label);
        int columns = 5;
        icon.relocate(MARGIN_X + (index % columns) * GRID_X, MARGIN_Y + (index / columns) * GRID_Y);
        installIconDrag(icon);
        return icon;
    }

    private void fitWallpaper(ImageView background, StackPane desktop) {
        double frameW = desktop.getWidth();
        double frameH = desktop.getHeight();
        double imageW = background.getImage().getWidth();
        double imageH = background.getImage().getHeight();
        if (frameW <= 0 || frameH <= 0 || imageW <= 0 || imageH <= 0) return;

        double scale = Math.max(frameW / imageW, frameH / imageH);
        double renderedW = imageW * scale;
        double renderedH = imageH * scale;
        background.setFitWidth(renderedW);
        background.setFitHeight(renderedH);
        background.setTranslateX((frameW - renderedW) / 2.0);
        background.setTranslateY((frameH - renderedH) / 2.0);
    }

    private void installIconDrag(VBox icon) {
        final double[] press = new double[2];
        final double[] origin = new double[2];

        icon.setOnMousePressed(event -> {
            press[0] = event.getSceneX();
            press[1] = event.getSceneY();
            origin[0] = icon.getLayoutX();
            origin[1] = icon.getLayoutY();
            icon.setCursor(Cursor.CLOSED_HAND);
            icon.toFront();
        });
        icon.setOnMouseDragged(event -> {
            icon.relocate(origin[0] + event.getSceneX() - press[0], origin[1] + event.getSceneY() - press[1]);
        });
        icon.setOnMouseReleased(event -> {
            double x = MARGIN_X + Math.round((icon.getLayoutX() - MARGIN_X) / GRID_X) * GRID_X;
            double y = MARGIN_Y + Math.round((icon.getLayoutY() - MARGIN_Y) / GRID_Y) * GRID_Y;
            icon.relocate(Math.max(MARGIN_X, x), Math.max(MARGIN_Y, y));
            icon.setCursor(Cursor.OPEN_HAND);
        });
    }

    private void installExternalDrop(Pane desktop) {
        desktop.setOnDragOver(event -> {
            Dragboard board = event.getDragboard();
            if (board.hasFiles()) event.acceptTransferModes(TransferMode.COPY);
            event.consume();
        });
        desktop.setOnDragDropped(event -> {
            Dragboard board = event.getDragboard();
            boolean success = false;
            if (board.hasFiles()) {
                List<Path> dropped = new ArrayList<>();
                for (var file : board.getFiles()) dropped.add(file.toPath());
                System.out.println("Ubuntu White Desktop received: " + dropped);
                success = !dropped.isEmpty();
            }
            event.setDropCompleted(success);
            event.consume();
        });
    }

    public static void main(String[] args) {
        launch(args);
    }
}
