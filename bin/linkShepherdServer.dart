// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import 'package:auctionprojectServer/auctionprojectServer.dart' as auctionprojectServer;
import 'dart:io';
import 'package:http_server/http_server.dart' show VirtualDirectory; // probably to uncomment
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

import '../lib/routes.dart';

VirtualDirectory virDir;

main() {
    //DatabaseUtility dbUtil = new DatabaseUtility('postgres', 'kewoziwa', 'linkShepherdDB');
    //dbUtil.createUser({'login': 'anonymous', 'password': 'muotGKzenuasXvhyPuocUHxMaShuxsKfAXUvDuxSGmBiIOVXB'});
    //dbUtil.defineTag({'tag': 'testTag', 'description':'This tag is a test tag for testing'});
    //@title, @description, now(), now(), @user, @editor, @upVotes, @downVotes, @flag
    //dbUtil.addPost({'title': 'Sample title', 'description': 'This is a description for a sample post', 'user': 'dartUser', 'editor': 'dartUser', 'links_to': 'http://google.com'});
    //dbUtil.addPost({'title': 'Sample title', 'description': 'This is a description for a sample post', 'user': 'dartUser', 'editor': 'dartUser', 'links_to': 'http://google.com'}, [{'tag':'testTag'}]);
    //dbUtil.addPost({'title': 'Sample title', 'description': 'This is a description for a sample post', 'user': 'dartUser', 'editor': 'dartUser', 'links_to': 'http://google.com'}, [{'tag':'testTag'}, {'tag':'testTag2'}]);
    //dbUtil.getPostsByTags(0, 10, 'posted_at', ['testTag', 'testTag2']).then((posts) {
    //  for (var post in posts) {
    //    print(post.tags);
    //  }
    //});
    //initVirDir();
    runServer();
}

/**
 *  Code to handle Http Requests
 */
runServer() {
  var staticHandler = createStaticHandler(r"C:\Users\Lukasz\dart\linkShepherdClient\web\", defaultDocument: 'linkShepherd.html',serveFilesOutsidePath: true);
  var handler = new Cascade()
                      .add(staticHandler)
                      .add(routes.handler)
                      .handler;
  io.serve(handler, InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
    print('Listening on port 8080');
  }).catchError((error) => print(error));
      
}/* end of code handling Http Requests */

