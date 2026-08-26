package com.mearvk.mail.security;

import java.io.*; import java.nio.file.*; import java.time.*;

public final class AuditLog {
    private final Path file;
    public AuditLog(Path file) throws IOException { this.file=file; if(file.getParent()!=null) Files.createDirectories(file.getParent()); }
    public synchronized void event(String type, String detail) { try { Files.writeString(file, Instant.now()+" "+type+" "+detail+System.lineSeparator(), StandardOpenOption.CREATE, StandardOpenOption.APPEND); } catch(IOException e) { System.err.println("audit: "+e); } }
}
