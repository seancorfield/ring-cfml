<h2>An Introduction</h2>
<p>This example for Ring uses the <tt>Application.cfc</tt> at the root of the
  repository and the <tt>ring.util.response/uri_file()</tt> handler for displaying templates
  based on <tt>req.uri</tt>.</p>
<p>Click on the linked comments to learn more:</p>
<cfscript>
  // pull in a source file, add line numbers, change any //@page comment into
  // a link to that page
  source = fileRead( expandPath( "/Application.cfc" ) );
  nl = chr( 10 );
  lines = listToArray( source, nl, true );
  writeOutput( "<pre>" );
  line_num = 1;
  for ( line in lines ) {
    writeOutput(
      numberFormat( line_num++, "__9" ) & ": " &
      reReplace( line, "//@([a-z]+) (.*)", "// <a href='index.cfm/introduction/\1'>\2</a>" ) &
      nl
    );
  }
  writeOutput( "</pre>" );
</cfscript>
<p>There are also a number of <a href="/examples">"toy" examples</a> that you can look
  at to see different features in action. <em>[That link requires directory browsing enabled
  on your web server -- which is the case if you're using
  <a href="https://www.ortussolutions.com/products/commandbox">CommandBox</a>
  to run these examples.]</em></p>
