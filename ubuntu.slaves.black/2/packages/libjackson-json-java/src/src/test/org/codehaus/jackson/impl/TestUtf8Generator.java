package org.codehaus.jackson.impl;

import java.io.ByteArrayOutputStream;

import org.codehaus.jackson.JsonFactory;
import org.codehaus.jackson.JsonGenerator;
import org.codehaus.jackson.JsonParser;
import org.codehaus.jackson.JsonToken;
import org.codehaus.jackson.io.IOContext;
import org.codehaus.jackson.util.BufferRecycler;

import main.BaseTest;

public class TestUtf8Generator
    extends BaseTest
{
    public void testUtf8Issue462() throws Exception
    {
        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        IOContext ioc = new IOContext(new BufferRecycler(), bytes, true);
        JsonGenerator gen = new Utf8Generator(ioc, 0, null, bytes);
        String str = "Natuurlijk is alles gelukt en weer een tevreden klant\uD83D\uDE04";
        int length = 4000 - 38;

        for (int i = 1; i <= length; ++i) {
            gen.writeNumber(1);
        }
        gen.writeString(str);
        gen.flush();
    }

    public void testSurrogatesWithRaw() throws Exception
    {
        final String VALUE = quote("\uD83C\uDF89");
        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        IOContext ioc = new IOContext(new BufferRecycler(), bytes, true);
        JsonGenerator jgen = new Utf8Generator(ioc, 0, null, bytes);
        jgen.writeRawValue(VALUE);
        jgen.close();

        final byte[] JSON = bytes.toByteArray();

        JsonParser jp = new JsonFactory().createJsonParser(JSON);
        assertToken(JsonToken.VALUE_STRING, jp.nextToken());
        String str = jp.getText();
        assertEquals(2, str.length());
        assertEquals((char) 0xD83C, str.charAt(0));
        assertEquals((char) 0xDF89, str.charAt(1));
        System.out.println(str);
        jp.close();
    }
}
