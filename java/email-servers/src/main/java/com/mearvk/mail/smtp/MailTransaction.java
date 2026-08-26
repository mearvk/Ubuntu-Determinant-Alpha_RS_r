package com.mearvk.mail.smtp;

import java.util.*;

public final class MailTransaction {
    private String from;
    private final List<String> recipients = new ArrayList<>();
    public void reset() { from = null; recipients.clear(); }
    public void from(String value) { from = value; }
    public void recipient(String value) { recipients.add(value); }
    public String from() { return from; }
    public List<String> recipients() { return List.copyOf(recipients); }
    public boolean ready() { return from != null && !recipients.isEmpty(); }
}
