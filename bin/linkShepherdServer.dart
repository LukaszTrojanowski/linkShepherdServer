// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import 'package:auctionprojectServer/auctionprojectServer.dart' as auctionprojectServer;
import 'dart:io';
//import 'package:http_server/http_server.dart' show VirtualDirectory; // probably to uncomment
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

import '../lib/routes.dart';
import '../lib/cors.dart';

//import '../lib/databaseUtility.dart'; // remove this two after testing
//import 'dart:convert';
//import '../lib/post.dart';

main() {
//    DatabaseUtility dbUtil = new DatabaseUtility('postgres', 'kewoziwa', 'linkShepherdDB');
    //dbUtil.createUser({'login': 'anonymous', 'password': 'muotGKzenuasXvhyPuocUHxMaShuxsKfAXUvDuxSGmBiIOVXB'});
    //dbUtil.defineTag({'tag': 'testTag', 'description':'This tag is a test tag for testing'});
    //@title, @description, now(), now(), @user, @editor, @upVotes, @downVotes, @flag
    //dbUtil.addPost({'title': 'Sample title', 'description': 'This is a description for a sample post', 'user': 'dartUser', 'editor': 'dartUser', 'links_to': 'http://google.com'});
    //dbUtil.addPost({'title': 'Sample title', 'description': 'This is a description for a sample post', 'user': 'dartUser', 'editor': 'dartUser', 'links_to': 'http://google.com'}, [{'tag':'testTag'}]);
    //dbUtil.addPost({'title': 'Sample title', 'description': 'This is a description for a sample post', 'user': 'dartUser', 'editor': 'dartUser', 'links_to': 'http://google.com'}, [{'tag':'testTag'}, {'tag':'testTag2'}]);
    //dbUtil.getPostsByTags(0, 10, 'posted_at', ['testTag', 'testTag2']).then((posts) {
    //  print(JSON.encode(posts));
    //});
    //initVirDir();
//    dbUtil.getPosts(10, 10, r'posted_at').then((posts){
//      String jsonPosts = JSON.encode(posts);   
//      print(jsonPosts);
//      print(JSON.decode(jsonPosts));
//      Map jsonPost = JSON.decode(jsonPosts)[0];
//      print(jsonPost.runtimeType.toString());
//      print(jsonPost['posted_at']);
//      print(DateTime.parse(jsonPost['last_edited']).runtimeType.toString());
//      Post samplePost = new Post.fromMap(jsonPost);
//      print(samplePost.toHTML());
//      //print(samplePost);
//    });
    runServer();
}

/**
 *  Code to handle Http Requests
 */
runServer() {
  var staticHandler = createStaticHandler(r"C:\Users\Lukasz\dart\linkShepherdClient\web\", defaultDocument: 'linkShepherd.html',serveFilesOutsidePath: true);
  
  shelf.Pipeline pipeline = new shelf.Pipeline()
                                        .addMiddleware(shelf.logRequests())
                                        .addMiddleware(addCORSHeaders);
  
  var handler = pipeline.addHandler(new shelf.Cascade()
                      .add(staticHandler)
                      .add(routes.handler)
                      .handler);
  io.serve(handler, InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
    print('Listening on port 8080');
  }).catchError((error) => print(error));
      
}/* end of code handling Http Requests */

