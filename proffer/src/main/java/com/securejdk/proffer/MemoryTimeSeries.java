package com.securejdk.proffer;

import java.util.ArrayList;
import java.util.List;

public final class MemoryTimeSeries {
    public List<MemoryObject> advance(List<MemoryObject> objects, long tick) {
        List<MemoryObject> out = new ArrayList<>(objects.size());
        for (MemoryObject o : objects) {
            long age = Math.max(0, tick - o.bornTick());
            Vec3 p = o.position().add(new Vec3(0, 0, -age));
            out.add(new MemoryObject(o.id(), p, o.mass(), o.bornTick()));
        }
        return List.copyOf(out);
    }
}
