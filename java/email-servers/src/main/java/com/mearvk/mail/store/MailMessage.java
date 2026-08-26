package com.mearvk.mail.store;

import java.util.List;

public record MailMessage(String from, List<String> recipients, byte[] data) {
    public MailMessage { recipients = List.copyOf(recipients); data = data.clone(); }
}
