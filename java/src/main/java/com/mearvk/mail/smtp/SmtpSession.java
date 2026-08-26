package com.mearvk.mail.smtp;

import com.mearvk.mail.ServerConfig; import com.mearvk.mail.security.AuditLog; import com.mearvk.mail.store.*;
import java.io.*; import java.net.*; import java.nio.charset.StandardCharsets;

/** One SMTP connection and transaction state machine. */
public final class SmtpSession implements Runnable {
    private final Socket socket; private final ServerConfig config; private final MessageStore store; private final AuditLog audit;
    private final MailTransaction tx = new MailTransaction();
    public SmtpSession(Socket socket, ServerConfig config, MessageStore store, AuditLog audit) { this.socket=socket; this.config=config; this.store=store; this.audit=audit; }
    @Override public void run() {
        try (socket; BufferedReader in=new BufferedReader(new InputStreamReader(socket.getInputStream(), StandardCharsets.US_ASCII)); BufferedWriter out=new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), StandardCharsets.US_ASCII))) {
            reply(out,SmtpReply.READY); String line;
            while ((line=in.readLine())!=null) {
                if(line.length()>8192){ reply(out,new SmtpReply(500,"Line too long")); continue; }
                SmtpCommand c=SmtpCommand.parse(line); audit.event("command", c.verb());
                if(c.verb().equals("QUIT")){ reply(out,SmtpReply.BYE); break; }
                if(c.verb().equals("EHLO")||c.verb().equals("HELO")){ reply(out,new SmtpReply(250,"coherent-mail\nSIZE "+config.maxMessageBytes()+"\n8BITMIME\nSTARTTLS")); continue; }
                if(c.verb().equals("NOOP")){ reply(out,SmtpReply.OK); continue; }
                if(c.verb().equals("RSET")){ tx.reset(); reply(out,SmtpReply.OK); continue; }
                if(c.verb().equals("MAIL")){ if(!c.argument().toUpperCase().startsWith("FROM:")){reply(out,SmtpReply.SYNTAX);continue;} tx.reset(); tx.from(c.argument().substring(5).trim()); reply(out,SmtpReply.OK); continue; }
                if(c.verb().equals("RCPT")){ if(tx.from()==null||!c.argument().toUpperCase().startsWith("TO:")){reply(out,SmtpReply.BAD_SEQUENCE);continue;} if(tx.recipients().size()>=config.maxRecipients()){reply(out,new SmtpReply(452,"Too many recipients"));continue;} tx.recipient(c.argument().substring(3).trim()); reply(out,SmtpReply.OK); continue; }
                if(c.verb().equals("DATA")){ handleData(in,out); continue; }
                if(c.verb().equals("STARTTLS")){ reply(out,new SmtpReply(454,"TLS transport requires configured certificate context")); continue; }
                reply(out,SmtpReply.SYNTAX);
            }
        } catch(Exception e) { audit.event("session-error", e.getClass().getSimpleName()); }
    }
    private void handleData(BufferedReader in, BufferedWriter out) throws IOException {
        if(!tx.ready()){reply(out,SmtpReply.BAD_SEQUENCE);return;} reply(out,new SmtpReply(354,"End data with <CR><LF>.<CR><LF>"));
        ByteArrayOutputStream body=new ByteArrayOutputStream(); String line; int max=config.maxMessageBytes();
        while((line=in.readLine())!=null){ if(line.equals(".")) break; if(line.startsWith("..")) line=line.substring(1); byte[] b=(line+"\r\n").getBytes(StandardCharsets.UTF_8); if(body.size()+b.length>max){reply(out,new SmtpReply(552,"Message too large")); tx.reset(); return;} body.write(b); }
        if(line==null){tx.reset();return;} store.append(new MailMessage(tx.from(),tx.recipients(),body.toByteArray())); audit.event("accepted", tx.from()); tx.reset(); reply(out,SmtpReply.OK);
    }
    private static void reply(BufferedWriter out,SmtpReply r) throws IOException { String[] lines=r.text().split("\\n",-1); for(int i=0;i<lines.length;i++) out.write(r.code()+(i+1<lines.length?"-":" ")+lines[i]+"\r\n"); out.flush(); }
}
