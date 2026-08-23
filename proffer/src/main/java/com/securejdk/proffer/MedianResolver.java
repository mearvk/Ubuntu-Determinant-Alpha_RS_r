package com.securejdk.proffer;

import java.util.Arrays;

public final class MedianResolver {
    public double median(double[] values) {
        if (values.length == 0) throw new IllegalArgumentException("empty sample");
        double[] copy = values.clone();
        Arrays.sort(copy);
        int m = copy.length / 2;
        return copy.length % 2 == 0 ? (copy[m - 1] + copy[m]) / 2.0 : copy[m];
    }
}
