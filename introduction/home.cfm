<h2>An Introduction</h2>
<p>This example for Ring uses the <tt>Application.cfc</tt> at the root of the
  repository and the <tt>ring.util.response/uri_file()</tt> handler for displaying templates
  based on <tt>req.uri</tt>. The top-level handler sets a default initial page, if
  <tt>req.uri</tt> is empty:</p>
<pre>
    // Application.cfc
    component extends=ring.core {

      // (require '[ring.middleware :as mw])
      mw = new ring.middleware();
      // (require '[ring.util.response :as resp])
      resp = new ring.util.response();

      handler = mw.default_stack( function( req ) {
        // set the default page
        if ( !len( req.uri ) ) req.uri = "/introduction/home";
        return resp.uri_file( req );
      } );

    }
</pre>
<p>The remaining pages of this example walk you through what each part of that code does.
  Click on the linked pieces of code to learn more:</p>
<ol>
  <li><tt>component <a href="index.cfm/introduction/extends">extends=ring.core</a> {</tt><br>&nbsp;</li>
  <li><tt>&nbsp;&nbsp;// (<a href="index.cfm/introduction/require">require</a> '[ring.middleware :as mw])</tt><br>
    <tt>&nbsp;&nbsp;mw = new ring.middleware();</tt><br>
    <tt>&nbsp;&nbsp;// (<a href="index.cfm/introduction/require">require</a> '[ring.util.response :as resp])</tt><br>
    <tt>&nbsp;&nbsp;resp = new ring.util.response();</tt><br>&nbsp;</li>
  <li><tt>&nbsp;&nbsp;handler = mw.default_stack( function( req ) {</tt></li>
  <li><tt>&nbsp;&nbsp;&nbsp;&nbsp;// set the default page</tt><br>
    <tt>&nbsp;&nbsp;&nbsp;&nbsp;if ( !len( req.uri ) ) req.uri = "/introduction/home";</tt></li>
  <li><tt>&nbsp;&nbsp;&nbsp;&nbsp;return resp.uri_file( req );</tt><br>
    <tt>&nbsp;&nbsp;} );</tt><br>
    <tt>&nbsp;<br>
    <tt>}</tt></li>
</ol>
