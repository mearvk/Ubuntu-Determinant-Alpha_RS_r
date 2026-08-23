package com.securejdk.proffer;

public record Subasmission(String carrierId, String partId, int nextPartIndex, double affinity) {
    public Subasmission { affinity = Math.max(0, Math.min(1, affinity)); }
}
