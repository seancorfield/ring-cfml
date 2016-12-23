<cfoutput>
  <h1>Hello</h1>
  <p>Session middleware, default handler. Counter #req.session.counter#.</p>
  <p>The <tt>req.session.counter</tt> is incremented on every request, by the
    primary handler in <tt>Application.cfc</tt> (but it is only displayed on this page).</p>
  <p><a href="two.cfm">Page 2</a></p>
</cfoutput>
