component {
  /*
    Copyright (c) 2016-2017, Sean Corfield

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
  */

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
