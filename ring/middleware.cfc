component {

  // expose cookie scope in request
  function wrap_cookies( handler ) {
    return function( req ) {
      if ( !req.keyExists( "cookies" ) ) req.cookies = { };
      req.cookies.append( cookie );
      var resp = handler( req );
      if ( resp.keyExists( "cookies" ) ) {
        // for now -- we should probably remove deleted items
        // should also be smarter about options on cookies
        cookie.append( resp.cookies );
      }
      return resp;
    };
  }

  // copy url (query string) and form to params
  function wrap_params( handler ) {
    return function( req ) {
      if ( !req.keyExists( "params" ) ) req.params = { };
      if ( !req.keyExists( "query_params" ) ) {
        req.query_params = { };
        req.query_params.append( url );
      }
      if ( !req.keyExists( "form_params" ) ) {
        req.form_params = { };
        req.form_params.append( form );
      }
      req.params.append( url );
      req.params.append( form );
      return handler( req );
    };
  }

  // expose session scope in request
  function wrap_session( handler ) {
    return function( req ) {
      if ( !req.keyExists( "session" ) ) req.session = { };
      req.session.append( session );
      var resp = handler( req );
      if ( resp.keyExists( "session" ) ) {
        // for now -- we should probably remove deleted items
        session.append( resp.session );
      }
      return resp;
    };
  }

  // decode JSON body to params
  function wrap_json_params( handler ) {
    return function( req ) {
      var body = getHTTPRequestData().content;
      if ( isBinary( body ) ) body = charsetEncode( body, "utf-8" );
      if ( len( body ) ) {
        switch ( listFirst( req.content_type, ";" ) ) {
        case "application/json":
        case "text/json":
          var params = deserializeJSON( body );
          req.json_params = params;
          if ( !req.keyExists( "params" ) ) req.params = { };
          req.params.append( params );
          break;
        case "application/x-www-form-urlencoded":
          var pairs = listToArray( body, "&" );
          var params = { };
          for ( var pair in pairs ) {
            var parts = listToArray( pair, "=", true ); // handle blank values
            params[ parts[ 1 ] ] = urlDecode( parts[ 2 ] );
          }
          req.json_params = params;
          if ( !req.keyExists( "params" ) ) req.params = { };
          req.params.append( params );
          break;
        default:
          // ignore!
          break;
        }
      }
      return handler( req );
    };
  }

  // encode non-string body to JSON
  function wrap_json_response( handler ) {
    return function( req ) {
      var resp = handler( req );
      var r = new ring.util.response();
      if ( r.is_response( resp ) && !isSimpleValue( resp.body ) ) {
        resp.body = serializeJSON( resp.body );
        resp = r.content_type( resp, "application/json; charset=utf-8" );
      }
      return resp;
    };
  }

  // CORS support (OPTIONS, Access Control)
  function wrap_cors( handler ) {
    return function( req ) {
      // TODO!
      return req;
    };
  }

  // handle exceptions gracefully
  function wrap_exception( handler ) {
    return function( req ) {
      try {
        return handler( req );
      } catch ( any e ) {
        var r = new ring.util.response();
        var stdout = createObject( "java", "java.lang.System" ).out;
        stdout.println( "\nException: #e.message#\nDetail: #e.detail#" );
        return r.response( e.message ).status( 400 );
      }
    };
  }

}
