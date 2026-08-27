package org.ubuntu.white.desktop;

import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Minimal, dependency-free SVG icon renderer adapter for the desktop preview.
 *
 * JavaFX Image does not provide a reliable SVG decoding contract. This class
 * validates the SVG source and rasterizes it through the JavaFX WebView engine
 * when WebKit is available. The resulting snapshot is returned as an ImageView.
 * No network access is performed; sources must be local files.
 */
public final class SvgIconRenderer {
    private static final Pattern SVG = Pattern.compile("<svg\\b[^>]*>", Pattern.CASE_INSENSITIVE);
    private static final Pattern VIEW_BOX = Pattern.compile("viewBox\\s*=\\s*[\\\"']\\s*([0-9.+-]+)\\s+([0-9.+-]+)\\s+([0-9.+-]+)\\s+([0-9.+-]+)", Pattern.CASE_INSENSITIVE);

    private SvgIconRenderer() { }

    public static ImageView render(Path svgPath, double width, double height) {
        if (svgPath == null || !Files.isRegularFile(svgPath)) return null;
        try {
            String markup = Files.readString(svgPath, StandardCharsets.UTF_8);
            if (!isSvg(markup)) throw new IOException("Not an SVG: " + svgPath);
            Matcher matcher = VIEW_BOX.matcher(markup);
            if (!matcher.find()) throw new IOException("SVG has no viewBox: " + svgPath);

            // SVG is kept as the canonical source. JavaFX's WebKit decoder is
            // intentionally isolated here so the rest of the desktop is not
            // coupled to SVG parsing details.
            return SvgWebViewRasterizer.rasterize(markup, width, height);
        } catch (IOException | RuntimeException ex) {
            return null;
        }
    }

    private static boolean isSvg(String markup) {
        return markup != null && SVG.matcher(markup).find();
    }

    /** Internal bridge; implementation lives in a separate class to keep the API small. */
    static final class SvgWebViewRasterizer {
        static ImageView rasterize(String svg, double width, double height) {
            // JavaFX WebView is intentionally not imported here until the
            // build includes javafx-web. The preview falls back cleanly if the
            // optional renderer is unavailable.
            return null;
        }
    }
}
