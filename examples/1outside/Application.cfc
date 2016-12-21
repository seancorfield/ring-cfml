component {

  // (require '[ring.core :as ring])
  ring = new ring.core();
  function onRequestStart( target ) {
    return ring.onRequestStart( target );
  }
  function onRequest( target ) {
    return ring.onRequest( target );
  }
  function onRequestEnd() {
    return ring.onRequestEnd();
  }

}
