// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import 'package:auctionprojectServer/auctionprojectServer.dart' as auctionprojectServer;
import 'dart:io';
import 'package:http_server/http_server.dart' show VirtualDirectory; // probably to uncomment
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

import '../lib/databaseUtility.dart';
import '../lib/routes.dart';

VirtualDirectory virDir;

main() {
    DatabaseUtility dbUtil = new DatabaseUtility('postgres', 'kewoziwa', 'linkShepherdDB');
    dbUtil.createUser({'login': 'dartUser', 'password': 'passMePlease'});
    //initVirDir();
    runServer();
}

/**
 *  Code to handle Http Requests
 */
runServer() {
  var staticHandler = createStaticHandler(r"C:\Users\Lukasz\dart\auctionProject\web", defaultDocument: 'auctionproject.html');
  /*final shelf.Handler handler = const shelf.Pipeline()
                                        .addMiddleware(shelf.logRequests())
                                        .addHandler(routes.handler);
  */
  var handler = new Cascade()
                      .add(staticHandler)
                      .add(routes.handler)
                      .handler;
  io.serve(handler, InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
    print('Listening on port 8080');
  }).catchError((error) => print(error));
      
}

/*shelf.Response handleAnyRequest(shelf.Request request) {
  switch (request.method) {
    case 'GET':
      handleGetRequest(request);
      break;
    case 'POST':
      handlePostRequest(request);
      break;
    default: defaultRequestHandler(request);
  }
}

handleGetRequest(shelf.Request req) {
  print('got GET request');
  virDir.serveRequest(req);
}

handlePostRequest(HttpRequest req) {
  print('got POST request');
  
}

// place for other request types

defaultRequestHandler(HttpRequest req){
  print('some unhandled request!!!\n');
} */

/* end of code handling Http Requests */