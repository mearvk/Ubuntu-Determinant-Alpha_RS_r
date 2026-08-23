package com.securejdk.proffer;

public record SpectrumCell(int index, Vec3 center, double value, double uncertainty) {
    public SpectrumCell { uncertainty = Math.max(0, uncertainty); }
}
