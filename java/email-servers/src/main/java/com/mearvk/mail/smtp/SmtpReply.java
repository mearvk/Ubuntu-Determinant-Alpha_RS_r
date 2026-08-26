package com.mearvk.mail.smtp;

public record SmtpReply(int code, String text) {
    public static final SmtpReply READY = new SmtpReply(220, "Coherent Java Mail Server ready");
    public static final SmtpReply OK = new SmtpReply(250, "OK");
    public static final SmtpReply BYE = new SmtpReply(221, "Bye");
    public static final SmtpReply BAD_SEQUENCE = new SmtpReply(503, "Bad command sequence");
    public static final SmtpReply SYNTAX = new SmtpReply(500, "Syntax error");
}
