package us.mearvk.asysma.tec;

/** Java-side representation of the bounded native/managed transfer contract. */
public final class TecTransfer {
    public static final int VERSION = 1;
    public static final int MAX_TRANSFER = 65536;

    public enum Flow {
        ISOLATED,
        NATIVE_TO_JAVA,
        JAVA_TO_NATIVE
    }

    private final int operation;
    private final int permissions;
    private final int inputSize;
    private final int outputSize;

    public TecTransfer(int operation, int permissions, int inputSize, int outputSize) {
        if (inputSize < 0 || inputSize > MAX_TRANSFER ||
            outputSize < 0 || outputSize > MAX_TRANSFER) {
            throw new IllegalArgumentException("transfer exceeds TEC bound");
        }
        this.operation = operation;
        this.permissions = permissions;
        this.inputSize = inputSize;
        this.outputSize = outputSize;
    }

    public int operation() { return operation; }
    public int permissions() { return permissions; }
    public int inputSize() { return inputSize; }
    public int outputSize() { return outputSize; }
}
