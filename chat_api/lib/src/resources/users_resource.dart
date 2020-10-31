import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_api/collections.dart';
import 'package:chat_models/chat_models.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:rest_api_server/annotations.dart';
import 'package:rest_api_server/http_exception.dart';
import 'package:rest_api_server/service_registry.dart';
import 'package:shelf/shelf.dart' as shelf;

/// Users resource
@Resource(path: 'users')
class UsersResource {
  UsersCollection usersCollection = locateService<UsersCollection>();

  UsersResource();

  /// Makes login
  @Post(path: 'login')
  Future<shelf.Response> login(Map requestBody) async {
    final username = requestBody['username'];
    final password = requestBody['password'];
    if (username == null || password == null)
      throw (BadRequestException({}, 'username or password not provided'));
    final found = await usersCollection
        .find(mongo.where.eq('name', username).eq('password', password))
        .toList();
    if (found.isEmpty)
      throw UnauthorizedException({}, 'Incorrect username or password');
    final user = found.single;
    return shelf.Response.ok(json.encode(user.json),
        headers: {'Content-Type': ContentType.json.toString()},
        context: {'subject': user.id.json, 'payload': user.json});
  }

  /// Creates new user
  @Post()
  Future<User> create(Map requestBody, Map context) async {
    final newUser = User.fromJson(requestBody);
    final currentUser = User.fromJson(context['payload']);
    if (currentUser != null)
      throw (ForbiddenException({}, 'You are not allowed to create users'));
    final query = mongo.where.eq('name', newUser.name);
    final found = await usersCollection.find(query).toList();
    if (found.length != 0)
      throw (BadRequestException({}, 'User already exists'));
    return usersCollection.insert(newUser);
  }

  /// Updates user
  @Patch()
  Future<User> update(Map requestBody, Map context) async {
    final user = User.fromJson(requestBody);
    final currentUser = User.fromJson(context['payload']);
    if (user.id != currentUser.id)
      throw ForbiddenException({}, 'You are not allowed to update this user');
    return usersCollection.update(user);
  }

  /// Reads users from database
  @Get()
  Future<List<User>> read(String name, Map context) {
    final currentUser = User.fromJson(context['payload']);
    if (currentUser == null) throw (ForbiddenException());
    final query = mongo.where;
    if (name != null) {
      query.match('name', name, caseInsensitive: true);
    }
    return usersCollection.find(query).toList();
  }
}
