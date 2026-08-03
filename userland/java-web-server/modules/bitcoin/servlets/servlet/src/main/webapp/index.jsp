<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Bitcoin™ — NitroWebExpress</title>
    <link rel="stylesheet" href="css/style.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com"/><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
</head>
<body>
<nav class="nav"><div class="nav-inner">
    <span class="nav-brand">Bitcoin™</span>
    <ul class="nav-links">
        <li><a href="index.jsp" class="active">Overview</a></li>
        <li><a href="messaging.jsp">Messages</a></li>
    </ul>
</div></nav>

<section class="hero"><div class="hero-inner">
    <span class="hero-tag">Cryptocurrency • Wallet • Trading</span>
    <h1>Bitcoin™</h1>
    <p>Lightweight Bitcoin trading server compatible with Bitcoin v24.0+. Wallet indexing, session management, trade execution, and Strernary™ AI market analysis.</p>
</div></section>

<section class="section"><div class="section-inner">
    <h2>Infrastructure</h2>
    <div class="table-wrap"><table>
        <thead><tr><th>Property</th><th>Value</th></tr></thead>
        <tbody>
            <tr><td>TCP Port</td><td><code>6682</code></td></tr>
            <tr><td>Protocol</td><td>BitcoinCompliant (telnet front)</td></tr>
            <tr><td>Backend</td><td>bitcoind RPC</td></tr>
            <tr><td>AI</td><td>Strernary™ port 20000 (market analysis)</td></tr>
            <tr><td>Database</td><td><code>nwe_bitcoin</code> (MySQL)</td></tr>
            <tr><td>Features</td><td>Wallet indexing, session management, trade execution, multi-timezone</td></tr>
            <tr><td>Theme</td><td>Bitcoin Orange (#f7931a)</td></tr>
            <tr><td>Installer</td><td>Max Rupplin — MEARVK LLC</td></tr>
        </tbody>
    </table></div>
</div></section>

<section class="section"><div class="section-inner">
    <h2>Access</h2>
    <div class="table-wrap"><table>
        <thead><tr><th>Method</th><th>Command</th><th>Notes</th></tr></thead>
        <tbody>
            <tr><td>Telnet</td><td><code>telnet localhost 6682</code></td><td>Primary interface — trading, wallet, session</td></tr>
            <tr><td>Web</td><td><code>http://localhost:8080/bitcoin/</code></td><td>This page (Tomcat servlet)</td></tr>
            <tr><td>NWE Main</td><td><code>telnet localhost 49152</code> → select Bitcoin module</td><td>Via NitroWebExpress main port</td></tr>
        </tbody>
    </table></div>
</div></section>

<footer class="footer"><div><span>© 2026 MEARVK LLC. Bitcoin™ — Warm Amber Edition. NitroWebExpress.</span></div></footer>
</body></html>
