component extends=ring.core {

  // (require '[ring.middleware :as mw])
  mw = new ring.middleware();
  // (require '[ring.util.response :as resp])
  resp = new ring.util.response();

  function layout_middleware( handler ) {
    return function( req ) {
      var r = new ring.util.response();
      return r.file( handler( req ), "/introduction/layout.cfm" );
    };
  }

  function default_page_middleware( handler ) {
    return function( req ) {
      if ( !len( req.uri ) ) req.uri = "/introduction/home";
      return handler( req );
    };
  }

  handler = mw.stack(
    resp.uri_file, [
      layout_middleware,
      default_page_middleware,
      mw.default_stack
    ]
  );

}
