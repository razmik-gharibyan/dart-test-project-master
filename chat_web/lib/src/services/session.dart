import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:chat_models/chat_models.dart';

@Injectable()
class Session {
  set currentUser(User user) {
    window.localStorage['currentUser'] = json.encode(user.json);
  }

  User get currentUser {
    if (window.localStorage['currentUser'] == null) return null;
    return User.fromJson(json.decode(window.localStorage['currentUser']));
  }

  set authToken(String token) {
    window.localStorage['authtoken'] = token;
  }

  String get authToken => window.localStorage['authtoken'];

  void clear() {
    window.localStorage.clear();
  }
}
