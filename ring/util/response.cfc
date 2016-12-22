component {

  // publicly available
  this.redirect_status_codes = {
    "moved_permanently" : 301,
    "found" : 302,
    "see_other" : 303, // e.g., redirect after POST
    // still in RFC status -- use with caution
    "temporary_redirect" : 307,
    "permanent_redirect" : 308
  };

  // return a redirect response
  function redirect( the_url, the_status = "found" ) {
    return {
      status : this.redirect_status_codes.keyExists( the_status ) ?
        this.redirect_status_codes[ the_status ] : the_status,
      headers : { location : the_url },
      body : ""
    };
  }

  // return a 201 Created response
  function created( the_url, the_body = "" ) {
    return {
      status : 201,
      headers : { location : the_url },
      body : the_body
    };
  }

  // return a 404 Not Found response
  function not_found( the_body ) {
    return {
      status : 404,
      headers : { },
      body : the_body
    };
  }

  // return the given body as the response
  function response( the_body ) {
    return {
      status : 200,
      headers : { },
      body : the_body
    };
  }

  // update the status code in a response
  function status( resp, the_status ) {
    resp.status = the_status;
    return resp;
  }

  // add the given header / value to the response
  function header( resp, name, value ) {
    if ( !resp.keyExists( "headers" ) ) resp.headers = { };
    resp.headers[ name ] = value;
    return resp;
  }

  // set the content-type for a response
  function content_type( resp, c_type ) {
    resp.headers.content_type = c_type;
    return resp;
  }

  // return the value of the given header (or "")
  function get_header( resp, name ) {
    return resp.keyExists( "headers" ) &&
      resp.headers.keyExists( name ) ?
      resp.headers[ name ] : "";
  }

  // return true if the request (or response) is an actual response
  function is_response( req ) {
    return isStruct( req ) &&
      req.keyExists( "status" ) &&
      req.keyExists( "headers" ) && isStruct( req.headers ) &&
      req.keyExists( "body" );
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
