/*
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 *
 * JDesk Terminal — Unified JavaFX GUI skin over native shell.
 *
 * The GUI (window, text rendering, scrollback, font, colors) is 100% JavaFX.
 * The shell (bash, zsh, etc.) runs as a native subprocess with its stdin/stdout
 * piped through JDesk. The user interacts with the JavaFX surface only.
 *
 * Architecture:
 *   ┌──────────────────────────────────────────────────────┐
 *   │  JavaFX (JDesk renders everything the user sees)     │
 *   │  ┌──────────────────────────────────────────────┐    │
 *   │  │  TextFlow / Canvas: character grid            │    │
 *   │  │  Cursor: blinking block/bar                   │    │
 *   │  │  Scrollback buffer: List<String>              │    │
 *   │  │  Font: JetBrains Mono / monospace             │    │
 *   │  │  Colors: gray/white on dark (JDesk theme)     │    │
 *   │  └──────────────────────────────────────────────┘    │
 *   └────────────────────────┬─────────────────────────────┘
 *                            │ stdin/stdout/stderr pipes
 *                            ▼
 *   ┌──────────────────────────────────────────────────────┐
 *   │  Native Process: /bin/bash (or user's $SHELL)        │
 *   │  No display access — pure text I/O                   │
 *   │  Governed by JVM Memory Proxy resource limits        │
 *   └──────────────────────────────────────────────────────┘
 *
 * This is the model for ALL JDesk native app skinning:
 *   - JDesk owns the GUI (JavaFX)
 *   - Native binary does the work (subprocess)
 *   - Communication via pipes, sockets, or shared memory
 *
 * License: GPL-2.0
 */

package us.mearvk.jdesk.apps;

import javafx.application.Platform;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.Clipboard;
import javafx.scene.input.ClipboardContent;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.geometry.Insets;
import javafx.animation.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * JDeskTerminal — A JavaFX-skinned terminal emulator.
 *
 * Usage (embed in any JDesk window):
 *   JDeskTerminal terminal = new JDeskTerminal();
 *   somePane.getChildren().add(terminal);
 *   terminal.start();  // launches /bin/bash
 *
 * The native shell has NO GUI. JDesk renders everything.
 */
public class JDeskTerminal extends VBox {

    // =========================================================================
    //  Configuration
    // =========================================================================

    private static final int DEFAULT_COLS = 100;
    private static final int DEFAULT_ROWS = 30;
    private static final double CHAR_WIDTH = 8.4;    // Monospace char width at 14px
    private static final double CHAR_HEIGHT = 18.0;  // Line height at 14px
    private static final String DEFAULT_FONT = "monospace";
    private static final double DEFAULT_FONT_SIZE = 14.0;

    // Colors (gray/white on dark — JDesk unified theme)
    private static final Color BG_COLOR = Color.web("#1A1D23");
    private static final Color FG_COLOR = Color.web("#D4D8E0");
    private static final Color CURSOR_COLOR = Color.web("#A0B0C8");
    private static final Color SELECTION_COLOR = Color.web("#2A4060");
    private static final Color DIM_COLOR = Color.web("#6A7080");
    private static final Color BRIGHT_COLOR = Color.web("#FFFFFF");
    private static final Color PROMPT_COLOR = Color.web("#7090B0");

    // =========================================================================
    //  State
    // =========================================================================

    private Canvas canvas;
    private GraphicsContext gc;
    private Font termFont;

    // Screen buffer (character grid)
    private char[][] screenBuffer;
    private Color[][] fgColors;
    private int cols, rows;
    private int cursorCol = 0, cursorRow = 0;
    private boolean cursorVisible = true;

    // Scrollback
    private List<String> scrollbackBuffer = new ArrayList<>();
    private int scrollOffset = 0;
    private static final int MAX_SCROLLBACK = 10000;

    // Input line buffer (for local echo / line editing)
    private StringBuilder inputBuffer = new StringBuilder();

    // Native shell process
    private Process shellProcess;
    private OutputStream shellStdin;
    private Thread outputReader;
    private boolean running = false;

    // Cursor blink
    private Timeline cursorBlink;
    // Mouse selection state
    private boolean selecting = false;
    private int selStartRow = -1, selStartCol = -1;
    private int selEndRow = -1, selEndCol = -1;

    // =========================================================================
    //  Constructor
    // =========================================================================

    public JDeskTerminal() {
        this(DEFAULT_COLS, DEFAULT_ROWS);
    }

    public JDeskTerminal(int cols, int rows) {
        this.cols = cols;
        this.rows = rows;
        this.screenBuffer = new char[rows][cols];
        this.fgColors = new Color[rows][cols];

        // Initialize buffer
        clearScreen();

        // Font
        termFont = Font.font(DEFAULT_FONT, DEFAULT_FONT_SIZE);

        // Canvas for rendering
        double canvasWidth = cols * CHAR_WIDTH + 16;
        double canvasHeight = rows * CHAR_HEIGHT + 8;
        canvas = new Canvas(canvasWidth, canvasHeight);
        gc = canvas.getGraphicsContext2D();

        // Style the container
        setStyle("-fx-background-color: " + toHex(BG_COLOR) + ";");
        setPadding(new Insets(4));
        getChildren().add(canvas);

        // Key input
        setFocusTraversable(true);
        setOnKeyPressed(this::handleKeyPressed);
        setOnKeyTyped(this::handleKeyTyped);

        // Mouse selection (canvas coordinates -> character grid)
        canvas.setOnMousePressed(e -> {
            double x = e.getX();
            double y = e.getY();
            int c = (int)((x - 8) / CHAR_WIDTH);
            int r = (int)((y - 4) / CHAR_HEIGHT);
            c = Math.max(0, Math.min(cols - 1, c));
            r = Math.max(0, Math.min(rows - 1, r));
            selecting = true;
            selStartCol = selEndCol = c;
            selStartRow = selEndRow = r;
            render();
        });
        canvas.setOnMouseDragged(e -> {
            double x = e.getX();
            double y = e.getY();
            int c = (int)((x - 8) / CHAR_WIDTH);
            int r = (int)((y - 4) / CHAR_HEIGHT);
            c = Math.max(0, Math.min(cols - 1, c));
            r = Math.max(0, Math.min(rows - 1, r));
            selEndCol = c;
            selEndRow = r;
            render();
        });
        canvas.setOnMouseReleased(e -> {
            selecting = false;
            String sel = getSelectedText();
            if (sel != null && !sel.isEmpty()) {
                copySelectionToClipboard(sel);
            }
        });

        // Cursor blink timer
        cursorBlink = new Timeline(new KeyFrame(
            javafx.util.Duration.millis(530),
            e -> {
                cursorVisible = !cursorVisible;
                render();
            }
        ));
        cursorBlink.setCycleCount(Animation.INDEFINITE);

        // Initial render
        render();
    }

    // =========================================================================
    //  Public API
    // =========================================================================

    /**
     * Start the terminal — launches the native shell subprocess.
     * The shell is /bin/bash by default, or the user's $SHELL.
     */
    public void start() {
        start(System.getenv("SHELL") != null ? System.getenv("SHELL") : "/bin/bash");
    }

    /**
     * Start with a specific shell binary.
     */
    public void start(String shellPath) {
        try {
            /*
             * We wrap the shell with `script` to allocate a PTY.
             * Without a PTY, programs detect they're writing to a pipe and
             * switch to full buffering (4-8KB blocks). This causes network
             * commands like ping, curl, ssh to appear "stuck" — their output
             * sits in libc's buffer until it fills or the command exits.
             *
             * `script -qfc <shell> /dev/null` allocates a PTY and connects
             * the shell to it, which forces line-buffered output.
             *
             * Alternative: `stdbuf -oL` — but that only works for programs
             * linked against glibc and doesn't help builtins or statically
             * linked binaries.
             */
            ProcessBuilder pb = new ProcessBuilder(
                "script", "-qfc", shellPath + " -i", "/dev/null"
            );
            pb.redirectErrorStream(true);

            // Set terminal environment
            Map<String, String> env = pb.environment();
            env.put("TERM", "xterm");  // Pretend to be xterm so programs line-buffer
            env.put("COLUMNS", String.valueOf(cols));
            env.put("LINES", String.valueOf(rows));
            env.put("JDESK_TERMINAL", "1");
            // Use a simple, predictable prompt (no color escape sequences) to avoid rendering duplicates
            env.put("PS1", "jdesk:\\w$ ");

            shellProcess = pb.start();
            shellStdin = shellProcess.getOutputStream();
            running = true;

            // Read shell output in background thread
            outputReader = new Thread(this::readShellOutput, "jdesk-term-reader");
            outputReader.setDaemon(true);
            outputReader.start();

            // Start cursor blink
            cursorBlink.play();

            // Focus for keyboard input
            Platform.runLater(this::requestFocus);

            appendLine("JDesk Terminal — Galactic Cherry Marvell Edition 98");
            appendLine("Shell: " + shellPath);
            appendLine("");

        } catch (IOException e) {
            appendLine("[ERROR] Failed to start shell: " + e.getMessage());
        }
    }

    /**
     * Stop the terminal — kills the shell process.
     */
    public void stop() {
        running = false;
        cursorBlink.stop();
        if (shellProcess != null && shellProcess.isAlive()) {
            shellProcess.destroyForcibly();
        }
    }

    /**
     * Get the preferred dimensions for embedding.
     */
    public double getTerminalWidth() {
        return cols * CHAR_WIDTH + 16;
    }

    public double getTerminalHeight() {
        return rows * CHAR_HEIGHT + 8;
    }

    // =========================================================================
    //  Shell I/O
    // =========================================================================

    /**
     * Read output from the native shell and display it.
     * Runs in a background thread.
     *
     * IMPORTANT: We use a raw InputStream (NOT BufferedReader) to avoid
     * buffering delays. Network commands like ping, curl, ssh produce output
     * incrementally — a BufferedReader would hold partial data in its internal
     * 8KB buffer waiting for more, causing the terminal to appear stuck.
     *
     * We read raw bytes as they arrive, decode UTF-8 ourselves, and push
     * each chunk immediately to the JavaFX thread for rendering.
     */
    private void readShellOutput() {
        try {
            InputStream is = shellProcess.getInputStream();
            byte[] buf = new byte[4096];
            int bytesRead;

            while (running && (bytesRead = is.read(buf)) != -1) {
                final String chunk = new String(buf, 0, bytesRead, StandardCharsets.UTF_8);
                Platform.runLater(() -> processOutput(chunk));
            }
        } catch (IOException e) {
            if (running) {
                Platform.runLater(() -> appendLine("[Shell disconnected]"));
            }
        }

        Platform.runLater(() -> {
            appendLine("");
            appendLine("[Process exited]");
            render();
        });
    }

    /**
     * Send keystrokes to the native shell.
     */
    private void sendToShell(String text) {
        if (shellStdin == null || !running) return;
        try {
            shellStdin.write(text.getBytes(StandardCharsets.UTF_8));
            shellStdin.flush();
        } catch (IOException e) {
            appendLine("[Write error: " + e.getMessage() + "]");
        }
    }

    // =========================================================================
    //  Output Processing (simple — no full VT100 yet)
    // =========================================================================

    private void processOutput(String text) {
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);

            switch (c) {
                case '\n':
                    newLine();
                    break;
                case '\r':
                    cursorCol = 0;
                    break;
                case '\b':
                    if (cursorCol > 0) cursorCol--;
                    break;
                case '\t':
                    int tabStop = ((cursorCol / 8) + 1) * 8;
                    cursorCol = Math.min(tabStop, cols - 1);
                    break;
                case '\033':
                    // Skip ANSI escape sequences (consume until letter)
                    i = skipAnsiSequence(text, i);
                    break;
                default:
                    if (c >= 32) {
                        putChar(c);
                    }
                    break;
            }
        }
        render();
    }

    private int skipAnsiSequence(String text, int start) {
        int i = start + 1;
        if (i < text.length() && text.charAt(i) == '[') {
            i++;
            while (i < text.length()) {
                char c = text.charAt(i);
                if (Character.isLetter(c)) return i;
                i++;
            }
        }
        return i;
    }

    private void putChar(char c) {
        if (cursorCol >= cols) {
            newLine();
        }
        screenBuffer[cursorRow][cursorCol] = c;
        fgColors[cursorRow][cursorCol] = FG_COLOR;
        cursorCol++;
    }

    private void newLine() {
        cursorCol = 0;
        cursorRow++;
        if (cursorRow >= rows) {
            scrollUp();
            cursorRow = rows - 1;
        }
    }

    private void scrollUp() {
        // Save top line to scrollback
        scrollbackBuffer.add(new String(screenBuffer[0]).trim());
        if (scrollbackBuffer.size() > MAX_SCROLLBACK) {
            scrollbackBuffer.remove(0);
        }

        // Shift everything up
        for (int r = 0; r < rows - 1; r++) {
            System.arraycopy(screenBuffer[r + 1], 0, screenBuffer[r], 0, cols);
            System.arraycopy(fgColors[r + 1], 0, fgColors[r], 0, cols);
        }

        // Clear bottom row
        Arrays.fill(screenBuffer[rows - 1], ' ');
        Arrays.fill(fgColors[rows - 1], FG_COLOR);
    }

    private void appendLine(String text) {
        for (char c : text.toCharArray()) {
            putChar(c);
        }
        newLine();
    }

    private void clearScreen() {
        for (int r = 0; r < rows; r++) {
            Arrays.fill(screenBuffer[r], ' ');
            Arrays.fill(fgColors[r], FG_COLOR);
        }
        cursorCol = 0;
        cursorRow = 0;
    }

    // =========================================================================
    //  Keyboard Input
    // =========================================================================

    private void handleKeyPressed(KeyEvent event) {
        if (!running) return;

        switch (event.getCode()) {
            case ENTER:
                // Validate command through NetworkConcern before sending
                String pendingCmd = inputBuffer.toString().trim();
                if (!pendingCmd.isEmpty()) {
                    String denial = us.mearvk.jdesk.security.NetworkConcern.validateCommand(pendingCmd);
                    if (denial != null) {
                        // Command blocked — show reason, don't send to shell
                        newLine();
                        for (String line : denial.split("\n")) {
                            appendLine(line);
                        }
                        appendLine("");
                        inputBuffer.setLength(0);
                        render();
                        event.consume();
                        return;
                    }
                    // Telnet warning (non-blocking)
                    if (pendingCmd.startsWith("telnet ")) {
                        String warning = us.mearvk.jdesk.security.NetworkConcern.getTelnetWarning();
                        for (String line : warning.split("\n")) {
                            appendLine(line);
                        }
                    }
                }
                inputBuffer.setLength(0);
                sendToShell("\n");
                break;
            case BACK_SPACE:
                if (inputBuffer.length() > 0) {
                    inputBuffer.deleteCharAt(inputBuffer.length() - 1);
                }
                sendToShell("\b");
                break;
            case TAB:
                sendToShell("\t");
                break;
            case UP:
                sendToShell("\033[A");
                break;
            case DOWN:
                sendToShell("\033[B");
                break;
            case RIGHT:
                sendToShell("\033[C");
                break;
            case LEFT:
                sendToShell("\033[D");
                break;
            case HOME:
                sendToShell("\033[H");
                break;
            case END:
                sendToShell("\033[F");
                break;
            case DELETE:
                sendToShell("\033[3~");
                break;
            default:
                // Ctrl+C, Ctrl+D, etc.
                if (event.isControlDown()) {
                    if (event.getCode() == KeyCode.C) {
                        sendToShell("\003"); // SIGINT
                    } else if (event.getCode() == KeyCode.D) {
                        sendToShell("\004"); // EOF
                    } else if (event.getCode() == KeyCode.L) {
                        clearScreen();
                        render();
                        sendToShell("\014"); // form feed
                    } else if (event.getCode() == KeyCode.Z) {
                        sendToShell("\032"); // SIGTSTP
                    }
                }
                break;
        }
        event.consume();
    }

    private void handleKeyTyped(KeyEvent event) {
        if (!running) return;
        String ch = event.getCharacter();
        if (ch.length() > 0 && ch.charAt(0) >= 32) {
            inputBuffer.append(ch);
            sendToShell(ch);
        }
        event.consume();
    }

    // =========================================================================
    //  Rendering (JavaFX Canvas)
    // =========================================================================

    private void render() {
        double w = canvas.getWidth();
        double h = canvas.getHeight();

        // Clear background
        gc.setFill(BG_COLOR);
        gc.fillRect(0, 0, w, h);

        gc.setFont(termFont);

        // Draw selection background if present
        if (selStartRow >= 0 && selStartCol >= 0 && selEndRow >= 0 && selEndCol >= 0) {
            int r1 = Math.min(selStartRow, selEndRow);
            int r2 = Math.max(selStartRow, selEndRow);
            for (int r = r1; r <= r2; r++) {
                int c1 = (r == r1) ? Math.min(selStartCol, selEndCol) : 0;
                int c2 = (r == r2) ? Math.max(selStartCol, selEndCol) : cols - 1;
                double x = c1 * CHAR_WIDTH + 8;
                double y = r * CHAR_HEIGHT + 4;
                double wrect = (c2 - c1 + 1) * CHAR_WIDTH;
                gc.setFill(SELECTION_COLOR);
                gc.fillRect(x, y, wrect, CHAR_HEIGHT);
            }
        }

        // Draw characters (use inverted color for selected cells)
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                char ch = screenBuffer[r][c];
                if (ch < 32) continue;

                boolean selected = false;
                if (selStartRow >= 0 && selStartCol >= 0 && selEndRow >= 0 && selEndCol >= 0) {
                    int r1 = Math.min(selStartRow, selEndRow);
                    int r2 = Math.max(selStartRow, selEndRow);
                    if (r >= r1 && r <= r2) {
                        int sc = (r == r1) ? Math.min(selStartCol, selEndCol) : 0;
                        int ec = (r == r2) ? Math.max(selStartCol, selEndCol) : cols - 1;
                        if (c >= sc && c <= ec) selected = true;
                    }
                }

                Color fg = fgColors[r][c] != null ? fgColors[r][c] : FG_COLOR;
                gc.setFill(selected ? BRIGHT_COLOR : fg);
                double x = c * CHAR_WIDTH + 8;
                double y = r * CHAR_HEIGHT + CHAR_HEIGHT - 3 + 4;
                gc.fillText(String.valueOf(ch), x, y);
            }
        }

        // Draw cursor on top
        if (cursorVisible && running) {
            double cx = cursorCol * CHAR_WIDTH + 8;
            double cy = cursorRow * CHAR_HEIGHT + 4;
            gc.setFill(CURSOR_COLOR);
            gc.fillRect(cx, cy, CHAR_WIDTH, CHAR_HEIGHT);

            // Draw character at cursor position in inverse
            char cursorChar = screenBuffer[cursorRow][cursorCol];
            if (cursorChar > 32) {
                gc.setFill(BG_COLOR);
                gc.fillText(String.valueOf(cursorChar), cx, cy + CHAR_HEIGHT - 3);
            }
        }
    }

    // =========================================================================
    //  Utility
    // =========================================================================

    /**
     * Build the selected text (multi-line) from the current selection.
     */
    private String getSelectedText() {
        if (selStartRow < 0 || selStartCol < 0 || selEndRow < 0 || selEndCol < 0) return "";
        int r1 = Math.min(selStartRow, selEndRow);
        int r2 = Math.max(selStartRow, selEndRow);
        StringBuilder sb = new StringBuilder();
        for (int r = r1; r <= r2; r++) {
            int sc = (r == r1) ? Math.min(selStartCol, selEndCol) : 0;
            int ec = (r == r2) ? Math.max(selStartCol, selEndCol) : cols - 1;
            for (int c = sc; c <= ec; c++) {
                sb.append(screenBuffer[r][c]);
            }
            if (r < r2) sb.append('\n');
        }
        return sb.toString().replaceAll("\u0000", " ").replaceAll("\u0000", " ");
    }

    private void copySelectionToClipboard(String text) {
        try {
            Clipboard clipboard = Clipboard.getSystemClipboard();
            ClipboardContent content = new ClipboardContent();
            content.putString(text);
            clipboard.setContent(content);
        } catch (Exception ignored) {
            // Clipboard may not be available on headless environments
        }
    }

    private static String toHex(Color c) {
        return String.format("#%02X%02X%02X",
            (int)(c.getRed() * 255),
            (int)(c.getGreen() * 255),
            (int)(c.getBlue() * 255));
    }
}
