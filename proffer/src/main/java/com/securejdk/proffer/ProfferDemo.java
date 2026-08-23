package com.securejdk.proffer;

public final class ProfferDemo {
    public static void main(String[] args) {
        ProfferModel model = new ProfferModel();
        System.out.printf("area=%.3f m2 radius=%.6f m variants=%d%n",
                model.monolith().geometry().areaM2(),
                model.monolith().geometry().radiusM(),
                model.spectrum().variants());
    }
}
