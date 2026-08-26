package com.mearvk.mail.security;

import java.nio.charset.StandardCharsets; import java.security.MessageDigest;

public final class PasswordAuth {
    private final String user; private final byte[] secret;
    public PasswordAuth(String user, String password) { this.user=user; this.secret=password.getBytes(StandardCharsets.UTF_8); }
    public boolean verify(String candidateUser, String candidatePassword) {
        return user.equals(candidateUser) && MessageDigest.isEqual(secret, candidatePassword.getBytes(StandardCharsets.UTF_8));
    }
}
