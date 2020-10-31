import 'dart:async';

import 'package:chat_models/chat_models.dart';
import 'package:rest_api_client/rest_api_client.dart';

class UsersClient extends ResourceClient<User> {
  UsersClient(ApiClient apiClient) : super('users', apiClient);

  Future<User> login(String username, String password) async {
    final response = await apiClient.send(ApiRequest(
        method: HttpMethod.post,
        resourcePath: '$resourcePath/login',
        body: {'username': username, 'password': password}));
    print(response.body.runtimeType);
    return processResponse(response);
  }

  @override
  User createModel(Map<String, dynamic> json) {
    print(json);
    return User.fromJson(json);
  }
}
