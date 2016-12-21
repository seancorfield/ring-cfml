component {
  // (require '[ring.util.response :as resp])
  resp = new util.response();

  // prepare Ring request & invoke handler
  function onRequestStart( target ) {
    request.append( cgi );
    request.append({
      uri : cgi.path_info,
      headers : { }
    });
    var headers = getHTTPRequestData().headers;
    for ( var h in headers ) {
      // normalize to CFML variables
      request.headers[ replace( h, "-", "_", "all" ) ] = headers[ h ];
    }
    request.append( handler( request ) );
  }

  // if no response from handler, default to loading CFML page
  function onRequest( target ) {
    if ( !resp.is_response( request ) ) {
      var req = request;
      savecontent variable="request.body" {
        include target;
      }
      resp.content_type( request, "text/html; charset=utf-8" );
    }
  }

  // render response to client
  function onRequestEnd() {
    // default status, headers, body
    if ( !request.keyExists( "status" ) ) request.status = 200;
    if ( !request.keyExists( "headers" ) ) request.headers = { };
    if ( !request.keyExists( "body" ) ) request.body = "";

    getPageContext().getResponse().setStatus( request.status );
    for ( var h in request.headers ) {
      getPageContext().getResponse().setHeader(
        // normalize back to proper header names
        replace( h, "_", "-", "all" ),
        request.headers[ h ]
      );
    }
    writeOutput( request.body );
  }

  // set default handler to "do nothing"
  handler = function( req ) { return req; };
}
