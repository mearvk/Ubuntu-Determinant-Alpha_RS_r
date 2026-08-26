package com.mearvk.mail.smtp;

import com.mearvk.mail.ServerConfig;
import com.mearvk.mail.store.FileMessageStore;
import com.mearvk.mail.security.AuditLog;
import java.io.*;
import java.net.*;
import java.util.concurrent.*;

/** Blocking SMTP listener with bounded per-session resources. */
public final class SmtpServer {
    private final ServerConfig config;
    public SmtpServer(ServerConfig config) { this.config = config; }
    public void start() throws IOException {
        FileMessageStore store = new FileMessageStore(config.spool(), config.maxMessageBytes());
        AuditLog audit = new AuditLog(config.audit());
        try (ServerSocket server = new ServerSocket(config.port())) {
            System.out.println("Coherent Java Mail Server listening on " + config.port());
            ExecutorService pool = Executors.newVirtualThreadPerTaskExecutor();
            while (!server.isClosed()) {
                Socket socket = server.accept();
                pool.submit(() -> new SmtpSession(socket, config, store, audit).run());
            }
        }
    }
}
