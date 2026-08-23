package com.securejdk.proffer;

import java.util.List;

public final class ProfferModel {
    public static final double EARTH_BEARING_MODULE = 2000.1;
    private final FloatingMonolith monolith;
    private final UnitSpectrum spectrum;
    public ProfferModel() {
        monolith = new FloatingMonolith(MonolithGeometry.DEFAULT);
        spectrum = new UnitSpectrumAnalyzer().analyze(MonolithGeometry.DEFAULT.radiusM(), 1000);
    }
    public FloatingMonolith monolith() { return monolith; }
    public UnitSpectrum spectrum() { return spectrum; }
    public ExactFall exactFall(Vec3 intended, Vec3 origin) {
        return new ExactFallResolver(new MonolithSurface(MonolithGeometry.DEFAULT)).resolve(intended, origin);
    }
    public List<CallFall> callFall(Vec3 center, List<Vec3> candidates) {
        return new CallFallAnalyzer().analyze(center, candidates);
    }
}
