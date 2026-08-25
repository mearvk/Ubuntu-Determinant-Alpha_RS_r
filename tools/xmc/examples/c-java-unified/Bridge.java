package examples.cjava;

/**
 * Managed half of the C/Java ASYSMA experience prototype.
 * The production bridge should use a documented JNI or FFM boundary.
 */
public final class Bridge {
    private Bridge() {}

    public static void main(String[] args) {
        System.out.println("ASYSMA Java layer: started");
        System.out.println("Native ABI contract: version 1");
    }
}
