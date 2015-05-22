library linkShepheardServer.routes;

import 'handlers.dart' as handler;

import 'package:shelf_route/shelf_route.dart';

//final sessionHandler = new sAuth.JwtSessionHandler('boo', 'foo', null);

Router routes = new Router()
                      ..get('/newest', handler.handleNewest)
                      ..get('/hot', handler.handleHot)
                      //..get('/anonymous', handler.handleAnonymousGetRequest)
                      //..post('/anonymous', handler.handleAnonymousPostRequest);
                      ..post('/login', handler.handleLogin, middleware: handler.loginMiddleware)
                      ..child('/authenticated', middleware: handler.defaultAuthMiddleware)
                        ..get('/newest', handler.handleNewest)
                        ..get('/foo', handler.handleFoo);
