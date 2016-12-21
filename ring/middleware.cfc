component {

  // copy url (query string) and form to params
  function wrap_params( handler ) {
    return function( req ) {
      if ( !req.keyExists( "params" ) ) req.params = { };
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
        var stdout = createObject( "java", "java.lang.System" ).out;
        stdout.println( "session contains " & structKeyList( session ) );
        session.append( resp.session );
      }
      return resp;
    };
  }

}
