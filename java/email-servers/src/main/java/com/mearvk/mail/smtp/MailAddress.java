package com.mearvk.mail.smtp;

/** Conservative SMTP path value; full address policy can be added later. */
public record MailAddress(String value) {
    public MailAddress { if (value == null || value.isBlank() || value.length() > 320) throw new IllegalArgumentException("invalid address"); }
    @Override public String toString() { return value; }
}
