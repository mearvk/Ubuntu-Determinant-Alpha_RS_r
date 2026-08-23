package com.securejdk.proffer;

public record CallFall(Vec3 candidatePoint, double probability, int nextReactionIndex) {
    public CallFall { probability = Math.max(0, Math.min(1, probability)); }
}
