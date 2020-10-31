import 'dart:io';

import 'package:chat_api/collections.dart';
import 'package:chat_api/helpers.dart';
// ignore: uri_has_not_been_generated
import 'package:chat_api/routes.g.dart' as generated;
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:rest_api_server/api_server.dart';
import 'package:rest_api_server/auth_middleware.dart';
import 'package:rest_api_server/cors_headers_middleware.dart';
import 'package:rest_api_server/http_exception_middleware.dart';
import 'package:rest_api_server/service_registry.dart';
import 'package:shelf/shelf.dart' as shelf;

main() async {
  final db = mongo.Db('mongodb://localhost:27017/simple_chat');
  await db.open();

  register<ChatsCollection>(ChatsCollection(mongo.DbCollection(db, 'chats')));
  register<MessagesCollection>(
      MessagesCollection(mongo.DbCollection(db, 'messages')));
  register<UsersCollection>(UsersCollection(mongo.DbCollection(db, 'users')));
  register<Jwt>(Jwt(
      securityKey: 'secret key',
      issuer: 'Simple Chat',
      maxAge: Duration(hours: 1)));
  register<WsChannels>(WsChannels());

  final router = Router(generated.routes);

  final loginPaths = {
    'POST': ['/users/login']
  };

  final excludePaths = {
    'POST': [
      ...loginPaths['POST'],
      '/users',
    ],
    'GET': ['/ws'],
  };

  final server = ApiServer(
      address: InternetAddress.anyIPv4,
      port: 3333,
      handler: shelf.Pipeline()
          .addMiddleware(CorsHeadersMiddleware({
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Expose-Headers': 'Authorization, Content-Type',
            'Access-Control-Allow-Headers':
                'Authorization, Origin, X-Requested-With, Content-Type, Accept, Content-Disposition',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE'
          }))
          .addMiddleware(HttpExceptionMiddleware())
          .addMiddleware(AuthMiddleware(
              loginPaths: loginPaths,
              exclude: excludePaths,
              jwt: locateService<Jwt>()))
          .addHandler(router.handler));

  await server.start();
  router.printRoutes();
}
