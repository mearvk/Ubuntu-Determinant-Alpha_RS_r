package org.ubuntu.white.desktop;

import javafx.animation.PauseTransition;
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
import javafx.scene.layout.GridPane;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.util.Duration;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;

/** Developer-only visual preview of the Ubuntu White desktop idiom. */
public final class IsolationDesktop extends Application {
    private static final String BACKGROUND_NAME = "mediate-ubuntu-white-edition-001.jpeg";
    private static final Map<String, String> ICONS = Map.of(
        "Desktop", "folder.svg", "Documents", "folder.svg", "Downloads", "downloads.svg",
        "Music", "folder.svg", "Pictures", "folder.svg", "Public", "folder.svg",
        "Templates", "folder.svg", "Videos", "folder.svg", "Trash", "trash.svg"
    );
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
            if (value < 1) timer.playFromStart(); else showDesktop(root);
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

    private Image loadWallpaper() {
        Path[] candidates = {
            Path.of("images", BACKGROUND_NAME),
            Path.of("..", "..", "images", BACKGROUND_NAME),
            Path.of("..", "..", "..", "images", BACKGROUND_NAME)
        };
        for (Path candidate : candidates) {
            if (Files.isRegularFile(candidate)) return new Image(candidate.toAbsolutePath().toUri().toString(), true);
        }
        var resource = getClass().getResource("/images/" + BACKGROUND_NAME);
        return resource == null ? null : new Image(resource.toExternalForm(), true);
    }

    private Path iconPath(String filename) {
        Path[] candidates = {
            Path.of("ubuntu-white", "icons", filename),
            Path.of("..", "..", "ubuntu-white", "icons", filename),
            Path.of("..", "..", "..", "ubuntu-white", "icons", filename),
            Path.of("..", "icons", "ubuntu-white", filename)
        };
        for (Path candidate : candidates) if (Files.isRegularFile(candidate)) return candidate.toAbsolutePath();
        return null;
    }

    private ImageView loadIcon(String filename) {
        Path path = iconPath(filename);
        if (path == null) return null;
        ImageView view = new ImageView(new Image(path.toUri().toString(), true));
        view.setFitWidth(48);
        view.setFitHeight(48);
        view.setPreserveRatio(true);
        return view;
    }

    private void showDesktop(StackPane root) {
        StackPane desktop = new StackPane();
        desktop.setStyle("-fx-background-color: black;");
        Image image = loadWallpaper();
        if (image != null) {
            ImageView background = new ImageView(image);
            background.setPreserveRatio(true);
            background.setSmooth(true);
            background.setMouseTransparent(true);
            background.setManaged(false);
            // Natural-size wallpaper: never stretch it to the fullscreen frame.
            desktop.widthProperty().addListener((obs, oldV, newV) -> centerWallpaper(background, desktop));
            desktop.heightProperty().addListener((obs, oldV, newV) -> centerWallpaper(background, desktop));
            desktop.getChildren().add(background);
            Platform.runLater(() -> centerWallpaper(background, desktop));
        }

        GridPane icons = new GridPane();
        icons.setHgap(24);
        icons.setVgap(22);
        icons.setAlignment(Pos.TOP_LEFT);
        icons.setTranslateX(38);
        icons.setTranslateY(32);
        for (int i = 0; i < DESKTOP_ITEMS.length; i++) {
            icons.add(createDesktopIcon(DESKTOP_ITEMS[i]), i / 5, i % 5);
        }
        desktop.getChildren().add(icons);

        BorderPane shell = new BorderPane();
        shell.setCenter(desktop);
        Label panel = new Label("  Applications     Files     Settings");
        panel.setStyle("-fx-background-color: rgba(255,255,255,0.88); -fx-text-fill: #333333; -fx-padding: 10px 18px; -fx-font-size: 14px;");
        shell.setTop(panel);
        shell.setBottom(new Label("  Ubuntu White • Desktop Preview"));
        root.getChildren().setAll(shell);
        installExitKeys(root);
    }

    private void centerWallpaper(ImageView background, StackPane desktop) {
        background.setTranslateX((desktop.getWidth() - background.getBoundsInParent().getWidth()) / 2.0);
        background.setTranslateY((desktop.getHeight() - background.getBoundsInParent().getHeight()) / 2.0);
    }

    private VBox createDesktopIcon(String name) {
        ImageView image = loadIcon(ICONS.get(name));
        Label label = new Label(name);
        label.setStyle("-fx-text-fill: white; -fx-font-size: 13px; -fx-font-weight: bold; -fx-effect: dropshadow(gaussian, black, 3, 0.7, 0, 1);");
        VBox icon = new VBox(4);
        if (image != null) icon.getChildren().add(image);
        else {
            Label missing = new Label("□");
            missing.setStyle("-fx-text-fill: white; -fx-font-size: 34px;");
            icon.getChildren().add(missing);
        }
        icon.getChildren().add(label);
        icon.setAlignment(Pos.CENTER);
        icon.setPrefWidth(92);
        return icon;
    }

    private void installExitKeys(javafx.scene.Node node) {
        node.addEventHandler(KeyEvent.KEY_PRESSED, event -> {
            if (event.getCode() == KeyCode.ESCAPE || (event.isControlDown() && event.getCode() == KeyCode.TAB)) Platform.exit();
        });
        node.setFocusTraversable(true);
        node.requestFocus();
    }

    public static void main(String[] args) { launch(args); }
}
