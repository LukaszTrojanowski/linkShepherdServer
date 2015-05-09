library linkShepheardServer.handlers;

import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpHeaders;

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