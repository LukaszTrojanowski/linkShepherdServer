library linkShepheardServer.handlers;

import 'dart:convert';
import 'databaseUtility.dart';

import 'headers.dart';
//import 'user.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_auth/shelf_auth.dart';
//import 'package:shelf_exception_handler/shelf_exception_handler.dart';
import 'dart:async';
import 'package:option/option.dart';
import 'package:uuid/uuid.dart';
import 'package:logging/logging.dart';
import 'package:shelf_route/shelf_route.dart';
import 'package:shelf_bind/shelf_bind.dart';



shelf.Response handleAnonymousGetRequest(shelf.Request request) {
  print('got anonymous get reqest');
  return new shelf.Response.ok('got anonymous get request');
}

shelf.Response handleAnonymousPostRequest(shelf.Request request) {
  print('got anonymous post request');
  return new shelf.Response.ok('got anonymous post request');
}

Future<shelf.Response> handleNewest(shelf.Request request) async {
  print('got request for newest');
  DatabaseUtility dbUtil = new DatabaseUtility('postgres', 'kewoziwa', 'linkShepherdDB');
  return await (dbUtil.getPosts(10, 10, r"posted_at")
      .then((posts) => JSON.encode(posts).toString()))
      .then((postsJson) => new shelf.Response.ok(postsJson, headers: CORSHeader))
      .catchError((_) => new shelf.Response.internalServerError( headers: CORSHeader));
}

Future<shelf.Response> handleHot(shelf.Request request) async {
  print('got request for hot');
  DatabaseUtility dbUtil = new DatabaseUtility('postgres', 'kewoziwa', 'linkShepherdDB');
  return await (dbUtil.getPosts(10, 10, r"posted_at")
      .then((posts) => JSON.encode(posts).toString()))
      .then((postsJson) => new shelf.Response.ok(postsJson, headers: CORSHeader))
      .catchError((_) => new shelf.Response.internalServerError( headers: CORSHeader));
}

//code handling sessions and Login
var testLookup = new TestUserLookup();

var sessionHandler = new JwtSessionHandler('super app',new Uuid().v4(),testLookup.lookupByUsernamePassword);

//allow http for testing with curl. Don't use in production
var allowHttp = true;

//authentication middleware for a login handler (e.g. submitted from a form)
var loginMiddleware = authenticate(
  [new UsernamePasswordAuthenticator(testLookup.lookupByUsernamePassword)],
  sessionHandler: sessionHandler,
  allowHttp: allowHttp,
  allowAnonymousAccess: false);

// authentication middleware for routes other than login that require a logged
// in user. Here we are relying
// solely on users with a session established via the /login route but
// could have additional authenticators here.
// We are disabling anonymous access to these routes
var defaultAuthMiddleware = authenticate([],
    sessionHandler: sessionHandler,
    allowHttp: true,
    allowAnonymousAccess: false);

String loggedInUsername(shelf.Request request) => getAuthenticatedContext(request)
  .map((ac) => ac.principal.name)
  .getOrElse(() => 'guest');

Future<shelf.Response> handleLogin(shelf.Request request) async {
  print('got reqeust for login');
  return new shelf.Response.ok("I'm now logged in as ${loggedInUsername(request)}\n");
}

class TestUserLookup {
  Future<Option<Principal>> lookupByUsernamePassword(String username, String password) {
    final validUser = username == 'fred';
    final principalOpt = validUser ? new Some(new Principal(username)) : const None();
    
    return new Future.value(principalOpt);
  }
  
  Future<Option<Principal>> lookupByUsername(String username) {
    final validUser = username == 'fred';
    
    final principalOpt = validUser ? new Some(new Principal(username)) : const None();
    
    return new Future.value(principalOpt);
  }
}

shelf.Response handleFoo(shelf.Request request) => new shelf.Response.ok("Doing foo as ${loggedInUsername(request)}");