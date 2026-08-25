public class XmcControlFlowProbe implements Runnable {
    private final int limit;

    public XmcControlFlowProbe(int limit) {
        this.limit = limit;
    }

    private int compute() {
        int total = 0;
        for (int i = 0; i < limit; i++) {
            if ((i & 1) == 0) {
                total += i;
            } else {
                total -= 1;
            }
        }
        return total;
    }

    public void run() {
        System.out.println("control-flow=" + compute());
    }
}
