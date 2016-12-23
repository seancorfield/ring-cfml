<h2>Requiring Ring Components</h2>
<p>In Clojure, where Ring itself originated, functions are organized into namespaces,
  and a namespace is <tt>require</tt>d into another namespace that needs its functions.
  The only options in CFML for organizing functions are <tt>.cfm</tt> files, included
  into other files as needed, or <tt>.cfc</tt> files which behave like classes, and
  need to be instantiated before functions can be accessed. Since include files provide
  no separation of names -- when you include a file, all of its functions overwrite your
  current variables scope -- Ring for CFML uses <tt>.cfc</tt> files. That provides the
  right level of organization but has the disadvantage that you must create an actual
  instance of the CFC in order to reference plain functions.</p>
<p>In Clojure you would say:</p>
<pre>
  (require '[ring.util.response :as r])
  (r/response "Hello World!")
</pre>
<p>In CFML, you say this instead:</p>
<pre>
  r = new ring.util.response();
  r.response( "Hello World!" );
</pre>
<p>Because, in Ring, you use functions in isolation, out of the context of the CFCs in
  which they are declared, you need to be very cognizant of the fact that each function
  must be completely self-contained: it cannot rely on any other variables within the CFC.
  In particular, even if the CFC "requires" Ring components at the top level, the function
  must "require" the Ring components itself:</p>
<pre>
  function greeting( req ) {
    var r = new ring.util.response();
    return r.response( "Hello World!" );
  }
</pre>
