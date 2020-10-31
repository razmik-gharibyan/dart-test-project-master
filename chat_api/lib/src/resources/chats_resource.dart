import 'dart:async';

import 'package:chat_api/collections.dart';
import 'package:chat_models/chat_models.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:rest_api_server/annotations.dart';
import 'package:rest_api_server/http_exception.dart';
import 'package:rest_api_server/service_registry.dart';

/// Chats resource
@Resource(path: 'chats')
class ChatsResource {
  final ChatsCollection chatsCollection = locateService<ChatsCollection>();

  /// Reads chat objects from database
  @Get()
  Future<List<Chat>> read(Map context) {
    final currentUser = User.fromJson(context['payload']);
    if (currentUser == null) throw (ForbiddenException());
    final query = mongo.where.eq('members', currentUser.id.json);
    return chatsCollection.find(query).toList();
  }

  /// Creates new chat in database
  @Post()
  Future<Chat> create(Map requestBody, Map context) async {
    final currentUser = User.fromJson(context['payload']);
    if (currentUser == null) throw (ForbiddenException());
    final newChat = Chat.fromJson(requestBody);
    if (!newChat.members.any((member) => member.id == currentUser.id))
      throw (BadRequestException(
          {}, 'Current user must be a member of new chat'));
    final query = mongo.where
        .all('members', newChat.members.map((user) => user.id.json).toList());
    final found = await chatsCollection.find(query).toList();
    if (found.length != 0) return found.first;
    return chatsCollection.insert(newChat);
  }
}
