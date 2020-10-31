import 'dart:async';

import 'package:chat_models/chat_models.dart';
import 'package:rest_api_client/rest_api_client.dart';

class MessagesClient extends ResourceClient<Message> {
  MessagesClient(ApiClient apiClient) : super('chats', apiClient);

  @override
  Future<Message> create(Message message,
      {Map<String, String> headers = const {}}) async {
    final response = await apiClient.send(ApiRequest(
        method: HttpMethod.post,
        resourcePath: '$resourcePath/${message.chat.json}/messages',
        headers: headers,
        body: message.json));
    return processResponse(response);
  }

  @override
  Future<List<Message>> read(chatId,
      {Map<String, String> headers = const {}}) async {
    final response = await apiClient.send(ApiRequest(
        method: HttpMethod.get,
        resourcePath: '$resourcePath/${chatId.json}/messages',
        headers: headers));
    return processResponse(response);
  }

  @override
  Future delete(dynamic obj, {Map<String, String> headers = const {}}) {
    throw (UnsupportedError('Delete is not supported'));
  }

  @override
  Future<Message> replace(Message message,
      {Map<String, String> headers = const {}}) {
    throw (UnsupportedError('Replace is not supported'));
  }

  @override
  Future<Message> update(Message message,
      {Map<String, String> headers = const {}}) {
    throw (UnsupportedError('Update is not supported'));
  }

  @override
  Message createModel(Map<String, dynamic> json) => Message.fromJson(json);
}
