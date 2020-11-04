import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/bloc/chat_bloc.dart';
import 'package:chat_mobile/helpers/chat_helper.dart';
import 'package:chat_mobile/providers/bloc_provider.dart';
import 'package:chat_mobile/providers/chat_provider.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_mobile/api/api_client.dart';
import 'package:chat_mobile/widgets/chat_component.dart';
import 'package:chat_mobile/screens/chat_content.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {

  ChatListPage({Key key, this.title})
      : super(key: key);
  final String title;

  final ChatComponent _chatComponent = ChatHelper()?.chatComponent;

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  var _chats = <Chat>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
      refreshChats();
  }

  @override
  Widget build(BuildContext context) {
    var _chatProvider = Provider.of<ChatProvider>(context, listen: true);
    return _isLoading ?
    Center(child: Platform.isAndroid ?  CircularProgressIndicator() : CupertinoActivityIndicator())  : Container(
      child: RefreshIndicator(
        onRefresh: _updateData,
        child: Column(
            children: <Widget>[
              _chats.isEmpty ?
              Center(
                child: Text('You do not have chats'),
              ) : StreamBuilder(
                stream: BlocProvider.of<ChatBloc>(context).unreadMessages,
                builder: (c, snapshot) {
                  final unreadChats = snapshot.data;
                  if(unreadChats == null) {
                    return Container();
                  }
                  return Expanded(
                  child: ListView.builder(
                    itemCount: _chats.length,
                    itemBuilder: (ctx, index) => Container(
                      child: ListTile(
                        tileColor: _checkMatchingUsers(_chatProvider.selectedUsers, _chats[index].members) ? Colors.lightBlueAccent : Colors.transparent,
                        leading: unreadChats.contains(_chats[index].id) ? const Icon(Icons.message) : null,
                        title: Text(_chats[index].members.map((user) => user.name).join(", ")),
                        onTap: () {
                          Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (context) {
                                return ChatContentPage(
                                  chat: _chats[index],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )
                  ),
                );}
              ),
            ],
          ),
      ),
    );
  }

  Future _updateData() async {
    refreshChats();
  }

  bool _checkMatchingUsers(List<User> selectedUsers, List<User> chatUsers) {
    bool found = false;
    for(var user in chatUsers) {
      found = selectedUsers.where((e) => e.name == user.name).toList().isNotEmpty;
      if(found) break;
    }
    return found;
  }

  void refreshChats() async {
    try {
      List<Chat> found = await ChatsClient(MobileApiClient()).read({});
      setState(() {
        _chats = found;
        _isLoading = false;
      });
    } on Exception catch (e) {
      print('Failed to get list of chats');
      print(e);
    }
  }
}
