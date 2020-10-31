import 'dart:html';

import 'package:angular/angular.dart';
import 'package:chat_api_client/chat_api_client.dart';

@Injectable()
class WebApiClient extends ApiClient {
  WebApiClient()
      : super(Uri.parse('http://localhost:3333'),
            onBeforeRequest: (ApiRequest request) {
          if (window.localStorage.containsKey('authtoken'))
            return request.change(
                headers: {}
                  ..addAll(request.headers)
                  ..addAll(
                      {'authorization': window.localStorage['authtoken']}));
          return request;
        }, onAfterResponse: (ApiResponse response) {
          if (response.headers.containsKey('authorization'))
            window.localStorage['authtoken'] =
                response.headers['authorization'];
          return response;
        });
}
