library linkShepheardServer.routes;

import 'handlers.dart' as handler;

import 'package:shelf_route/shelf_route.dart';
import 'package:shelf_auth/shelf_auth.dart' as sAuth;


final sessionHandler = new sAuth.JwtSessionHandler('boo', 'foo', null);

Router routes = new Router()
                      ..get('/anonymous', handler.handleAnonymousGetRequest)
                      ..post('/anonymous', handler.handleAnonymousPostRequest);
                      //..post('/login', handler.handleLoginRequest);

