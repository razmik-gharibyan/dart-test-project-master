import 'package:chat_mobile/helpers/chat_helper.dart';
import 'package:chat_mobile/providers/chat_provider.dart';
import 'package:chat_mobile/screens/account_screen.dart';
import 'package:chat_mobile/screens/main_screen.dart';
import 'package:chat_mobile/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';

import 'widgets/chat_component.dart';
import 'package:flutter/material.dart';

import 'globals.dart' as globals;
import 'screens/login.dart';

void main() => runApp(SimpleChatApp());

class SimpleChatApp extends StatefulWidget {
  final ChatComponent _chatComponent = ChatComponent(globals.webSocketAddress);
  final ChatHelper _chatHelper = ChatHelper();

  @override
  _SimpleChatAppState createState() => _SimpleChatAppState();
}

class _SimpleChatAppState extends State<SimpleChatApp> {
  @override
  void initState() {
    super.initState();
    widget._chatComponent.connect();
    widget._chatHelper.chatComponent  = widget._chatComponent;
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
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: ChatProvider()),
          ],
          child: MaterialApp(
            title: 'Simple Chat',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LoginPage(),
            routes: {
              LoginPage.routeName: (ctx) => LoginPage(),
              SignUpScreen.routeName: (ctx) => SignUpScreen(),
              MainScreen.routeName: (ctx) => MainScreen(),
              AccountScreen.routeName: (ctx) => AccountScreen(),
            },
          ),
        ),
    );
  }
}
