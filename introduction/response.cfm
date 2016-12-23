<h2>Returning Responses</h2>
<p>A Ring response is a simple struct containing at least <tt>status</tt>, <tt>headers</tt>,
  and <tt>body</tt>. These generally represent the HTTP elements to be returned to the client.
  A response struct can contain other fields that may be used by middleware, and middleware
  may modify the values in a response struct. For example, the <tt>wrap_json_response</tt>
  middleware looks for <tt>body</tt> values that are not simple strings and assumes they
  are data structures that should be serialized to JSON (using CFML's built-in
  <tt>serializeJSON()</tt> function -- but you could easily substitute middleware that
  used a different serialization method).</p>
<p>A Ring handler accepts a single argument -- a request struct -- and returns a
  response struct.</p>
