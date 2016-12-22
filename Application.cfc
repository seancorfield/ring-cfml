component extends=ring.core {

  // (require '[ring.middleware :as mw])
  mw = new ring.middleware();
  // (require '[ring.util.response :as resp])
  resp = new ring.util.response();

  handler = mw.default_stack( function( req ) {
    // set the default page
    if ( !len( req.uri ) ) req.uri = "/introduction/home";
    return resp.uri_file( req );
  } );

}
