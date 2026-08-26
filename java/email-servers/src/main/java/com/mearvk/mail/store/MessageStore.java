package com.mearvk.mail.store;

import java.io.IOException;

public interface MessageStore {
    void append(MailMessage message) throws IOException;
}
