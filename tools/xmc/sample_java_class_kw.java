// sample_java_class_kw.java — test parser accepting 'class' as identifier
public class KwTest {
    public void f(int class) {
        int value = class + 1;
    }
    public static void main(String[] args) {
        KwTest t = new KwTest();
    }
}
