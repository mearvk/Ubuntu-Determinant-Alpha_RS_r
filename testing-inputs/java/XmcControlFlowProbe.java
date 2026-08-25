public class XmcControlFlowProbe {
    public static int classify(int value) {
        if (value < 0) return -1;
        if (value == 0) return 0;
        return value > 10 ? 1 : 2;
    }

    public static void main(String[] args) {
        System.out.println("xmc-java-control=" + classify(27));
    }
}
