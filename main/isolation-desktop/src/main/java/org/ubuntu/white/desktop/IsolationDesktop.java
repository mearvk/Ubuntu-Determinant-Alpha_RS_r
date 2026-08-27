package org.ubuntu.white.desktop;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.control.ProgressBar;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.animation.PauseTransition;
import javafx.util.Duration;

import java.nio.file.Files;
import java.nio.file.Path;

/** Developer-only visual preview of the Ubuntu White desktop idiom. */
public final class IsolationDesktop extends Application {
    private static final String BACKGROUND_NAME = "mediate-ubuntu-white-edition-001.jpeg";
    private static final String[] DESKTOP_ITEMS = {
        "Desktop", "Documents", "Downloads", "Music", "Pictures",
        "Public", "Templates", "Videos", "Trash"
    };

    @Override
    public void start(Stage stage) {
        stage.setTitle("Ubuntu White — Desktop Preview");
        stage.setScene(new Scene(loader(), 1280, 800));
        stage.setFullScreen(true);
        stage.setFullScreenExitHint("");
        stage.show();
    }

    private StackPane loader() {
        ProgressBar progress = new ProgressBar(0);
        progress.setPrefWidth(520);
        Label percent = new Label("0%");
        Label status = new Label("Loading Ubuntu White Desktop…");
        VBox box = new VBox(14, status, progress, percent);
        box.setAlignment(Pos.CENTER);
        StackPane root = new StackPane(box);
        root.setStyle("-fx-background-color: white; -fx-font-family: 'Sans Serif'; -fx-font-size: 16px;");

        final int[] step = {0};
        PauseTransition timer = new PauseTransition(Duration.millis(140));
        timer.setOnFinished(event -> {
            step[0]++;
            double value = Math.min(1.0, step[0] / 20.0);
            progress.setProgress(value);
            percent.setText((int) Math.round(value * 100) + "%");
            status.setText(value < 1 ? assessment(step[0]) : "Desktop ready");
            if (value < 1) timer.playFromStart();
            else showDesktop(root);
        });
        timer.play();
        installExitKeys(root);
        return root;
    }

    private String assessment(int step) {
        return switch (step) {
            case 1, 2, 3 -> "Loading GUI sources…";
            case 4, 5, 6 -> "Assessing desktop assets…";
            case 7, 8, 9 -> "Loading fonts and icons…";
            case 10, 11, 12 -> "Preparing desktop shell…";
            case 13, 14, 15 -> "Assessing panels and controls…";
            default -> "Finalizing Desktop Preview…";
        };
    }

    /** Resolve the canonical repository wallpaper from the source checkout. */
    private Image loadWallpaper() {
        Path[] candidates = {
            Path.of("images", BACKGROUND_NAME),
            Path.of("..", "..", "images", BACKGROUND_NAME),
            Path.of("..", "..", "..", "images", BACKGROUND_NAME)
        };
        for (Path candidate : candidates) {
            if (Files.isRegularFile(candidate)) {
                return new Image(candidate.toAbsolutePath().toUri().toString());
            }
        }
        var resource = getClass().getResource("/images/" + BACKGROUND_NAME);
        return resource == null ? null : new Image(resource.toExternalForm());
    }

    private void showDesktop(StackPane root) {
        Image image = loadWallpaper();
        StackPane desktop = new StackPane();
        desktop.setStyle("-fx-background-color: black;");

        if (image != null) {
            ImageView background = new ImageView(image);
            background.setPreserveRatio(false);
            background.fitWidthProperty().bind(desktop.widthProperty());
            background.fitHeightProperty().bind(desktop.heightProperty());
            desktop.getChildren().add(background);
        }

        VBox icons = new VBox(18);
        icons.setAlignment(Pos.TOP_LEFT);
        icons.setLayoutX(36);
        icons.setLayoutY(36);
        for (String name : DESKTOP_ITEMS) {
            VBox icon = createDesktopIcon(name);
            icons.getChildren().add(icon);
        }
        desktop.getChildren().add(icons);

        Label panel = new Label("  Applications     Files     Settings");
        panel.setStyle("-fx-background-color: rgba(255,255,255,0.88); -fx-text-fill: #333333; -fx-padding: 10px 18px; -fx-font-size: 14px;");
        BorderPane shell = new BorderPane();
        shell.setTop(panel);
        shell.setCenter(desktop);
        shell.setBottom(new Label("  Ubuntu White • Desktop Preview"));
        shell.setStyle("-fx-background-color: transparent;");
        root.getChildren().setAll(shell);
        installExitKeys(root);
    }

    private VBox createDesktopIcon(String name) {
        Label glyph = new Label("▰");
        glyph.setStyle("-fx-text-fill: white; -fx-font-size: 34px; -fx-font-weight: bold;");
        Label label = new Label(name);
        label.setStyle("-fx-text-fill: white; -fx-font-size: 13px; -fx-font-weight: bold;");
        VBox icon = new VBox(2, glyph, label);
        icon.setAlignment(Pos.CENTER);
        icon.setPrefWidth(100);
        return icon;
    }

    private void installExitKeys(javafx.scene.Node node) {
        node.addEventHandler(KeyEvent.KEY_PRESSED, event -> {
            if (event.getCode() == KeyCode.ESCAPE ||
                (event.isControlDown() && event.getCode() == KeyCode.TAB)) {
                Platform.exit();
            }
        });
        node.setFocusTraversable(true);
        node.requestFocus();
    }

    public static void main(String[] args) {
        launch(args);
    }
}
