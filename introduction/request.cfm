<h2>Accepting Requests</h2>
<p>A Ring request is a simple struct containing CGI variables and HTTP headers.
  In Ring for CFML, the <tt>req</tt>uest argument passed into a handler is actually
  the <tt>request</tt> scope with all of the <tt>CGI</tt> scope copied into it, as
  well as <tt>uri</tt> which is an alias for <tt>CGI.PATH_INFO</tt> and <tt>headers</tt>
  which is a struct containing all of the HTTP headers received by the server, with hyphen
  replaced by underscore (so <tt>Content-Type</tt> becomes <tt>req.headers.content_type</tt>).</p>
<p>In Ring for Clojure, the request is immutable but you can create a new request struct with
  additional elements (or fewer elements) that you can pass to other handlers in the chain.
  In Ring for CFML, you can update the request directly, and then pass it on to other handlers.</p>
<p>A request can contain additional elements added by middleware and is the way that
  middleware and handlers communicate. Common additions to the request include
  <tt>params</tt>, added by the <tt>wrap_params</tt> middleware, <tt>session</tt>,
  added by the <tt>wrap_session</tt> middleware, and <tt>cookies</tt>, added
  by the <tt>wrap_cookies</tt> middleware.</p>
<p>A Ring handler accepts a single argument -- a request struct -- and returns a
  response struct.</p>
