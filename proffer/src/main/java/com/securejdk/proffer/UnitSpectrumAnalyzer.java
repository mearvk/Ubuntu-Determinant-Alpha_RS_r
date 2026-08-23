package com.securejdk.proffer;

import java.util.ArrayList;
import java.util.List;

public final class UnitSpectrumAnalyzer {
    public UnitSpectrum analyze(double radius, int variants) {
        int n = Math.max(2, variants);
        List<SpectrumCell> cells = new ArrayList<>(n);
        for (int i = 0; i < n; i++) {
            double theta = 2 * Math.PI * i / n;
            double r = radius * Math.sqrt((i + 0.5) / n);
            cells.add(new SpectrumCell(i, new Vec3(r * Math.cos(theta), r * Math.sin(theta), 0), 0, 0));
        }
        return new UnitSpectrum(cells, n, 1.0 / n);
    }
}
