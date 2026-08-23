package com.securejdk.proffer;

import java.util.List;

public record ProfferNode(String id, Vec3 position, List<String> parts) {
    public ProfferNode { parts = List.copyOf(parts); }
}
