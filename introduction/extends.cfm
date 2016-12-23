<h2>Depending on Ring</h2>
<p>Your <tt>Application.cfc</tt> needs to reference Ring somehow to get access to the
  basic lifecycle that executes the primary handler. The easiest way is to simply extend
  <tt>ring.core</tt>, which includes <tt>onRequestStart()</tt>,
  <tt>onRequest()</tt>, and <tt>onRequestEnd()</tt> functions, as well as defining
  a default primary <tt>handler</tt> function (which does nothing: it simply returns
  the <tt>req</tt>uest it was passed in, as its response).</p>
<p><tt>onRequestStart()</tt> sets up the request struct and calls the primary handler.</p>
<p><tt>onRequestEnd()</tt> completes the request by providing default values for
  <tt>status</tt> (<tt>200</tt>), <tt>headers</tt> (<tt>{ }</tt>),
  and <tt>body</tt> (<tt>""</tt>, an empty string), and then setting the HTTP
  status code, writing the HTTP headers, and finally writing the HTTP response string.</p>
<p><tt>onRequest()</tt> only plays a part if your primary handler does not return
  a response. It is specific to Ring for CFML, and it provides a default HTML
  response based on the originally requested page (per the URL, not the URI / PATH_INFO).
  This allows you to introduce Ring gradually into your application since the default
  behavior -- for the default <tt>handler</tt> to simply return the <tt>req</tt>uest --
  is to execute the originally requested template anyway. As your <tt>handler</tt>
  intercepts and responds to requests, Ring for CFML will stop executing the template
  implied by those requests and rely on your <tt>handler</tt> instead.</p>
<p>An alternative is for your <tt>Application.cfc</tt> to delegate those three
  methods to Ring. You can see this in <tt>examples/2outside</tt> which has this as
  its <tt>Application.cfc</tt>:</p>
<pre>
component {

  // (require '[ring.core :as ring])
  ring = new ring.core();
  function onRequestStart( target ) {
    return ring.onRequestStart( target );
  }
  function onRequest( target ) {
    return ring.onRequest( target );
  }
  function onRequestEnd() {
    return ring.onRequestEnd();
  }

}
</pre>
<p>That's all the "boilerplate" that is required to delegate to Ring. You'd add in
  your primary <tt>handler</tt> and any other application or session customization you
  needed, but that's it.</p>
