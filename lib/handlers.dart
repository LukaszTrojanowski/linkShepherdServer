library linkShepheardServer.handlers;

import 'databaseUtility.dart';
//import 'user.dart';

import 'package:shelf_exception_response/exception.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_path/shelf_path.dart';


shelf.Response handleAnonymousGetRequest(shelf.Request request) {
  print('got anonymous get reqest');
  return new shelf.Response.ok('got anonymous get request');
}

shelf.Response handleAnonymousPostRequest(shelf.Request request) {
  print('got anonymous post request');
  return new shelf.Response.ok('got anonymous post request');
}

shelf.Response handleNewest(shelf.Request request){
  print('got request for newest');
  DatabaseUtility dbUtil = new DatabaseUtility('postgres', 'kewoziwa', 'linkShepherdDB');
  return new shelf.Response.ok('bla bla this is it'); //dbUtil.getPosts(10, 10, r"posted_at").toString()
   //   .catchError((err) =>print('Error in handleNewest: $err')));//.then((posts) {
  //  for (var post in posts) {
  //    print(post.posted_at);
  //  }
  //});
  //return new shelf.Response.ok('i hear you. you want new stuff');
}