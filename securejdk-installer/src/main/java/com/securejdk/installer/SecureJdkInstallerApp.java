package com.securejdk.installer;

import javafx.application.Application;
import javafx.concurrent.Task;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.stage.DirectoryChooser;
import javafx.stage.Stage;

import java.nio.file.Path;

public final class SecureJdkInstallerApp extends Application {
    private static final String BRAND_LEGAL = "MEARVK LLC 2028 ©";
    private static final String GRAAL_NOTICE = "Graal software — All applicable Graal trademarks and notices included © 2026";

    private final InstallerConfig config = new InstallerConfig();
    private final InstallerEngine engine = new InstallerEngine();
    private final StackPane content = new StackPane();
    private final Label section = new Label("Welcome");
    private final ProgressBar progress = new ProgressBar(0);
    private final Label status = new Label("Ready");

    @Override
    public void start(Stage stage) {
        BorderPane shell = new BorderPane();
        shell.getStyleClass().add("shell");

        Label product = new Label("SECURE JDK 28");
        Label descriptor = new Label("American-grade Java configuration");
        Label legal = new Label(BRAND_LEGAL);
        legal.getStyleClass().add("brand-legal");
        Label graal = new Label(GRAAL_NOTICE);
        graal.getStyleClass().add("brand-graal");

        VBox brand = new VBox(3, product, descriptor, legal, graal);
        brand.getStyleClass().add("brand");
        shell.setTop(brand);

        section.getStyleClass().add("section-title");
        BorderPane.setMargin(section, new Insets(20, 28, 0, 28));
        shell.setLeft(section);

        content.setPadding(new Insets(22, 28, 22, 28));
        shell.setCenter(content);

        progress.setMaxWidth(Double.MAX_VALUE);
        status.getStyleClass().add("status");
        VBox footer = new VBox(8, progress, status);
        footer.setPadding(new Insets(10, 28, 18, 28));
        shell.setBottom(footer);

        showWelcome();

        Scene scene = new Scene(shell, 920, 620);
        scene.getStylesheets().add(getClass().getResource("/securejdk.css").toExternalForm());
        stage.setTitle("Secure JDK 28 Installer — MEARVK LLC");
        stage.setScene(scene);
        stage.setMinWidth(760);
        stage.setMinHeight(520);
        stage.show();
    }

    private void showWelcome() {
        section.setText("Welcome");
        VBox box = page("Secure JDK 28", "A configurable Java runtime and development environment with a clear security posture.");
        Label price = new Label("Target edition price: $25 USD per copy");
        price.getStyleClass().add("price");
        Label legal = new Label(BRAND_LEGAL);
        legal.getStyleClass().add("status");
        Label graal = new Label(GRAAL_NOTICE);
        graal.getStyleClass().add("status");
        box.getChildren().addAll(price, legal, graal, spacer(), buttonBar("Begin", e -> showInstallation()));
        content.getChildren().setAll(box);
    }

    private void showInstallation() {
        section.setText("Installation Target");
        TextField location = new TextField(config.getInstallDirectory().toString());
        Button browse = new Button("Browse…");
        browse.setOnAction(e -> {
            DirectoryChooser chooser = new DirectoryChooser();
            chooser.setTitle("Choose Secure JDK 28 destination");
            var selected = chooser.showDialog(content.getScene().getWindow());
            if (selected != null) {
                location.setText(selected.toPath().toString());
                config.setInstallDirectory(selected.toPath());
            }
        });
        location.textProperty().addListener((obs, old, value) -> config.setInstallDirectory(Path.of(value)));

        CheckBox path = check("Add Secure JDK to PATH", config.isConfigurePath(), config::setConfigurePath);
        CheckBox home = check("Set JAVA_HOME", config.isConfigureJavaHome(), config::setConfigureJavaHome);
        CheckBox fx = check("Install JavaFX integration", config.isInstallJavaFx(), config::setInstallJavaFx);

        HBox target = new HBox(10, location, browse);
        HBox.setHgrow(location, Priority.ALWAYS);
        VBox box = page("Where should Secure JDK 28 live?", "The recommended location keeps the Secure JDK installation self-contained.");
        box.getChildren().addAll(target, path, home, fx, spacer(), buttonBar("Continue", e -> showSecurity()));
        content.getChildren().setAll(box);
    }

    private void showSecurity() {
        section.setText("Security");
        ToggleGroup group = new ToggleGroup();
        RadioButton standard = radio("Standard — recommended", "Standard", group);
        RadioButton developer = radio("Developer — wider development aperture", "Developer", group);
        RadioButton enterprise = radio("Enterprise — hardened defaults", "Enterprise", group);
        standard.setSelected(true);
        group.selectedToggleProperty().addListener((obs, old, selected) -> {
            if (selected != null) config.setProfile((String) selected.getUserData());
        });
        CheckBox hardened = check("Enable hardened security defaults", true, config::setHardenedSecurity);
        VBox box = page("Choose the security posture", "Security settings remain explicit: configuration does not silently imply authorization.");
        box.getChildren().addAll(standard, developer, enterprise, hardened, spacer(), buttonBar("Continue", e -> showMemory()));
        content.getChildren().setAll(box);
    }

    private void showMemory() {
        section.setText("Memory Management");
        ComboBox<String> memory = new ComboBox<>();
        memory.getItems().addAll("Automatic", "Developer Workstation", "Server", "High-Memory Workstation", "Custom");
        memory.setValue(config.getMemoryProfile());
        memory.valueProperty().addListener((obs, old, value) -> config.setMemoryProfile(value));
        VBox box = page("Memory Management", "Select a policy profile; the installed JDK remains responsible for actual runtime enforcement.");
        box.getChildren().addAll(new Label("Memory profile"), memory, spacer(), buttonBar("Continue", e -> showAperture()));
        content.getChildren().setAll(box);
    }

    private void showAperture() {
        section.setText("Aperture");
        CheckBox advanced = check("Open advanced configuration controls", false, config::setAdvancedAperture);
        CheckBox desktop = check("Create desktop/start-menu integration", true, config::setDesktopIntegration);
        VBox box = page("Configuration Aperture", "Start simple. Open the aperture when you want direct control over the Secure JDK profile.");
        box.getChildren().addAll(advanced, desktop, spacer(), buttonBar("Review Total", e -> showTotal()));
        content.getChildren().setAll(box);
    }

    private void showTotal() {
        section.setText("Total");
        VBox box = page("Installation Total", "Everything selected for this Secure JDK 28 installation.");
        box.getChildren().addAll(
                summary("Destination", config.getInstallDirectory().toString()),
                summary("Profile", config.getProfile()),
                summary("Memory", config.getMemoryProfile()),
                summary("Security", config.isHardenedSecurity() ? "Hardened defaults" : "Standard"),
                summary("JavaFX", config.isInstallJavaFx() ? "Included" : "Not selected"),
                summary("Brand", BRAND_LEGAL),
                summary("Graal", GRAAL_NOTICE),
                spacer(),
                buttonBar("Install Secure JDK 28", e -> install()));
        content.getChildren().setAll(box);
    }

    private void install() {
        section.setText("Install");
        progress.setProgress(0);
        Task<Void> task = new Task<>() {
            @Override protected Void call() throws Exception {
                engine.stage(config, (value, message) -> updateMessage(message));
                return null;
            }
        };
        task.messageProperty().addListener((obs, old, value) -> status.setText(value));
        task.setOnSucceeded(e -> showComplete());
        task.setOnFailed(e -> status.setText("Installation failed: " + task.getException().getMessage()));
        new Thread(task, "securejdk-installer").start();
    }

    private void showComplete() {
        progress.setProgress(1);
        section.setText("Complete");
        VBox box = page("Secure JDK 28 is staged", "The installer has prepared the selected installation structure and configuration manifest.");
        box.getChildren().addAll(summary("JAVA_HOME", config.getInstallDirectory().toString()), summary("Profile", config.getProfile()), summary("Brand", BRAND_LEGAL), spacer(), buttonBar("Finish", e -> content.getScene().getWindow().hide()));
        content.getChildren().setAll(box);
    }

    private VBox page(String title, String subtitle) {
        Label h = new Label(title);
        h.getStyleClass().add("hero-title");
        Label s = new Label(subtitle);
        s.getStyleClass().add("subtitle");
        VBox box = new VBox(16, h, s);
        box.setFillWidth(true);
        return box;
    }

    private Label summary(String name, String value) {
        Label label = new Label(name + "  •  " + value);
        label.getStyleClass().add("summary");
        return label;
    }

    private CheckBox check(String text, boolean selected, java.util.function.Consumer<Boolean> setter) {
        CheckBox box = new CheckBox(text);
        box.setSelected(selected);
        box.selectedProperty().addListener((obs, old, value) -> setter.accept(value));
        return box;
    }

    private RadioButton radio(String text, String value, ToggleGroup group) {
        RadioButton button = new RadioButton(text);
        button.setToggleGroup(group);
        button.setUserData(value);
        return button;
    }

    private Region spacer() {
        Region region = new Region();
        VBox.setVgrow(region, Priority.ALWAYS);
        return region;
    }

    private HBox buttonBar(String text, javafx.event.EventHandler<javafx.event.ActionEvent> action) {
        Button button = new Button(text);
        button.getStyleClass().add("primary-button");
        button.setOnAction(action);
        HBox row = new HBox(button);
        row.setAlignment(Pos.CENTER_RIGHT);
        return row;
    }

    public static void main(String[] args) {
        launch(args);
    }
}
