import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/api/api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';

import 'package:chat_mobile/globals.dart' as globals;

import 'chat_component.dart';
import 'chat_content.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  List<_SelectableUser> _users = <_SelectableUser>[];

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ListView.builder(
            itemBuilder: (ctx, index) => Container(
              color: _users[index].isSelected ? Colors.blueGrey : Colors.transparent,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.lightBlueAccent,
                  child: Text(
                    _users[index].user.firstName == null || _users[index].user.lastName == null ? 'AA' :
                    '${_users[index].user.firstName.substring(0)}${_users[index].user.lastName.substring(0)}',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black87,
                    ),
                  ),
                ),
                title: Text(_users[index].user.name),
                subtitle: Text(_users[index].user.email ?? ''),
                onTap: () {
                  setState(() {
                    _users[index].isSelected = !_users[index].isSelected;
                  });
                },
              ),
            ),
            itemCount: _users.length,
          ),
          _users.indexWhere((element) => element.isSelected == true) != -1 ? Positioned(
            right: 10.0,
            bottom: 10.0,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _createChat();
              }
            ),
          ) : Container()
        ],
      ),
    );
  }

  void _getUserData() async {
    try {
      final List<User> result = await UsersClient(MobileApiClient()).read({});
      result.removeWhere((user) => user.id == globals.currentUser.id);
      final List<_SelectableUser> userList = result.map((e) => _SelectableUser(user: e)).toList();
      setState(() {
        _users = userList;
      });
    } on Exception catch (e) {
      print('Failed to get list of users');
      print(e);
    }
  }

  void _createChat() async {
    var _checkedCounterparts = _users
        .where((checkableUser) => checkableUser.isSelected == true)
        .map((checkableUser) => checkableUser.user)
        .toList();
    if (_checkedCounterparts.isNotEmpty) {
      try {
        ChatsClient chatsClient = ChatsClient(MobileApiClient());
        Chat createdChat = await chatsClient.create(
            Chat(members: _checkedCounterparts..add(globals.currentUser)));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ChatContentPage(
              chat: createdChat,
              chatComponent: ChatComponentWidget.of(context).chatComponent,
            ),
          ),
          result: true,
        );
      } on Exception catch (e) {
        print('Chat creation failed');
        print(e);
      }
    }
  }

}

class _SelectableUser {
  final User user;
  bool isSelected;

  _SelectableUser({
    this.user,
    this.isSelected = false,
  });
}
