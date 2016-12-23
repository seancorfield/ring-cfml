<h2>Curried Functions</h2>
<p>Since both middleware functions and handler functions accept just a single argument --
  <tt>handler</tt> and <tt>req</tt> respectively -- if you want to provide parameters to
  these functions, you need to "curry" the arguments. Instead of defining a function that
  takes those additional arguments <strong>and</strong> the expected argument, you will
  define a function that takes just those arguments and returns a closure: a function that
  accepts the expected single argument.<p>
<p>The <tt>layout_with()</tt> function in the introduction <tt>Application.cfc</tt> is a
  good example of this: it accepts <tt>path</tt> and returns a closure, middleware that
  accepts <tt>handler</tt> and in turn returns a closure, a handler that accepts <tt>req</tt>
  and in its turns returns a response. Phew!</p>
<p>Note that <tt>ring.util.response/file</tt> is not technically a handler function,
  despite the way it is referred to in <tt>Application.cfc</tt>, because it accepts
  two arguments: <tt>req</tt> and the path of the file to "include". In order to create
  a true handler function from it, you'd need to wrap it in a function that accepted the
  path of the file and returned a closure, a handler that accepts just <tt>req</tt>.</p>
