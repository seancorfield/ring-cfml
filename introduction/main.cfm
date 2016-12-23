<h2>The Primary Handler in an Application</h2>
<p>The name <tt>handler</tt> in <tt>Application.cfc</tt> is special: it is the overall
  request handler function for your application. All requests are passed into this function
  and the result of this function is every response produced by the application.</p>
<p><em>[OK, that's not quite true in Ring for CFML because if your <tt>handler</tt>
  function doesn't produce a renderable result -- missing any one of the three
  mandatory fields -- then Ring for CFML will include the originally requested URL's
  template for you, and use that as the response for the request]</em></p>
<p>Your <tt>Application.cfc</tt> can have a regular function called <tt>handler</tt>
  that accepts a single <tt>req</tt>uest argument and returns a response struct. Or
  it can be defined inline as a closure. Since the primary handler is usually composed
  from several pieces of middleware wrapping an underlying handler, it is most common
  to define the <tt>handler</tt> inline, using <tt>ring.middleware/stack</tt> to wrap
  the underlying handler function in several layers of middleware.</p>
