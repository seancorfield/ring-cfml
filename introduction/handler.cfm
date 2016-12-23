<h2>Handler Functions</h2>
<p>A Ring handler is a function that accepts a request -- typically an argument called <tt>req</tt> --
  and returns a response. A request is a simple struct, containing a handful of mandatory fields but
  any number of optional fields (added by middleware). A response is also a simple struct, containing
  at least <tt>status</tt>, <tt>headers</tt>, and <tt>body</tt> -- but can contain any number of
  optional fields (which may be used by middleware).</p>
<p>A handler function can be a regular CFML function or a function expression (or a closure). A handler
  function may or may not use the <tt>req</tt>uest that it is passed in. Here's a very simple handler
  that always responds with a fixed response:</p>
<pre>
  function hello_world( req ) {
    return { status : 200, headers : { }, body "Hello World!" };
  }
</pre>
<p>The <tt>ring.util.response</tt> namespace (component) has a helper function for returning simple
  responses:</p>
<pre>
  function hello_world( req ) {
    var r = new ring.util.response();
    return r.response( "Hello World!" );
  }
</pre>
<p>A handler function can do as little or as much as you need to produce a response, but you
  probably want to keep your handler functions fairly simple and delegate more complex logic
  to other functions -- but these are not "controllers" in the typical MVC architecture, they
  are "just" functions. Although their input is tied to Ring to some extent and their result
  is also tied to Ring, the input and output are determined by a specification rather than a
  framework. A Ring handler can be used within any application that uses the Ring specification
  and thus by any web server that supports Ring. <em>[Of course, in the CFML world, we don't
  have any other "Ring adapters" at the moment!]</em></p>
