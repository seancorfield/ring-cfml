<html>
<head>
</head>
<body>
  <h1>Ring for CFML</h1>
  <cfoutput>#req.body#</cfoutput>
  <p>[ <a href="/index.cfm">home</a>
    <cfscript>
      for ( page in [
        "request", "response", "handler", "middleware", "flow",
        ["main", "primary handler"], ["require", "ring components"],
        ["uri", "path info"]
      ]) {
        if ( isSimpleValue( page ) ) {
          writeOutput( '| <a href="/index.cfm/introduction/#page#">#page#</a> ' );
        } else {
          writeOutput( '| <a href="/index.cfm/introduction/#page[1]#">#page[2]#</a> ' );
        }
      }
    </cfscript>
    ]
  </p>
  <p>
    <cfoutput>
      Running on #server.coldfusion.productname#
      <cfif server.keyExists( "lucee" )>
        #server.lucee.version#.
      <cfelse>
        #server.coldfusion.productversion#.
      </cfif>
    </cfoutput>
  </p>
</html>
