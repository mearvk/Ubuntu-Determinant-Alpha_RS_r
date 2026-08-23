package com.securejdk.proffer;

import java.util.List;

public final class SubasmissionEngine {
    public Subasmission submit(String carrierId, String partId, List<String> nextParts, double affinity) {
        int next = nextParts.isEmpty() ? -1 : 0;
        return new Subasmission(carrierId, partId, next, affinity);
    }
}
