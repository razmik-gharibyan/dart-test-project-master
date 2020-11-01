import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/api/api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  List<User> _users = <User>[];

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) => Container(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlueAccent,
              child: Text(
                _users[index].firstName == null || _users[index].lastName == null ? '' :
                '${_users[index].firstName.substring(0)}${_users[index].lastName.substring(0)}',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black87,
                ),
              ),
            ),
            title: Text(_users[index].name),
            subtitle: Text(_users[index].email ?? ''),
            onTap: () {

            },
          ),
        ),
        itemCount: _users.length,
      ),
    );
  }

  void _getUserData() async {
    try {
      final List<User> result = await UsersClient(MobileApiClient()).read({});
      setState(() {
        _users = result;
      });
    } on Exception catch (e) {
      print('Failed to get list of users');
      print(e);
    }
  }
}
