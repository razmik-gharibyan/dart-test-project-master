import 'package:chat_models/chat_models.dart';
import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {

  List<User> _selectedUsers = <User>[];

  List<User> get selectedUsers => this._selectedUsers;
  void setSelectedUsers(List<User> newValue) {
    this._selectedUsers = newValue;
    notifyListeners();
  }

}