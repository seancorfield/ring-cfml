component {
  function is_response( req ) {
    return req.keyExists( "status" ) &&
      req.keyExists( "body" );
  }
  function wrap_params( handler ) {
    return function( req ) {
      var params = { };
      params.append( url );
      params.append( form );
      req.params = params;
      return handler( req );
    };
  }
  function response( req, html ) {
    req.append({
      status : 200,
      headers : [ ],
      body : html
    });
    return req;
  }
  function file( req, path ) {
    var output = "";
    savecontent variable="output" {
      include path;
    }
    return response( req, output );
  }
  function default( req ) {
    return req;
  }
  function onRequestStart( target ) {
    request.append( cgi );
    request.append({
      uri : cgi.path_info,
      headers : getHTTPRequestData().headers
    });
    request.append( handler( request ) );
  }
  function onRequest( target ) {
    if ( !is_response( request ) ) {
      var output = "";
      savecontent variable="output" {
        include target;
      }
      request.headers = {
        "Content-Type" : "text/html; charset=utf-8"
      };
      request.body = output;
    }
  }
  function onRequestEnd() {
    if ( !request.keyExists( "status" ) ) request.status = 200;
    if ( !request.keyExists( "headers" ) ) request.headers = { };
    if ( !request.keyExists( "body" ) ) request.body = "";
    getPageContext().getResponse().setStatus( request.status );
    for ( var h in request.headers ) {
      getPageContext().getResponse().setHeader( h, request.headers[ h ] );
    }
    writeOutput( request.body );
  }
  handler = default;
}
