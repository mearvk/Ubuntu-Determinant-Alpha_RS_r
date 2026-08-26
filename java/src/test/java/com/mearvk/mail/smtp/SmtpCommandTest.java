package com.mearvk.mail.smtp;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class SmtpCommandTest {
    @Test void parsesVerbAndArgument() { var c=SmtpCommand.parse("MAIL FROM:<a@example.test>"); assertEquals("MAIL",c.verb()); assertTrue(c.argument().startsWith("FROM:")); }
    @Test void parsesBareVerb() { assertEquals("QUIT",SmtpCommand.parse("quit").verb()); }
}
