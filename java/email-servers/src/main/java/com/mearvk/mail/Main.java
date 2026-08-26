package com.mearvk.mail;

import com.mearvk.mail.smtp.SmtpServer;

/** Entry point. Author: Max Rupplin - MEARVK LLC 2026. */
public final class Main {
    private Main() {}
    public static void main(String[] args) throws Exception {
        ServerConfig config = ServerConfig.defaults();
        new SmtpServer(config).start();
    }
}
