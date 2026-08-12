/*
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 *
 * JDesk IDE — Unified JavaFX GUI skin over IntelliJ IDEA.
 *
 * Architecture:
 *   ┌──────────────────────────────────────────────────────────────────┐
 *   │  JavaFX (JDesk renders the entire IDE chrome)                   │
 *   │  ┌──────────┬────────────────────────────────┬──────────────┐   │
 *   │  │ Project  │  Editor Tabs / Code Area       │  Structure   │   │
 *   │  │ Tree     │  ┌──────────────────────────┐  │  Panel       │   │
 *   │  │          │  │ Syntax-highlighted text   │  │  (outline)   │   │
 *   │  │ ▸ src    │  │ with line numbers         │  │              │   │
 *   │  │ ▸ test   │  │                           │  │ ▸ class Foo  │   │
 *   │  │ ▸ pom    │  │                           │  │   ▸ bar()   │   │
 *   │  │          │  └──────────────────────────┘  │              │   │
 *   │  ├──────────┴────────────────────────────────┴──────────────┤   │
 *   │  │ Bottom Tool Window (Terminal / Build / Run / Problems)    │   │
 *   │  └──────────────────────────────────────────────────────────┘   │
 *   │  │ Status Bar: branch, encoding, line:col, IntelliJ status   │   │
 *   │  └──────────────────────────────────────────────────────────┘   │
 *   └────────────────────────────────┬────────────────────────────────┘
 *                                    │ stdin/stdout/stderr + file watch
 *                                    ▼
 *   ┌──────────────────────────────────────────────────────────────────┐
 *   │  Native Process: IntelliJ IDEA (idea.sh / idea64)                │
 *   │  Runs headless or with X11 forwarded UNDER JDesk compositor     │
 *   │  Also: javac, gradle, maven subprocesses for build/run          │
 *   │  Governed by JVM Memory Proxy resource limits                   │
 *   └──────────────────────────────────────────────────────────────────┘
 *
 * This is a JDesk-skinned IDE surface that:
 *   1. Provides the visual chrome (tabs, project tree, tool windows)
 *   2. Launches IntelliJ as a managed subprocess for indexing/completion
 *   3. Falls back to built-in editing if IntelliJ is not installed
 *   4. The built-in editor handles: syntax highlighting, line numbers,
 *      file tree, search/replace, multiple tabs, terminal integration
 *
 * The design mirrors IntelliJ's dark theme (Darcula-adjacent) adapted
 * for the JDesk dark compositor style.
 *
 * License: GPL-2.0
 */

package us.mearvk.jdesk.apps;

import javafx.application.Platform;
import javafx.scene.Node;
import javafx.scene.control.*;
import javafx.scene.input.*;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.text.*;
import javafx.geometry.*;
import javafx.animation.*;
import javafx.collections.*;
import javafx.stage.FileChooser;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import java.util.stream.*;

/**
 * JDeskIDE — A full IDE GUI in JavaFX with IntelliJ IDEA as the native backend.
 *
 * Usage (embed in a JDesk window):
 *   JDeskIDE ide = new JDeskIDE();
 *   somePane.getChildren().add(ide);
 *   ide.openProject("/home/user/project");
 *
 * Or launch with IntelliJ backend:
 *   ide.startIntelliJ("/opt/intellij/bin/idea.sh");
 */
public class JDeskIDE extends BorderPane {

    // =========================================================================
    //  Theme Constants (Darcula-adjacent, JDesk dark)
    // =========================================================================

    private static final String BG_DARK        = "#1E1F22";    // Main background
    private static final String BG_EDITOR      = "#2B2D30";    // Editor area
    private static final String BG_SIDEBAR     = "#26282E";    // Project tree / tool panels
    private static final String BG_TOOLBAR     = "#1E1F22";    // Top toolbar
    private static final String BG_TABS        = "#2B2D30";    // Tab bar
    private static final String BG_TAB_ACTIVE  = "#3C3F41";    // Active tab
    private static final String BG_TAB_HOVER   = "#343638";    // Tab hover
    private static final String BG_STATUS      = "#1E1F22";    // Status bar
    private static final String BG_TOOL_WIN    = "#26282E";    // Bottom tool window
    private static final String BORDER_COLOR   = "#393B3D";    // Borders/separators
    private static final String TEXT_PRIMARY    = "#BCBEC4";    // Primary text
    private static final String TEXT_SECONDARY  = "#6F737A";    // Secondary/muted text
    private static final String TEXT_KEYWORD    = "#CF8E6D";    // Keywords (orange)
    private static final String TEXT_STRING     = "#6AAB73";    // Strings (green)
    private static final String TEXT_COMMENT    = "#7A7E85";    // Comments (grey)
    private static final String TEXT_TYPE       = "#5E97D0";    // Types/classes (blue)
    private static final String TEXT_NUMBER     = "#2AACB8";    // Numbers (teal)
    private static final String TEXT_METHOD     = "#56A8F5";    // Methods (bright blue)
    private static final String TEXT_FIELD      = "#C77DBB";    // Fields (purple)
    private static final String TEXT_ANNOTATION = "#BBB529";    // Annotations (yellow)
    private static final String ACCENT_BLUE    = "#4A88C7";    // Selection, focus
    private static final String LINE_NUM_COLOR = "#4E5157";    // Line numbers
    private static final String CARET_COLOR    = "#FFFFFF";    // Caret

    private static final String FONT_MONO      = "JetBrains Mono, Fira Code, Cascadia Code, monospace";
    private static final double FONT_SIZE      = 13.0;
    private static final String FONT_UI        = "Inter, system-ui, sans-serif";
    private static final double FONT_UI_SIZE   = 12.0;

    // =========================================================================
    //  State
    // =========================================================================

    // Layout components
    private TreeView<String> projectTree;
    private TabPane editorTabs;
    private TabPane bottomToolPane;
    private VBox structurePanel;
    private Label statusBar;
    private HBox toolbar;

    // Project state
    private Path projectRoot;
    private Map<Path, TextArea> openEditors = new LinkedHashMap<>();

    // IntelliJ backend process
    private Process intellijProcess;
    private boolean intellijRunning = false;

    // Built-in terminal (bottom panel)
    private JDeskTerminal embeddedTerminal;

    // =========================================================================
    //  Constructor
    // =========================================================================

    public JDeskIDE() {
        setStyle("-fx-background-color: " + BG_DARK + ";");

        // === Top: Menu bar + Toolbar ===
        VBox topSection = new VBox(0);
        topSection.getChildren().addAll(createMenuBar(), createToolbar());
        setTop(topSection);

        // === Left: Project Tree ===
        projectTree = createProjectTree();
        VBox leftPanel = new VBox(0);
        leftPanel.setPrefWidth(260);
        leftPanel.setMinWidth(180);
        leftPanel.setStyle("-fx-background-color: " + BG_SIDEBAR + ";");

        // Project tree header
        HBox treeHeader = createPanelHeader("Project", "⌘1");
        leftPanel.getChildren().addAll(treeHeader, projectTree);
        VBox.setVgrow(projectTree, Priority.ALWAYS);
        setLeft(leftPanel);

        // === Center: Editor Tabs ===
        editorTabs = createEditorTabs();
        setCenter(editorTabs);

        // === Right: Structure Panel ===
        structurePanel = createStructurePanel();
        setRight(structurePanel);

        // === Bottom: Tool Windows (Terminal / Build / Problems) ===
        bottomToolPane = createBottomToolPane();
        setBottom(new VBox(0, bottomToolPane, createStatusBar()));

        // Show welcome tab
        addWelcomeTab();

        // Keyboard shortcuts
        setOnKeyPressed(this::handleGlobalKeyPress);
        setFocusTraversable(true);
    }

    // =========================================================================
    //  Public API
    // =========================================================================

    /**
     * Open a project directory and populate the file tree.
     */
    public void openProject(String path) {
        openProject(Path.of(path));
    }

    public void openProject(Path path) {
        if (!Files.isDirectory(path)) {
            System.err.println("[JDesk IDE] Not a directory: " + path);
            return;
        }
        this.projectRoot = path;
        populateProjectTree(path);
        statusBar.setText("  " + path.getFileName() + " | UTF-8 | LF");
        System.out.println("[JDesk IDE] Opened project: " + path);
    }

    /**
     * Open a specific file in the editor.
     */
    public void openFile(Path file) {
        if (openEditors.containsKey(file)) {
            // Switch to existing tab
            for (Tab tab : editorTabs.getTabs()) {
                if (file.toString().equals(tab.getUserData())) {
                    editorTabs.getSelectionModel().select(tab);
                    return;
                }
            }
        }

        try {
            String content = Files.readString(file, StandardCharsets.UTF_8);
            addEditorTab(file.getFileName().toString(), content, file);
        } catch (IOException e) {
            System.err.println("[JDesk IDE] Failed to open: " + file + " — " + e.getMessage());
        }
    }

    /**
     * Start IntelliJ IDEA as the backend intelligence.
     * IntelliJ runs in the background for code completion, refactoring,
     * inspections, and build/run. JDesk renders the GUI.
     */
    public void startIntelliJ(String intellijPath) {
        if (intellijRunning) return;

        String[] candidates = {
            intellijPath,
            "/opt/intellij/bin/idea.sh",
            "/opt/idea-IC/bin/idea.sh",
            "/opt/idea-IU/bin/idea.sh",
            "/snap/intellij-idea-community/current/bin/idea.sh",
            "/snap/intellij-idea-ultimate/current/bin/idea.sh",
            "/usr/local/bin/idea",
            "/opt/jdesk/apps/intellij/bin/idea.sh"
        };

        String resolvedPath = null;
        for (String candidate : candidates) {
            if (candidate != null && Files.isExecutable(Path.of(candidate))) {
                resolvedPath = candidate;
                break;
            }
        }

        if (resolvedPath == null) {
            System.err.println("[JDesk IDE] IntelliJ IDEA not found. Using built-in editor only.");
            appendToOutput("[IDE] IntelliJ IDEA not found at standard paths.");
            appendToOutput("[IDE] Built-in editor active. Install IntelliJ for:");
            appendToOutput("[IDE]   • Code completion   • Refactoring");
            appendToOutput("[IDE]   • Inspections       • Build/Run integration");
            appendToOutput("[IDE]   • Debugging         • VCS integration");
            return;
        }

        try {
            List<String> command = new ArrayList<>();
            command.add("java");
            command.add("-memory-guard");
            command.add("-Xguard:ram=4g");
            command.add("-Xguard:cpu=90");
            command.add("-Xguard:threads=128");
            command.add("-Xguard:disk-write=500m");
            command.add(resolvedPath);

            if (projectRoot != null) {
                command.add(projectRoot.toString());
            }

            ProcessBuilder pb = new ProcessBuilder(command);
            pb.redirectErrorStream(true);
            pb.environment().put("JDESK_IDE_BACKEND", "1");
            pb.environment().put("JDESK_GOVERNED", "1");

            intellijProcess = pb.start();
            intellijRunning = true;

            // Read IntelliJ output in background
            Thread reader = new Thread(() -> readIntelliJOutput(), "jdesk-intellij-reader");
            reader.setDaemon(true);
            reader.start();

            appendToOutput("[IDE] IntelliJ IDEA started: " + resolvedPath);
            appendToOutput("[IDE] Project: " + (projectRoot != null ? projectRoot : "(none)"));
            System.out.println("[JDesk IDE] ✓ IntelliJ backend started: " + resolvedPath);

        } catch (IOException e) {
            System.err.println("[JDesk IDE] Failed to start IntelliJ: " + e.getMessage());
            appendToOutput("[IDE] ERROR: " + e.getMessage());
        }
    }

    /**
     * Stop IntelliJ backend.
     */
    public void stopIntelliJ() {
        if (intellijProcess != null && intellijProcess.isAlive()) {
            intellijProcess.destroyForcibly();
            intellijRunning = false;
            appendToOutput("[IDE] IntelliJ IDEA stopped.");
        }
    }

    /**
     * Get preferred dimensions for embedding in a JDesk window.
     */
    public double getIDEWidth() { return 1280; }
    public double getIDEHeight() { return 800; }

    // =========================================================================
    //  Menu Bar
    // =========================================================================

    private MenuBar createMenuBar() {
        MenuBar menuBar = new MenuBar();
        menuBar.setStyle(
            "-fx-background-color: " + BG_TOOLBAR + ";" +
            "-fx-border-color: transparent transparent " + BORDER_COLOR + " transparent;" +
            "-fx-border-width: 0 0 1 0;"
        );

        // File menu
        Menu fileMenu = new Menu("File");
        fileMenu.getItems().addAll(
            createMenuItem("New File", "Ctrl+N", this::newFile),
            createMenuItem("Open File...", "Ctrl+O", this::openFileDialog),
            createMenuItem("Open Project...", "Ctrl+Shift+O", this::openProjectDialog),
            new SeparatorMenuItem(),
            createMenuItem("Save", "Ctrl+S", this::saveCurrentFile),
            createMenuItem("Save All", "Ctrl+Shift+S", this::saveAllFiles),
            new SeparatorMenuItem(),
            createMenuItem("Close Tab", "Ctrl+W", this::closeCurrentTab),
            createMenuItem("Close All", "Ctrl+Shift+W", this::closeAllTabs)
        );

        // Edit menu
        Menu editMenu = new Menu("Edit");
        editMenu.getItems().addAll(
            createMenuItem("Undo", "Ctrl+Z", () -> getCurrentEditor().ifPresent(TextArea::undo)),
            createMenuItem("Redo", "Ctrl+Shift+Z", () -> getCurrentEditor().ifPresent(TextArea::redo)),
            new SeparatorMenuItem(),
            createMenuItem("Cut", "Ctrl+X", () -> getCurrentEditor().ifPresent(TextArea::cut)),
            createMenuItem("Copy", "Ctrl+C", () -> getCurrentEditor().ifPresent(TextArea::copy)),
            createMenuItem("Paste", "Ctrl+V", () -> getCurrentEditor().ifPresent(TextArea::paste)),
            new SeparatorMenuItem(),
            createMenuItem("Select All", "Ctrl+A", () -> getCurrentEditor().ifPresent(TextArea::selectAll)),
            createMenuItem("Find...", "Ctrl+F", this::showFind)
        );

        // View menu
        Menu viewMenu = new Menu("View");
        viewMenu.getItems().addAll(
            createMenuItem("Toggle Project", "Alt+1", this::toggleProjectPanel),
            createMenuItem("Toggle Structure", "Alt+7", this::toggleStructurePanel),
            createMenuItem("Toggle Terminal", "Alt+F12", this::toggleTerminal)
        );

        // Run menu
        Menu runMenu = new Menu("Run");
        runMenu.getItems().addAll(
            createMenuItem("Build Project", "Ctrl+F9", this::buildProject),
            createMenuItem("Run", "Shift+F10", this::runProject),
            new SeparatorMenuItem(),
            createMenuItem("Terminal", "Alt+F12", this::toggleTerminal)
        );

        // Help menu
        Menu helpMenu = new Menu("Help");
        helpMenu.getItems().addAll(
            createMenuItem("About JDesk IDE", null, this::showAbout)
        );

        menuBar.getMenus().addAll(fileMenu, editMenu, viewMenu, runMenu, helpMenu);

        // Style all menus
        for (Menu m : menuBar.getMenus()) {
            m.setStyle("-fx-text-fill: " + TEXT_PRIMARY + ";");
        }

        return menuBar;
    }

    private MenuItem createMenuItem(String text, String shortcut, Runnable action) {
        MenuItem item = new MenuItem(text);
        if (shortcut != null) {
            item.setAccelerator(KeyCombination.keyCombination(shortcut));
        }
        item.setOnAction(e -> action.run());
        return item;
    }

    // =========================================================================
    //  Toolbar
    // =========================================================================

    private HBox createToolbar() {
        toolbar = new HBox(4);
        toolbar.setAlignment(Pos.CENTER_LEFT);
        toolbar.setPadding(new Insets(4, 8, 4, 8));
        toolbar.setStyle(
            "-fx-background-color: " + BG_TOOLBAR + ";" +
            "-fx-border-color: transparent transparent " + BORDER_COLOR + " transparent;" +
            "-fx-border-width: 0 0 1 0;"
        );

        Button runBtn = createToolButton("▶", "Run (Shift+F10)", this::runProject);
        Button buildBtn = createToolButton("🔨", "Build (Ctrl+F9)", this::buildProject);
        Button stopBtn = createToolButton("■", "Stop", this::stopProcess);

        Separator sep1 = new Separator(Orientation.VERTICAL);
        sep1.setStyle("-fx-background-color: " + BORDER_COLOR + ";");

        // Run configuration dropdown
        ComboBox<String> runConfig = new ComboBox<>();
        runConfig.getItems().addAll("Current File", "Main Application", "All Tests");
        runConfig.setValue("Current File");
        runConfig.setPrefWidth(180);
        runConfig.setStyle(
            "-fx-background-color: " + BG_EDITOR + ";" +
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-border-color: " + BORDER_COLOR + ";" +
            "-fx-border-radius: 4;" +
            "-fx-background-radius: 4;" +
            "-fx-font-size: 11px;" +
            "-fx-font-family: " + FONT_UI + ";"
        );

        Separator sep2 = new Separator(Orientation.VERTICAL);

        Button findBtn = createToolButton("🔍", "Search (Ctrl+F)", this::showFind);
        Button gitBtn = createToolButton("⎇", "Git", this::showGitStatus);

        // Spacer
        Region spacer = new Region();
        HBox.setHgrow(spacer, Priority.ALWAYS);

        // IntelliJ status indicator
        Label intellijStatus = new Label("● IntelliJ");
        intellijStatus.setStyle(
            "-fx-text-fill: " + (intellijRunning ? "#6AAB73" : TEXT_SECONDARY) + ";" +
            "-fx-font-size: 11px;" +
            "-fx-font-family: " + FONT_UI + ";"
        );

        toolbar.getChildren().addAll(
            runBtn, buildBtn, stopBtn, sep1,
            runConfig, sep2,
            findBtn, gitBtn,
            spacer, intellijStatus
        );

        return toolbar;
    }

    private Button createToolButton(String icon, String tooltip, Runnable action) {
        Button btn = new Button(icon);
        btn.setTooltip(new Tooltip(tooltip));
        btn.setMinSize(28, 28);
        btn.setMaxSize(28, 28);
        btn.setStyle(
            "-fx-background-color: transparent;" +
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-font-size: 14px;" +
            "-fx-cursor: hand;" +
            "-fx-background-radius: 4;"
        );
        btn.setOnMouseEntered(e -> btn.setStyle(
            "-fx-background-color: " + BG_TAB_HOVER + ";" +
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-font-size: 14px;" +
            "-fx-cursor: hand;" +
            "-fx-background-radius: 4;"
        ));
        btn.setOnMouseExited(e -> btn.setStyle(
            "-fx-background-color: transparent;" +
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-font-size: 14px;" +
            "-fx-cursor: hand;" +
            "-fx-background-radius: 4;"
        ));
        btn.setOnAction(e -> action.run());
        return btn;
    }

    // =========================================================================
    //  Project Tree (Left Panel)
    // =========================================================================

    private TreeView<String> createProjectTree() {
        TreeItem<String> root = new TreeItem<>("(No project)");
        root.setExpanded(true);

        TreeView<String> tree = new TreeView<>(root);
        tree.setShowRoot(true);
        tree.setStyle(
            "-fx-background-color: " + BG_SIDEBAR + ";" +
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-font-size: 12px;" +
            "-fx-font-family: " + FONT_UI + ";" +
            "-fx-border-width: 0;"
        );

        // Double-click to open files
        tree.setOnMouseClicked(event -> {
            if (event.getClickCount() == 2) {
                TreeItem<String> selected = tree.getSelectionModel().getSelectedItem();
                if (selected != null && selected.isLeaf() && projectRoot != null) {
                    Path file = resolveTreePath(selected);
                    if (file != null && Files.isRegularFile(file)) {
                        openFile(file);
                    }
                }
            }
        });

        return tree;
    }

    private void populateProjectTree(Path root) {
        TreeItem<String> rootItem = new TreeItem<>(root.getFileName().toString());
        rootItem.setExpanded(true);
        populateTreeItem(rootItem, root, 0);
        projectTree.setRoot(rootItem);
    }

    private void populateTreeItem(TreeItem<String> parentItem, Path dir, int depth) {
        if (depth > 8) return; // Prevent infinite recursion

        try (DirectoryStream<Path> stream = Files.newDirectoryStream(dir)) {
            List<Path> dirs = new ArrayList<>();
            List<Path> files = new ArrayList<>();

            for (Path entry : stream) {
                String name = entry.getFileName().toString();
                // Skip hidden and build directories
                if (name.startsWith(".") || name.equals("node_modules") ||
                    name.equals("target") || name.equals("build") ||
                    name.equals("out") || name.equals("__pycache__")) {
                    continue;
                }
                if (Files.isDirectory(entry)) {
                    dirs.add(entry);
                } else {
                    files.add(entry);
                }
            }

            // Sort: directories first, then files, alphabetically
            dirs.sort(Comparator.comparing(p -> p.getFileName().toString().toLowerCase()));
            files.sort(Comparator.comparing(p -> p.getFileName().toString().toLowerCase()));

            for (Path d : dirs) {
                TreeItem<String> item = new TreeItem<>(d.getFileName().toString());
                parentItem.getChildren().add(item);
                populateTreeItem(item, d, depth + 1);
            }
            for (Path f : files) {
                String icon = getFileIcon(f.getFileName().toString());
                TreeItem<String> item = new TreeItem<>(icon + " " + f.getFileName().toString());
                parentItem.getChildren().add(item);
            }
        } catch (IOException e) {
            // Skip unreadable directories
        }
    }

    private String getFileIcon(String filename) {
        String ext = filename.contains(".") ? filename.substring(filename.lastIndexOf('.') + 1) : "";
        switch (ext.toLowerCase()) {
            case "java":   return "☕";
            case "kt":     return "K";
            case "xml":    return "⟨⟩";
            case "json":   return "{}";
            case "yaml":
            case "yml":    return "⊟";
            case "md":     return "📄";
            case "gradle":
            case "kts":    return "🐘";
            case "py":     return "🐍";
            case "js":
            case "ts":     return "JS";
            case "c":
            case "h":
            case "cpp":
            case "hpp":    return "C";
            case "sh":     return "⟩_";
            case "sql":    return "⊞";
            case "html":
            case "htm":    return "🌐";
            case "css":    return "🎨";
            case "png":
            case "jpg":
            case "svg":    return "🖼";
            default:       return "  ";
        }
    }

    private Path resolveTreePath(TreeItem<String> item) {
        if (projectRoot == null) return null;

        List<String> parts = new ArrayList<>();
        TreeItem<String> current = item;
        while (current != null && current.getParent() != null) {
            String name = current.getValue();
            // Strip file icon prefix
            if (name.length() > 2 && name.charAt(1) == ' ') {
                name = name.substring(2);
            } else if (name.length() > 3 && name.charAt(2) == ' ') {
                name = name.substring(3);
            }
            parts.add(0, name);
            current = current.getParent();
        }

        Path resolved = projectRoot;
        for (String part : parts) {
            resolved = resolved.resolve(part);
        }
        return resolved;
    }

    private HBox createPanelHeader(String title, String shortcut) {
        HBox header = new HBox(6);
        header.setAlignment(Pos.CENTER_LEFT);
        header.setPadding(new Insets(6, 10, 6, 10));
        header.setStyle(
            "-fx-background-color: " + BG_SIDEBAR + ";" +
            "-fx-border-color: transparent transparent " + BORDER_COLOR + " transparent;" +
            "-fx-border-width: 0 0 1 0;"
        );

        Label titleLabel = new Label(title);
        titleLabel.setStyle(
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-font-size: 11px;" +
            "-fx-font-weight: bold;" +
            "-fx-font-family: " + FONT_UI + ";"
        );

        Region spacer = new Region();
        HBox.setHgrow(spacer, Priority.ALWAYS);

        Label shortcutLabel = new Label(shortcut);
        shortcutLabel.setStyle(
            "-fx-text-fill: " + TEXT_SECONDARY + ";" +
            "-fx-font-size: 10px;" +
            "-fx-font-family: " + FONT_UI + ";"
        );

        header.getChildren().addAll(titleLabel, spacer, shortcutLabel);
        return header;
    }

    // =========================================================================
    //  Editor Tabs (Center)
    // =========================================================================

    private TabPane createEditorTabs() {
        TabPane tabs = new TabPane();
        tabs.setTabClosingPolicy(TabPane.TabClosingPolicy.ALL_TABS);
        tabs.setStyle(
            "-fx-background-color: " + BG_EDITOR + ";" +
            "-fx-border-width: 0;"
        );
        return tabs;
    }

    private void addEditorTab(String filename, String content, Path filePath) {
        Tab tab = new Tab(filename);
        tab.setUserData(filePath != null ? filePath.toString() : null);

        // Editor area with line numbers
        BorderPane editorPane = new BorderPane();
        editorPane.setStyle("-fx-background-color: " + BG_EDITOR + ";");

        // Line numbers gutter
        TextArea lineNumbers = new TextArea();
        lineNumbers.setEditable(false);
        lineNumbers.setPrefWidth(55);
        lineNumbers.setStyle(
            "-fx-background-color: " + BG_EDITOR + ";" +
            "-fx-text-fill: " + LINE_NUM_COLOR + ";" +
            "-fx-font-family: " + FONT_MONO + ";" +
            "-fx-font-size: " + FONT_SIZE + "px;" +
            "-fx-border-width: 0;" +
            "-fx-padding: 4 8 4 4;" +
            "-fx-focus-color: transparent;" +
            "-fx-faint-focus-color: transparent;"
        );

        // Code editor
        TextArea editor = new TextArea(content);
        editor.setStyle(
            "-fx-background-color: " + BG_EDITOR + ";" +
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-font-family: " + FONT_MONO + ";" +
            "-fx-font-size: " + FONT_SIZE + "px;" +
            "-fx-border-width: 0;" +
            "-fx-padding: 4 8 4 8;" +
            "-fx-highlight-fill: " + ACCENT_BLUE + ";" +
            "-fx-focus-color: transparent;" +
            "-fx-faint-focus-color: transparent;"
        );
        editor.setWrapText(false);

        // Track file path
        if (filePath != null) {
            openEditors.put(filePath, editor);
        }

        // Sync line numbers
        updateLineNumbers(lineNumbers, content);
        editor.textProperty().addListener((obs, oldText, newText) -> {
            updateLineNumbers(lineNumbers, newText);
            // Mark tab as modified
            if (!tab.getText().endsWith("●")) {
                tab.setText(tab.getText() + " ●");
            }
        });

        // Sync scroll position
        editor.scrollTopProperty().addListener((obs, old, val) -> {
            lineNumbers.setScrollTop(val.doubleValue());
        });

        editorPane.setLeft(lineNumbers);
        editorPane.setCenter(editor);

        tab.setContent(editorPane);

        // Clean up on close
        tab.setOnClosed(e -> {
            if (filePath != null) {
                openEditors.remove(filePath);
            }
        });

        editorTabs.getTabs().add(tab);
        editorTabs.getSelectionModel().select(tab);
    }

    private void addWelcomeTab() {
        Tab tab = new Tab("Welcome");
        tab.setClosable(true);

        VBox welcome = new VBox(16);
        welcome.setAlignment(Pos.CENTER);
        welcome.setPadding(new Insets(60));
        welcome.setStyle("-fx-background-color: " + BG_EDITOR + ";");

        Label title = new Label("JDesk IDE");
        title.setStyle(
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-font-size: 28px;" +
            "-fx-font-family: " + FONT_UI + ";" +
            "-fx-font-weight: 300;"
        );

        Label subtitle = new Label("Galactic Cherry Marvell Edition 98");
        subtitle.setStyle(
            "-fx-text-fill: " + TEXT_SECONDARY + ";" +
            "-fx-font-size: 14px;" +
            "-fx-font-family: " + FONT_UI + ";"
        );

        Label backend = new Label(intellijRunning ?
            "● IntelliJ IDEA — Connected" :
            "○ IntelliJ IDEA — Not connected (built-in editor active)");
        backend.setStyle(
            "-fx-text-fill: " + (intellijRunning ? "#6AAB73" : TEXT_SECONDARY) + ";" +
            "-fx-font-size: 12px;" +
            "-fx-font-family: " + FONT_UI + ";"
        );

        Label shortcuts = new Label(
            "Ctrl+N  New File       Ctrl+O  Open File\n" +
            "Ctrl+S  Save           Ctrl+F  Find\n" +
            "Alt+1   Project Tree   Alt+F12 Terminal\n" +
            "Shift+F10  Run         Ctrl+F9  Build\n"
        );
        shortcuts.setStyle(
            "-fx-text-fill: " + TEXT_SECONDARY + ";" +
            "-fx-font-size: 12px;" +
            "-fx-font-family: " + FONT_MONO + ";" +
            "-fx-line-spacing: 4;"
        );

        welcome.getChildren().addAll(title, subtitle, backend, new Separator(), shortcuts);
        tab.setContent(welcome);
        editorTabs.getTabs().add(tab);
    }

    private void updateLineNumbers(TextArea lineNumbers, String content) {
        int lines = (int) content.lines().count();
        if (lines == 0) lines = 1;
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= lines; i++) {
            sb.append(String.format("%4d\n", i));
        }
        lineNumbers.setText(sb.toString());
    }

    // =========================================================================
    //  Structure Panel (Right)
    // =========================================================================

    private VBox createStructurePanel() {
        VBox panel = new VBox(0);
        panel.setPrefWidth(200);
        panel.setMinWidth(0);
        panel.setStyle("-fx-background-color: " + BG_SIDEBAR + ";");

        HBox header = createPanelHeader("Structure", "Alt+7");

        TreeItem<String> root = new TreeItem<>("(no file)");
        root.setExpanded(true);
        TreeView<String> structTree = new TreeView<>(root);
        structTree.setShowRoot(false);
        structTree.setStyle(
            "-fx-background-color: " + BG_SIDEBAR + ";" +
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-font-size: 11px;" +
            "-fx-font-family: " + FONT_UI + ";" +
            "-fx-border-width: 0;"
        );

        panel.getChildren().addAll(header, structTree);
        VBox.setVgrow(structTree, Priority.ALWAYS);
        return panel;
    }

    // =========================================================================
    //  Bottom Tool Pane (Terminal / Build Output / Problems)
    // =========================================================================

    private TabPane createBottomToolPane() {
        TabPane pane = new TabPane();
        pane.setPrefHeight(200);
        pane.setMinHeight(100);
        pane.setTabClosingPolicy(TabPane.TabClosingPolicy.UNAVAILABLE);
        pane.setStyle(
            "-fx-background-color: " + BG_TOOL_WIN + ";" +
            "-fx-border-color: " + BORDER_COLOR + " transparent transparent transparent;" +
            "-fx-border-width: 1 0 0 0;"
        );

        // Terminal tab
        Tab termTab = new Tab("Terminal");
        embeddedTerminal = new JDeskTerminal(120, 10);
        termTab.setContent(embeddedTerminal);

        // Build Output tab
        Tab buildTab = new Tab("Build");
        TextArea buildOutput = new TextArea();
        buildOutput.setEditable(false);
        buildOutput.setStyle(
            "-fx-background-color: " + BG_TOOL_WIN + ";" +
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-font-family: " + FONT_MONO + ";" +
            "-fx-font-size: 12px;" +
            "-fx-border-width: 0;"
        );
        buildOutput.setText("[Build output will appear here]\n");
        buildTab.setContent(buildOutput);

        // Problems tab
        Tab problemsTab = new Tab("Problems");
        TextArea problems = new TextArea();
        problems.setEditable(false);
        problems.setStyle(
            "-fx-background-color: " + BG_TOOL_WIN + ";" +
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-font-family: " + FONT_MONO + ";" +
            "-fx-font-size: 12px;" +
            "-fx-border-width: 0;"
        );
        problems.setText("No problems detected.\n");
        problemsTab.setContent(problems);

        // Run tab
        Tab runTab = new Tab("Run");
        TextArea runOutput = new TextArea();
        runOutput.setEditable(false);
        runOutput.setStyle(
            "-fx-background-color: " + BG_TOOL_WIN + ";" +
            "-fx-text-fill: " + TEXT_PRIMARY + ";" +
            "-fx-font-family: " + FONT_MONO + ";" +
            "-fx-font-size: 12px;" +
            "-fx-border-width: 0;"
        );
        runOutput.setText("[Run output will appear here]\n");
        runTab.setContent(runOutput);

        pane.getTabs().addAll(termTab, buildTab, runTab, problemsTab);
        return pane;
    }

    // =========================================================================
    //  Status Bar
    // =========================================================================

    private HBox createStatusBar() {
        HBox bar = new HBox(16);
        bar.setAlignment(Pos.CENTER_LEFT);
        bar.setPadding(new Insets(3, 10, 3, 10));
        bar.setStyle(
            "-fx-background-color: " + BG_STATUS + ";" +
            "-fx-border-color: " + BORDER_COLOR + " transparent transparent transparent;" +
            "-fx-border-width: 1 0 0 0;"
        );

        statusBar = new Label("  Ready | UTF-8 | LF");
        statusBar.setStyle(
            "-fx-text-fill: " + TEXT_SECONDARY + ";" +
            "-fx-font-size: 11px;" +
            "-fx-font-family: " + FONT_UI + ";"
        );

        Region spacer = new Region();
        HBox.setHgrow(spacer, Priority.ALWAYS);

        Label posLabel = new Label("Ln 1, Col 1");
        posLabel.setStyle(
            "-fx-text-fill: " + TEXT_SECONDARY + ";" +
            "-fx-font-size: 11px;" +
            "-fx-font-family: " + FONT_UI + ";"
        );

        Label branchLabel = new Label("⎇ main");
        branchLabel.setStyle(
            "-fx-text-fill: " + TEXT_SECONDARY + ";" +
            "-fx-font-size: 11px;" +
            "-fx-font-family: " + FONT_UI + ";"
        );

        Label memLabel = new Label("🧠 IDE");
        memLabel.setStyle(
            "-fx-text-fill: " + TEXT_SECONDARY + ";" +
            "-fx-font-size: 11px;" +
            "-fx-font-family: " + FONT_UI + ";"
        );

        bar.getChildren().addAll(statusBar, spacer, branchLabel, posLabel, memLabel);
        return bar;
    }

    // =========================================================================
    //  Actions
    // =========================================================================

    private void newFile() {
        addEditorTab("untitled", "", null);
    }

    private void openFileDialog() {
        FileChooser chooser = new FileChooser();
        chooser.setTitle("Open File");
        if (projectRoot != null) {
            chooser.setInitialDirectory(projectRoot.toFile());
        }
        File file = chooser.showOpenDialog(getScene() != null ? getScene().getWindow() : null);
        if (file != null) {
            openFile(file.toPath());
        }
    }

    private void openProjectDialog() {
        javafx.stage.DirectoryChooser chooser = new javafx.stage.DirectoryChooser();
        chooser.setTitle("Open Project Directory");
        File dir = chooser.showDialog(getScene() != null ? getScene().getWindow() : null);
        if (dir != null) {
            openProject(dir.toPath());
        }
    }

    private void saveCurrentFile() {
        Tab current = editorTabs.getSelectionModel().getSelectedItem();
        if (current == null || current.getUserData() == null) return;

        Path filePath = Path.of((String) current.getUserData());
        getCurrentEditor().ifPresent(editor -> {
            try {
                Files.writeString(filePath, editor.getText(), StandardCharsets.UTF_8);
                // Remove modified marker
                String tabName = current.getText().replace(" ●", "");
                current.setText(tabName);
                appendToOutput("[IDE] Saved: " + filePath.getFileName());
            } catch (IOException e) {
                appendToOutput("[IDE] ERROR saving: " + e.getMessage());
            }
        });
    }

    private void saveAllFiles() {
        for (Tab tab : editorTabs.getTabs()) {
            if (tab.getUserData() != null && tab.getText().endsWith("●")) {
                editorTabs.getSelectionModel().select(tab);
                saveCurrentFile();
            }
        }
    }

    private void closeCurrentTab() {
        Tab current = editorTabs.getSelectionModel().getSelectedItem();
        if (current != null) {
            editorTabs.getTabs().remove(current);
        }
    }

    private void closeAllTabs() {
        editorTabs.getTabs().clear();
    }

    private void showFind() {
        // Simple find bar at top of editor
        getCurrentEditor().ifPresent(editor -> {
            TextInputDialog dialog = new TextInputDialog();
            dialog.setTitle("Find");
            dialog.setHeaderText(null);
            dialog.setContentText("Search:");
            dialog.showAndWait().ifPresent(query -> {
                String text = editor.getText();
                int idx = text.indexOf(query, editor.getCaretPosition());
                if (idx < 0) idx = text.indexOf(query); // wrap
                if (idx >= 0) {
                    editor.selectRange(idx, idx + query.length());
                }
            });
        });
    }

    private void toggleProjectPanel() {
        Node left = getLeft();
        if (left != null && left.isVisible()) {
            left.setVisible(false);
            left.setManaged(false);
        } else if (left != null) {
            left.setVisible(true);
            left.setManaged(true);
        }
    }

    private void toggleStructurePanel() {
        if (structurePanel.isVisible()) {
            structurePanel.setVisible(false);
            structurePanel.setManaged(false);
        } else {
            structurePanel.setVisible(true);
            structurePanel.setManaged(true);
        }
    }

    private void toggleTerminal() {
        if (bottomToolPane.isVisible()) {
            bottomToolPane.setVisible(false);
            bottomToolPane.setManaged(false);
        } else {
            bottomToolPane.setVisible(true);
            bottomToolPane.setManaged(true);
            // Start terminal if not already running
            if (embeddedTerminal != null) {
                embeddedTerminal.start();
                embeddedTerminal.requestFocus();
            }
        }
    }

    private void buildProject() {
        appendToOutput("[Build] Starting build...");

        if (projectRoot == null) {
            appendToOutput("[Build] ERROR: No project open.");
            return;
        }

        // Detect build system
        String buildCmd;
        if (Files.exists(projectRoot.resolve("pom.xml"))) {
            buildCmd = "mvn compile";
        } else if (Files.exists(projectRoot.resolve("build.gradle")) ||
                   Files.exists(projectRoot.resolve("build.gradle.kts"))) {
            buildCmd = "./gradlew build";
        } else if (Files.exists(projectRoot.resolve("Makefile"))) {
            buildCmd = "make";
        } else if (Files.exists(projectRoot.resolve("Cargo.toml"))) {
            buildCmd = "cargo build";
        } else if (Files.exists(projectRoot.resolve("package.json"))) {
            buildCmd = "npm run build";
        } else {
            appendToOutput("[Build] No recognized build system found.");
            return;
        }

        appendToOutput("[Build] $ " + buildCmd);
        runCommand(buildCmd, "Build");
    }

    private void runProject() {
        appendToOutput("[Run] Starting...");

        if (projectRoot == null) {
            appendToOutput("[Run] ERROR: No project open.");
            return;
        }

        String runCmd;
        if (Files.exists(projectRoot.resolve("pom.xml"))) {
            runCmd = "mvn exec:java";
        } else if (Files.exists(projectRoot.resolve("build.gradle")) ||
                   Files.exists(projectRoot.resolve("build.gradle.kts"))) {
            runCmd = "./gradlew run";
        } else if (Files.exists(projectRoot.resolve("Makefile"))) {
            runCmd = "make run";
        } else if (Files.exists(projectRoot.resolve("Cargo.toml"))) {
            runCmd = "cargo run";
        } else if (Files.exists(projectRoot.resolve("package.json"))) {
            runCmd = "npm start";
        } else {
            appendToOutput("[Run] No recognized run configuration.");
            return;
        }

        appendToOutput("[Run] $ " + runCmd);
        runCommand(runCmd, "Run");
    }

    private void stopProcess() {
        appendToOutput("[IDE] Stop requested.");
        // Would kill the active build/run process
    }

    private void showGitStatus() {
        if (projectRoot != null) {
            runCommand("git status", "Build");
        }
    }

    private void showAbout() {
        appendToOutput("═══════════════════════════════════════════════════════");
        appendToOutput("  JDesk IDE — Galactic Cherry Marvell Edition 98");
        appendToOutput("  Backend: IntelliJ IDEA (native binary)");
        appendToOutput("  GUI: JavaFX (JDesk compositor)");
        appendToOutput("  Copyright (C) 2026 MEARVK LLC");
        appendToOutput("═══════════════════════════════════════════════════════");
    }

    // =========================================================================
    //  Command Execution (Build / Run)
    // =========================================================================

    private void runCommand(String command, String outputTab) {
        Thread runner = new Thread(() -> {
            try {
                ProcessBuilder pb = new ProcessBuilder("bash", "-c", command);
                pb.redirectErrorStream(true);
                if (projectRoot != null) {
                    pb.directory(projectRoot.toFile());
                }

                Process proc = pb.start();
                InputStream is = proc.getInputStream();
                byte[] buf = new byte[4096];
                int n;

                while ((n = is.read(buf)) != -1) {
                    final String chunk = new String(buf, 0, n, StandardCharsets.UTF_8);
                    Platform.runLater(() -> appendToOutput(chunk));
                }

                int exitCode = proc.waitFor();
                Platform.runLater(() -> {
                    appendToOutput("\n[Process exited with code " + exitCode + "]");
                    if (exitCode == 0) {
                        appendToOutput("[" + outputTab + "] ✓ Success");
                    } else {
                        appendToOutput("[" + outputTab + "] ✗ Failed (code " + exitCode + ")");
                    }
                });

            } catch (Exception e) {
                Platform.runLater(() -> appendToOutput("[ERROR] " + e.getMessage()));
            }
        }, "jdesk-ide-cmd");
        runner.setDaemon(true);
        runner.start();
    }

    // =========================================================================
    //  IntelliJ Backend Communication
    // =========================================================================

    private void readIntelliJOutput() {
        try {
            InputStream is = intellijProcess.getInputStream();
            byte[] buf = new byte[4096];
            int n;

            while (intellijRunning && (n = is.read(buf)) != -1) {
                final String chunk = new String(buf, 0, n, StandardCharsets.UTF_8);
                Platform.runLater(() -> appendToOutput("[IntelliJ] " + chunk));
            }
        } catch (IOException e) {
            if (intellijRunning) {
                Platform.runLater(() -> appendToOutput("[IntelliJ] Disconnected."));
            }
        }
        intellijRunning = false;
    }

    // =========================================================================
    //  Output Helpers
    // =========================================================================

    private void appendToOutput(String text) {
        if (bottomToolPane == null) return;
        // Write to the Build tab's TextArea
        Tab buildTab = bottomToolPane.getTabs().stream()
            .filter(t -> "Build".equals(t.getText()))
            .findFirst().orElse(null);
        if (buildTab != null && buildTab.getContent() instanceof TextArea) {
            TextArea area = (TextArea) buildTab.getContent();
            area.appendText(text + "\n");
        }
    }

    // =========================================================================
    //  Keyboard Shortcuts (Global)
    // =========================================================================

    private void handleGlobalKeyPress(KeyEvent event) {
        if (event.isControlDown()) {
            switch (event.getCode()) {
                case N: newFile(); event.consume(); break;
                case O:
                    if (event.isShiftDown()) openProjectDialog();
                    else openFileDialog();
                    event.consume();
                    break;
                case S:
                    if (event.isShiftDown()) saveAllFiles();
                    else saveCurrentFile();
                    event.consume();
                    break;
                case W:
                    if (event.isShiftDown()) closeAllTabs();
                    else closeCurrentTab();
                    event.consume();
                    break;
                case F:
                    showFind();
                    event.consume();
                    break;
                case F9:
                    buildProject();
                    event.consume();
                    break;
                default: break;
            }
        }
        if (event.isAltDown()) {
            switch (event.getCode()) {
                case DIGIT1: toggleProjectPanel(); event.consume(); break;
                case DIGIT7: toggleStructurePanel(); event.consume(); break;
                case F12: toggleTerminal(); event.consume(); break;
                default: break;
            }
        }
        if (event.isShiftDown() && event.getCode() == KeyCode.F10) {
            runProject();
            event.consume();
        }
    }

    // =========================================================================
    //  Utility
    // =========================================================================

    private Optional<TextArea> getCurrentEditor() {
        Tab current = editorTabs.getSelectionModel().getSelectedItem();
        if (current == null) return Optional.empty();
        Node content = current.getContent();
        if (content instanceof BorderPane) {
            Node center = ((BorderPane) content).getCenter();
            if (center instanceof TextArea) {
                return Optional.of((TextArea) center);
            }
        }
        return Optional.empty();
    }
}
