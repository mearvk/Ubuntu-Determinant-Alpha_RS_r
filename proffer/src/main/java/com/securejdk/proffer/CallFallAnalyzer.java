package com.securejdk.proffer;

import java.util.ArrayList;
import java.util.List;

public final class CallFallAnalyzer {
    public List<CallFall> analyze(Vec3 center, List<Vec3> candidates) {
        List<CallFall> out = new ArrayList<>();
        for (int i = 0; i < candidates.size(); i++) {
            double d = center.distance(candidates.get(i));
            double p = 1.0 / (1.0 + d);
            out.add(new CallFall(candidates.get(i), p, i + 1));
        }
        return List.copyOf(out);
    }
}
