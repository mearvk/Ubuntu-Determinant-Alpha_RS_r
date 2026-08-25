public class XmcDesktopProbe {
    private int count;

    public XmcDesktopProbe(int initialCount) {
        this.count = initialCount;
    }

    public int step(boolean increment) {
        if (increment) {
            count++;
        } else if (count > 0) {
            count--;
        }
        return count;
    }

    public String describe() {
        return "XMC desktop/local-output probe count=" + count;
    }

    public static void main(String[] args) {
        XmcDesktopProbe probe = new XmcDesktopProbe(2);
        probe.step(true);
        probe.step(false);
        System.out.println(probe.describe());
    }
}
