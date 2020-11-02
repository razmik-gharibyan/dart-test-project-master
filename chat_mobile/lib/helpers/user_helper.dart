import 'package:chat_models/chat_models.dart';

class UserHelper {

  static final UserHelper _userHelper = UserHelper._privateConstructor();

  factory UserHelper() {
    return _userHelper;
  }

  UserHelper._privateConstructor();

  User _user;

  User get user => this._user;
  void setUser(User newUser) {
    this._user = newUser;
  }

}