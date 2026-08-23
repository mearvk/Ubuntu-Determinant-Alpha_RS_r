package com.securejdk.proffer;

import java.util.List;

public record Scape3D(NetUniverse universe, List<MemoryObject> objects) {
    public Scape3D { objects = List.copyOf(objects); }
}
