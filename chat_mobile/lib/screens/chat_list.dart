import 'dart:async';
import 'dart:collection';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/helpers/chat_helper.dart';
import 'package:chat_mobile/providers/chat_provider.dart';
import 'package:chat_mobile/screens/create_chat.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';

import 'package:chat_mobile/api/api_client.dart';
import 'package:chat_mobile/widgets/chat_component.dart';
import 'package:chat_mobile/widgets/chat_content.dart';
import 'package:chat_mobile/widgets/common_ui.dart';
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
  Set<ChatId> _unreadChats = HashSet<ChatId>();
  StreamSubscription<Set<ChatId>> _unreadMessagesSubscription;

  @override
  void initState() {
    super.initState();
    refreshChats();
    _unreadMessagesSubscription = widget._chatComponent
        .subscribeUnreadMessagesNotification((unreadChatIds) {
      setState(() {
        _unreadChats.clear();
        _unreadChats.addAll(unreadChatIds);
      });
    });
  }

  @override
  void dispose() {
    _unreadMessagesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _chatProvider = Provider.of<ChatProvider>(context, listen: true);
    return Container(
      child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (ctx, index) => Container(
                  child: ListTile(
                    tileColor: _checkMatchingUsers(_chatProvider.selectedUsers, _chats[index].members) ? Colors.lightBlueAccent : Colors.transparent,
                    leading: _unreadChats.contains(_chats[index].id) ? const Icon(Icons.message) : null,
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
            ),
          ],
        ),
    );
  }

  bool _checkMatchingUsers(List<User> selectedUsers, List<User> chatUsers) {
    bool found = false;
    for(var user in chatUsers) {
      return selectedUsers.map((e) => e.id == user.id).toList().isNotEmpty;
    }
    return found;
  }

  void refreshChats() async {
    try {
      List<Chat> found = await ChatsClient(MobileApiClient()).read({});
      setState(() {
        _chats = found;
      });
    } on Exception catch (e) {
      print('Failed to get list of chats');
      print(e);
    }
  }
}
