package com.securejdk.proffer;

import java.util.ArrayList;
import java.util.List;

public final class FloatingMonolith {
    private final MonolithGeometry geometry;
    private final List<ProfferNode> objects = new ArrayList<>();
    public FloatingMonolith(MonolithGeometry geometry) { this.geometry = geometry; }
    public MonolithGeometry geometry() { return geometry; }
    public void approach(ProfferNode node) { objects.add(node); }
    public List<ProfferNode> objects() { return List.copyOf(objects); }
}
