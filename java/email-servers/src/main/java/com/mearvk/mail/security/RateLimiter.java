package com.mearvk.mail.security;

import java.time.*; import java.util.concurrent.atomic.AtomicInteger;

/** Small per-process admission limiter; persistent policy belongs outside the protocol layer. */
public final class RateLimiter {
    private final int limit; private final Duration window; private final AtomicInteger count=new AtomicInteger(); private volatile Instant reset=Instant.now();
    public RateLimiter(int limit, Duration window){this.limit=limit;this.window=window;}
    public synchronized boolean allow(){ Instant now=Instant.now(); if(now.isAfter(reset.plus(window))){reset=now;count.set(0);} return count.incrementAndGet()<=limit; }
}
