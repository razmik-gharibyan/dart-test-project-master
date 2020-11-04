import 'dart:io';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/api/api_client.dart';
import 'package:chat_mobile/providers/chat_provider.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_mobile/globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:chat_mobile/screens/chat_content.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  List<_SelectableUser> _users = <_SelectableUser>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {

    var _chatProvider = Provider.of<ChatProvider>(context,listen: false);

    return _isLoading ?
    Center(child: Platform.isAndroid ?  CircularProgressIndicator() : CupertinoActivityIndicator())  : Container(
      child: RefreshIndicator(
        onRefresh: _updateData,
        child: Stack(
          children: [
            ListView.builder(
              itemBuilder: (ctx, index) => Container(
                color: _users[index].isSelected ? Colors.lightBlueAccent : Colors.transparent,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.yellow,
                    child: Text(
                      _users[index].user.firstName == null || _users[index].user.lastName == null ? 'AA' :
                      '${_users[index].user.firstName[0]}${_users[index].user.lastName[0]}',
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
                    var _selectedCounterParts = _users
                        .where((selectableUser) => selectableUser.isSelected == true)
                        .where((selectableUser) => selectableUser.user.id != globals.currentUser.id)
                        .map((selectableUser) => selectableUser.user)
                        .toList();
                    _chatProvider.setSelectedUsers(_selectedCounterParts);
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
      ),
    );
  }

  Future _updateData() async {
    _getUserData();
  }

  void _getUserData() async {
    try {
      final List<User> result = await UsersClient(MobileApiClient()).read({});
      result.removeWhere((user) => user.id == globals.currentUser.id);
      final List<_SelectableUser> userList = result.map((e) => _SelectableUser(user: e)).toList();
      setState(() {
        _users = userList;
        _isLoading = false;
      });
    } on Exception catch (e) {
      print('Failed to get list of users');
      print(e);
    }
  }

  void _createChat() async {
    var _selectedCounterParts = _users
        .where((selectableUser) => selectableUser.isSelected == true)
        .map((selectableUser) => selectableUser.user)
        .toList();
    if (_selectedCounterParts.isNotEmpty) {
      try {
        ChatsClient chatsClient = ChatsClient(MobileApiClient());
        Chat createdChat = await chatsClient.create(
            Chat(members: _selectedCounterParts..add(globals.currentUser)));
            print(createdChat.members);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ChatContentPage(
              chat: createdChat,
            ),
          ),
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
