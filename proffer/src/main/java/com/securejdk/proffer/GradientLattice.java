package com.securejdk.proffer;

import java.util.ArrayList;
import java.util.List;

public final class GradientLattice {
    public static final int DEFAULT_VARIANTS = 1000;
    public List<ResolutionGradient> build(int variants) {
        int n = Math.max(2, variants);
        List<ResolutionGradient> out = new ArrayList<>(n);
        for (int i = 0; i < n; i++) {
            double u = (double) i / (n - 1);
            out.add(new ResolutionGradient(i, u, 1.0 / (n - 1)));
        }
        return List.copyOf(out);
    }
}
