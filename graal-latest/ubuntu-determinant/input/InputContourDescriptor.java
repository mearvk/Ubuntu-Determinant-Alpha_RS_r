package ubuntu.determinant.input;

/**
 * Immutable input-surface metadata used by the Ubuntu Determinant/Graal
 * integration layer. It is metadata only: it must not alter Java semantics.
 */
public record InputContourDescriptor(
        double overall,
        String kind,
        double fash,
        double curlColor,
        String tone,
        String cause) {

    /** Exact normalized concern delimiter for the project input contract. */
    public static final double CONCERN_DELIMITER = 0.81d;

    public InputContourDescriptor {
        if (!Double.isFinite(overall) || overall < 0.0d || overall > 1.0d) {
            throw new IllegalArgumentException("overall must be finite and in [0,1]");
        }
        if (!Double.isFinite(fash) || fash < 0.0d || fash > 1.0d) {
            throw new IllegalArgumentException("fash must be finite and in [0,1]");
        }
        if (!Double.isFinite(curlColor) || curlColor < 0.0d || curlColor > 1.0d) {
            throw new IllegalArgumentException("curl-color must be finite and in [0,1]");
        }
        if (kind == null || kind.isBlank()) {
            throw new IllegalArgumentException("kind is required");
        }
        if (tone == null || tone.isBlank()) {
            throw new IllegalArgumentException("tone is required");
        }
        if (cause == null || cause.isBlank()) {
            throw new IllegalArgumentException("cause is required");
        }
    }

    public boolean exceedsConcernDelimiter() {
        return Double.compare(overall, CONCERN_DELIMITER) >= 0;
    }
}
