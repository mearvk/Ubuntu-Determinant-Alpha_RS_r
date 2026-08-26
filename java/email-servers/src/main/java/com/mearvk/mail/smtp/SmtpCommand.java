package com.mearvk.mail.smtp;

public record SmtpCommand(String verb, String argument) {
    public static SmtpCommand parse(String line) {
        if (line == null || line.isBlank()) return new SmtpCommand("", "");
        int p = line.indexOf(' ');
        String v = (p < 0 ? line : line.substring(0, p)).toUpperCase(java.util.Locale.ROOT);
        String a = p < 0 ? "" : line.substring(p + 1).trim();
        return new SmtpCommand(v, a);
    }
}
