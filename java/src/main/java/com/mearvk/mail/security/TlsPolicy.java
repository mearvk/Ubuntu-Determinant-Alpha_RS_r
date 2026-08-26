package com.mearvk.mail.security;

import javax.net.ssl.SSLContext;

public record TlsPolicy(boolean startTls, String[] protocols) {
    public static TlsPolicy modern() { return new TlsPolicy(true, new String[]{"TLSv1.3", "TLSv1.2"}); }
    public SSLContext context() throws Exception { return SSLContext.getDefault(); }
}
