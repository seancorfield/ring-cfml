component extends=ring.core {

  // (require '[ring.middleware :as mw])
  mw = new ring.middleware();
  // (require '[ring.util.response :as resp])
  resp = new ring.util.response();

  handler = mw.default_stack( function( req ) {
    // returns the input params as a struct, which will be
    // serialized to JSON by the middleware
    return resp.response( req.params );
  } );

}
