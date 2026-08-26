package com.mearvk.mail.store;

import java.io.*;
import java.nio.file.*;
import java.util.*;

public final class FileMessageStore implements MessageStore {
    private final Path root; private final int maxBytes;
    public FileMessageStore(Path root, int maxBytes) throws IOException { this.root=root; this.maxBytes=maxBytes; Files.createDirectories(root); }
    @Override public void append(MailMessage m) throws IOException {
        if (m.data().length > maxBytes) throw new IOException("message exceeds configured limit");
        String id = UUID.randomUUID().toString();
        Path tmp = root.resolve(id + ".tmp"), dst = root.resolve(id + ".eml");
        String headers = "From: " + m.from() + "\nTo: " + String.join(", ", m.recipients()) + "\n\n";
        try (OutputStream out = Files.newOutputStream(tmp, StandardOpenOption.CREATE_NEW)) { out.write(headers.getBytes(java.nio.charset.StandardCharsets.UTF_8)); out.write(m.data()); }
        Files.move(tmp, dst, StandardCopyOption.ATOMIC_MOVE);
    }
}
