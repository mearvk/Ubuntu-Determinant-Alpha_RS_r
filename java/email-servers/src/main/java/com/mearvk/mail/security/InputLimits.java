package com.mearvk.mail.security;

public record InputLimits(int maxLineBytes, int maxMessageBytes, int maxRecipients) {
    public static InputLimits standard() { return new InputLimits(8192, 10 * 1024 * 1024, 100); }
}
