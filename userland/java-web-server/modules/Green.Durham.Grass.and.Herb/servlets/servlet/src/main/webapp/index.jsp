<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.HttpURLConnection, java.net.URI" %>
<%
    boolean authorized = false;
    try {
        HttpURLConnection conn = (HttpURLConnection) URI.create("https://raw.githubusercontent.com/mearvk/Java.Web.Server.Telnet.Front.Java.21/main/psychiatry/secrets/public.key").toURL().openConnection();
        conn.setRequestMethod("HEAD");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);
        authorized = (conn.getResponseCode() == 200);
        conn.disconnect();
    } catch (Exception e) { authorized = false; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Green.Durham.Grass.and.Herb&#8482;</title>
    <link rel="stylesheet" href="css/style.css">
<script src="js/scroll-preserve.js"></script>
</head>
<body>
<nav>
    <span class="brand">Green.Durham.Grass.and.Herb&#8482;</span>
    <div class="links">
        <a href="index.jsp" class="active">Overview</a>
        <a href="labor.jsp">Labor</a>
        <a href="ethical.jsp">Ethical</a>
        <a href="moral.jsp">Moral</a>
        <a href="listeners.jsp">Listeners</a>
        <a href="status.jsp">Status</a>
    </div>
</nav>
<div class="container">
    <div class="hero">
        <span class="tag">NC Socialist-College Block</span>
        <h1>Green.Durham.Grass.and.Herb&#8482;</h1>
        <p>Appree contact server with labor, ethical, moral, and mortality concerns databases. JWSTFJ21 masquerade-integrated.</p>
        <div class="auth-box">
            <span class="status-dot <%= authorized ? "green" : "red" %>"></span>
            <%= authorized ? "Authorized — public.key present" : "Unauthorized — public.key missing" %>
        </div>
    </div>
    <div class="section">
        <h2>Components</h2>
        <table>
            <tr><th>Component</th><th>Type</th><th>Status</th></tr>
            <tr><td>Labor Concerns DB</td><td>MySQL</td><td><span class="status-dot green"></span>Active</td></tr>
            <tr><td>Ethical Concerns DB</td><td>MySQL</td><td><span class="status-dot green"></span>Active</td></tr>
            <tr><td>Moral Concerns DB</td><td>MySQL</td><td><span class="status-dot green"></span>Active</td></tr>
            <tr><td>Mortality Concerns DB</td><td>MySQL</td><td><span class="status-dot green"></span>Active</td></tr>
            <tr><td>Appree Contact Server</td><td>TCP</td><td><span class="status-dot green"></span>Active</td></tr>
            <tr><td>Coast Listeners</td><td>TCP</td><td><span class="status-dot green"></span>Active</td></tr>
        </table>
    </div>
    <div class="section">
        <h2>Ports</h2>
        <table>
            <tr><th>Port</th><th>Service</th><th>Description</th></tr>
            <tr><td>2000</td><td>Directory</td><td>Strernary&#8482; Directory Server</td></tr>
            <tr><td>20000</td><td>Appree Base</td><td>Primary Appree contact endpoint</td></tr>
            <tr><td>40002</td><td>East Coast</td><td>East Coast listener</td></tr>
            <tr><td>40003</td><td>West Coast</td><td>West Coast listener</td></tr>
            <tr><td>40007</td><td>Texas</td><td>Texas listener</td></tr>
            <tr><td>49152</td><td>NationalFinanceID</td><td>National finance identification</td></tr>
        </table>
    </div>
</div>
<!-- download-roadmap-section -->
<section class="section" style="border-top:1px solid #27272a;">
    <div class="section-inner">
        <h2>Download &amp; Roadmap</h2>
        <div style="display:flex;gap:1.5rem;flex-wrap:wrap;margin-bottom:1.5rem;">
            <a href="https://github.com/mearvk/Green.Durham.Grass.and.Herb" target="_blank" rel="noopener noreferrer" style="display:inline-flex;align-items:center;gap:0.5rem;padding:0.75rem 1.5rem;border-radius:8px;background:#238636;border:1px solid #2ea043;color:#fff;font-size:0.9rem;text-decoration:none;font-weight:600;transition:background 0.2s;">
                &#11015; Download Now (GitHub)
            </a>
            <a href="https://github.com/mearvk/Java.Web.Server.Telnet.Front.Java.21" target="_blank" rel="noopener noreferrer" style="display:inline-flex;align-items:center;gap:0.5rem;padding:0.75rem 1.5rem;border-radius:8px;background:#1a1a2e;border:1px solid #27272a;color:#a1a1aa;font-size:0.9rem;text-decoration:none;font-weight:500;">
                &#128230; Full NWE Distribution
            </a>
        </div>
        <div class="table-wrap"><table><thead><tr><th>Phase</th><th>Milestone</th><th>Status</th></tr></thead><tbody>
            <tr><td>1</td><td>Core backend &amp; servlet interface</td><td style="color:#22c55e;">&#10003; Complete</td></tr>
            <tr><td>2</td><td>Database schema &amp; MySQL integration</td><td style="color:#22c55e;">&#10003; Complete</td></tr>
            <tr><td>3</td><td>JSP front-end &amp; CD1 connector</td><td style="color:#22c55e;">&#10003; Complete</td></tr>
            <tr><td>4</td><td>Ubuntu kernel build integration</td><td style="color:#22c55e;">&#10003; Complete</td></tr>
            <tr><td>5</td><td>Security hardening &amp; auth</td><td style="color:#eab308;">&#9679; In Progress</td></tr>
            <tr><td>6</td><td>Production deployment &amp; monitoring</td><td style="color:#71717a;">&#9675; Planned</td></tr>
        </tbody></table></div>
        <p style="font-size:0.75rem;color:#71717a;margin-top:1rem;">Source: <a href="https://github.com/mearvk/Green.Durham.Grass.and.Herb" target="_blank" style="color:#60a5fa;">github.com/mearvk/Green.Durham.Grass.and.Herb</a></p>
    </div>
</section>
<footer>&copy; 2026 MEARVK LLC</footer>
</body>
</html>
