package com.securejdk.proffer;

import java.util.List;

/** Deterministic seed for the conceptual net-centered 3D process/time model. */
public record NetUniverse(double netCenter, double perfectionTolerance, List<MemoryObject> objects) {
    public NetUniverse {
        objects = List.copyOf(objects);
        if (perfectionTolerance < 0) throw new IllegalArgumentException("negative tolerance");
    }

    public Scape3D scape() { return new Scape3D(this, objects); }
}
