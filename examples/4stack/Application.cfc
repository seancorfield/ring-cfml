component extends=ring.core {

  // (require '[ring.middleware :as mw])
  mw = new ring.middleware();
  // (require '[ring.util.response :as resp])
  resp = new ring.util.response();

  handler = mw.default_stack( function( req ) {
    // returns the input params as a struct, which will be
    // serialized to JSON by the middleware
    // if no params given, add some explanation:
    if ( !req.params.count() ) {
      req.params.append({
        "serializes" : "query string parameters to JSON",
        "add_some" : "URL arguments to try this out!",
        "automatic" : "serialization via wrap_json_response middleware"
      });
    }
    return resp.response( req.params );
  } );

}
