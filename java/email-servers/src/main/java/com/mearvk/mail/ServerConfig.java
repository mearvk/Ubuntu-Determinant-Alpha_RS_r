package com.mearvk.mail;

import java.nio.file.Path;

/** Immutable service configuration. Author: Max Rupplin - MEARVK LLC 2026. */
public record ServerConfig(int port, int maxMessageBytes, int maxRecipients, Path spool, Path audit) {
    public static ServerConfig defaults() {
        return new ServerConfig(Integer.getInteger("mail.port", 2525),
                Integer.getInteger("mail.maxMessageBytes", 10 * 1024 * 1024),
                Integer.getInteger("mail.maxRecipients", 100),
                Path.of(System.getProperty("mail.spool", "spool")),
                Path.of(System.getProperty("mail.audit", "logs/mail-audit.log")));
    }
}
