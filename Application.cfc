component extends=ring {
  handler = wrap_params(
    function( req ) {
      return file( req, "two.cfm" );
    }
  );
}
