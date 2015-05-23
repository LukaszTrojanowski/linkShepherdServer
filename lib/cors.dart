library linkShepherdServer.cors;

import 'headers.dart';

import 'package:shelf/shelf.dart' as shelf;

shelf.Middleware addCORSHeaders = shelf.createMiddleware(requestHandler: _options, responseHandler: _cors);

shelf.Response _options(shelf.Request request) => (request.method == 'OPTIONS') ?
    new shelf.Response.ok(null, headers: CORSHeader) : null;
 
shelf.Response _cors(shelf.Response response) => response.change(headers: CORSHeader);