component {

  // set the content-type for a request (or response)
  function content_type( req, c_type ) {
    req.headers.content_type = c_type;
  }

  // return true if the request (or response) is an actual response
  function is_response( req ) {
    return req.keyExists( "status" ) &&
      req.keyExists( "body" );
  }

  // return the given html as the response
  function response( html ) {
    return {
      status : 200,
      headers : { },
      body : html
    };
  }

  // CFML-specific

  // return the given template (path) as the response
  // note that request is required here to make it available in the template
  function file( req, path ) {
    var output = "";
    savecontent variable="output" {
      include path;
    }
    return response( output );
  }

}
