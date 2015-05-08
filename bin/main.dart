// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import 'package:auctionprojectServer/auctionprojectServer.dart' as auctionprojectServer;
import 'dart:io';
import 'package:http_server/http_server.dart' show VirtualDirectory;
import 'database_utility.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

VirtualDirectory virDir;

main() {
    //DatabaseUtility dbUtil = new DatabaseUtility('postgres', 'kewoziwa', 'auctionDB');
    //dbUtil.insertIntoUsers({'login': 'dartUser', 'password': 'passMePlease'});
    initVirDir();
    runServer();
}


/**
 *  Code for virtual directory
 */
initVirDir() {
  virDir = new VirtualDirectory(r"C:\Users\Lukasz\dart\auctionProject\web")   // change to build\web after 2js
    ..allowDirectoryListing = true
    ..directoryHandler = directoryHandler;
}

directoryHandler(dir, request) {
  var indexUri = new Uri.file(dir.path).resolve('auctionproject.html');
  virDir.serveFile(new File(indexUri.toFilePath()), request);
}

/* end of virtual directory related code */


/**
 *  Code to handle Http Requests
 */
runServer() async {
  var server = await HttpServer.bind('127.0.0.1', 8080).catchError((e) => print(e));
  await for (HttpRequest request in server) {
    handleAnyRequest(request);
    //request.response.close();
  }
}

handleAnyRequest(HttpRequest request) {
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

handleGetRequest(HttpRequest req) {
  print('got GET request');
  virDir.serveRequest(req);
}

handlePostRequest(HttpRequest req) {
  print('got POST request');
  
}

// place for other request types

defaultRequestHandler(HttpRequest req){
  print('some unhandled request!!!\n');
}

/* end of code handling Http Requests */