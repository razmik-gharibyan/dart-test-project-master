import 'dart:async';
import 'package:chat_models/chat_models.dart';
import 'package:rest_api_client/rest_api_client.dart';

class ChatsClient extends ResourceClient<Chat> {
  ChatsClient(ApiClient apiClient) : super('chats', apiClient);

  @override
  Future delete(dynamic obj, {Map<String, String> headers = const {}}) {
    throw (UnsupportedError('Delete is not supported'));
  }

  @override
  Future<Chat> replace(Chat message, {Map<String, String> headers = const {}}) {
    throw (UnsupportedError('Replace is not supported'));
  }

  @override
  Future<Chat> update(Chat message, {Map<String, String> headers = const {}}) {
    throw (UnsupportedError('Update is not supported'));
  }

  @override
  Chat createModel(Map<String, dynamic> json) => Chat.fromJson(json);
}
