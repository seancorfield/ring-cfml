component extends=ring.core {
  this.sessionmanagement = true;

  // (require '[ring.middleware :as mw])
  mw = new ring.middleware();
  handler = mw.wrap_session(
    function( req ) {
      req.session.counter++;
      return req;
    }
  );

  function onSessionStart() {
    session.counter = 0;
  }

}
