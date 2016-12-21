component extends=ring {
  handler = wrap_params(
    function( req ) {
      return response( req, "file( req, ""two.cfm"" );" );
    }
  );
}
