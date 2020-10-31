import 'package:chat_mobile/screens/sign_in_screen.dart';

import 'widgets/chat_component.dart';
import 'package:flutter/material.dart';

import 'screens/chat_list.dart';
import 'screens/create_chat.dart';
import 'globals.dart' as globals;
import 'screens/login.dart';

void main() => runApp(SimpleChatApp());

class SimpleChatApp extends StatefulWidget {
  final ChatComponent _chatComponent = ChatComponent(globals.webSocketAddress);

  @override
  _SimpleChatAppState createState() => _SimpleChatAppState();
}

class _SimpleChatAppState extends State<SimpleChatApp> {
  @override
  void initState() {
    super.initState();
    widget._chatComponent.connect();
  }

  @override
  void dispose() {
    widget._chatComponent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatComponentWidget(
      widget._chatComponent,
      MaterialApp(
        title: 'Simple Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          ChatListPage.routeName: (ctx) => ChatListPage(
            title: 'Chat list',
            chatComponent: widget._chatComponent,
          ),
          CreateChatPage.routeName: (ctx) => CreateChatPage(title: 'Create Chat'),
        },
      ),
    );
  }
}
