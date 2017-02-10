"use strict";
(function(window) {
   var node = document.getElementById('view');
   var app = Elm.Main.embed(node);

   // receive something from Elm
   app.ports.toJs.subscribe(function (str) {
      console.log("got from Elm", str);
      // send something back to Elm
      var uppercase = str.toUpperCase() + " undefined is not a function" ;
      app.ports.toElm.send(uppercase);
   });

}(window));
