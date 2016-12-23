component extends=ring.core { //@extends depending on Ring

  // given a layout path, return middleware that will cause the HTTP response
  // to be wrapped in that file's layout (use #req.body# to embed the response)
  function layout_with( path ) { //@curried parameterized middleware
    return function( handler ) { //@middleware returns a middleware function
      return function( req ) { //@handler returns a handler function
        var r = new ring.util.response(); //@require import ring.util.response namespace
        return r.file( handler( req ), path ); //@chain call the handler, pass the result to another handler
      };
    };
  }

  // middleware that sets the default URI when the home page is requested
  function default_page_middleware( handler ) { //@middleware middleware takes a handler function...
    return function( req ) { //@handler ...and returns a handler function
      if ( !len( req.uri ) ) req.uri = "/introduction/home"; //@uri override the request's URI
      return handler( req ); //@response call the handler and return the response
    };
  }

  //@require import namespaces for use in defining the inline handler
  resp = new ring.util.response();
  mw = new ring.middleware();

  //@main define the handler inline -- it could also be a regular function (of req)
  handler = mw.stack( //@stack wrap a handler in a series of middleware
    resp.uri_file, //@handler the underlying handler that we are wrapping
    [
      layout_with( "/introduction/layout.cfm" ), //@curried add a parameterized layout
      default_page_middleware, //@middleware set the default page
      mw.default_stack //@default_stack apply the standard Ring middleware stack
    ]
    //@flow the req(uest) flows from here (outside) through to the handler (inside)
    // and then the resp(onse) flows back out through each middleware function
  );

}
