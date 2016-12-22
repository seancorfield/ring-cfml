# Ring for CFML

This is an early port of [Ring, the Clojure web application library](https://github.com/ring-clojure/ring), to CFML.

Ring is based around the concepts of Handlers, Requests, Responses, and Middleware. It relies heavily on functional composition. You might want to read the [Ring Concepts](https://github.com/ring-clojure/ring/wiki/Concepts) wiki page for background at this point. Ring for CFML is intended to be "as close to Ring (for Clojure) as possible, but no closer" (to paraphrase Andrew Koenig, describing C++ in terms of C). This README outlines the CFML-specific differences, but you should otherwise assume that Ring for CFML behaves just like Ring for Clojure and should be programmed the same way.

## Handlers

The basic building block in Ring is a handler -- a function that accepts a request (structure) and returns a response (structure). See below for definitions of those structures. A handler runs all of the business logic associated with a request and may return a response. For example:

    // Application.cfc
    component extends=ring.core {
        handler = function( req ) {
            resp = new ring.util.response();
            return resp.response( "The time is #now()#." );
        };
    }

This handler returns a simple HTML response with the given text. No `.cfm` page will be executed as part of any request since the handler produces a response.

A more interesting handler would render a CFML template:

    // Application.cfc
    component extends=ring.core {
        handler = function( req ) {
            resp = new ring.util.response();
            return resp.file( req, "/path/to/some.cfm" );
        };
    }

The `req` is passed into the `file()` call and is available as a local variable in `some.cfm`. `ring.util.response/file()` is a CFML extension to Ring, made possible because CFML has its own builtin template engine -- how convenient!

In general, in your `Application.cfc`, you would define `handler` to be a stack of middleware wrapped around a custom handler function -- see below.

*CFML-Specific:* If your handler (and/or middleware) does not return a response (as defined below), Ring for CFML will automatically run the requested template, based on the URL. At the end of processing a request, Ring for CFML will default the HTTP status to `200` (OK), the `Content-Type` to `text/html; charset=utf-8`, and the HTTP body to `""` (a empty string). By contrast, Ring for Clojure has no such default behavior and a request that does not yield a proper response will usually lead to an error.

## Requests

Ring abstracts an HTTP request as a simple structure. Most of the entries in the initial request structure are CGI variables, with the addition of:

* `uri` - equivalent to `CGI.PATH_INFO` in Ring for CFML (and in fact it is an alias for `path_info` in the request),
* `headers` - a structure containing all of the HTTP headers that came in with the request, with their names adjusted for CFML (`-` in the header name becomes `_` in the CFML structure).

This request structure is passed through the middleware and handler stack and those functions made read elements from it or add new elements to it. In general, middleware adds to the request structure before the handler is called, and adds to the response structure returned by the handler.

In particular, the `wrap_params` middleware will add `query_params` (if not already present) containing values from the `query_string`, `form_params` (if not already present) containing values from the HTTP body (POST/PUT/PATCH), and will add all those values to `params` (creating it, if not already present).

*CFML-Specific:* The request structure is mutable and is implemented on top of the `request` scope. This is an acknowledgement that CFML is not a functional programming language and has no immutable data structures. This may lead to slight differences in behavior compared to Ring for Clojure but they should be intuitive and in keeping with the CFML language.

## Responses

Ring also abstracts an HTTP response as a simple structure. Any structure that contains the keys `status`, `body`, and a structure called `headers` is considered an HTTP response. It may include additional keys but it must contain at least those three, otherwise it will be treated as an HTTP request in most contexts within Ring.

Any headers in the response structure are sent back to the client (with `_` in the header name replaced by `-`, reversing the mapping that added `headers` to the request structure above), along with the `status` and `body` values. In addition, middleware may process other fields in the response and use them to send additional data back to the client (such as cookies).

The `ring.util.response` namespace (component) provides convenience functions for creating a simple HTTP response, setting the `Content-Type` header for the response, setting the HTTP status, adding headers and so on.

*CFML-Specific:* `ring.util.response/file()` -- shown above under **Handlers** is a Ring for CFML extension -- and the Ring for Clojure predicate `response?` becomes `is_response()` in Ring for CFML.

## Middleware

Each piece of middleware is a function that accepts a handler and returns a new handler. In general, that new handler will perform call the original handler, performing some work either before or after (or both). The general form of a middleware function is:

    function middleware( handler ) {
      return function( req ) {
        var new_req = preprocess( req );
        if ( proceed( new_req ) ) {
          var resp = handler( new_req );
          return postprocess( resp );
        } else {
          return some_response();
        }
      };
    }

The `ring.middleware` namespace (component) contains some common, basic middleware:

* `wrap_cookies` - adds `req.cookies` as a structure containing all the cookies passed into a request; if `cookies` is added to a response, those cookies will be sent back to the client (along with the original cookies received); implemented on top of the `cookie` scope,
* `wrap_cors` - adds CORS support to the request and response (not yet implemented),
* `wrap_exception` - calls the supplied `handler` inside a `try` / `catch` and, if an exception occurs, logs it to the console and returns a 400 HTTP status with the exception message as the body; *CFML-Specific*,
* `wrap_json_params` - adds `req.json_params` and expands `req.params` with the values obtained by decoding the HTTP request body (as JSON or form-urlencoded data),
* `wrap_json_response` - if the response `body` is not a simple value, serializes it as JSON and sets the `Content-Type` of the response to `"application/json; charset=utf-8"`,
* `wrap_params` - adds `req.query_params`, `req.form_params`, and expands `req.params` with the values from URL scope, form scope, and both scopes respectively,
* `wrap_session` - adds `req.session` as a structure containing the contents of the session scope when a request starts; if `session` is added to a response, those session values will be added back to the session scope before the response is sent to the client.

In addition, two convenience functions are providing for constructing stacks of middleware:

* `default_stack` - wraps the supplied `handler` in a default set of middleware: JSON response & params, params, session, cookies, CORS, exception,
* `stack` - wraps the supplied `handler` in the specified sequence of middleware, in order.

# License & Copyright

Copyright (c) 2016-2017 Sean Corfield.

Distributed under the Apache Source License 2.0.
