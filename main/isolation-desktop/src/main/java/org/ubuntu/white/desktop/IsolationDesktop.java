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

/** Developer-only visual preview of the Ubuntu White desktop idiom. */
public final class IsolationDesktop extends Application {
    private static final String BACKGROUND = "/images/mediate-ubuntu-white-edition-001.jpeg";

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

    private void showDesktop(StackPane root) {
        Image image = null;
        var resource = getClass().getResource(BACKGROUND);
        if (resource != null) {
            image = new Image(resource.toExternalForm());
        }

        Label title = new Label("Ubuntu White Desktop Preview");
        title.setStyle("-fx-font-size: 24px; -fx-font-weight: bold; -fx-text-fill: white;");
        Label subtitle = new Label("Developer isolation environment");
        subtitle.setStyle("-fx-text-fill: white;");
        VBox content = new VBox(10, title, subtitle);
        content.setAlignment(Pos.CENTER);

        BorderPane desktop = new BorderPane(content);
        desktop.setTop(new Label("  Applications     Files     Settings"));
        desktop.setBottom(new Label("  Ubuntu White • Desktop Preview"));
        desktop.setStyle("-fx-background-color: rgba(247,247,247,0.18); -fx-padding: 24px;");

        if (image != null) {
            ImageView background = new ImageView(image);
            background.setPreserveRatio(false);
            background.fitWidthProperty().bind(root.widthProperty());
            background.fitHeightProperty().bind(root.heightProperty());
            StackPane composed = new StackPane(background, desktop);
            root.getChildren().setAll(composed);
        } else {
            root.getChildren().setAll(desktop);
        }
        installExitKeys(root);
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
