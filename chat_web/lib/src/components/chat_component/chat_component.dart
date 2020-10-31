import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_web/routes.dart';
import 'package:chat_web/services.dart';
import 'package:web_socket_channel/html.dart';

@Component(
  selector: 'chat',
  templateUrl: 'chat_component.html',
  styleUrls: [
    'chat_component.css',
  ],
  directives: [
    coreDirectives,
    materialInputDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
  ],
  pipes: [
    DatePipe,
  ],
  providers: [
    materialProviders,
    ClassProvider(
      MessagesClient,
    )
  ],
)
class ChatComponent implements OnActivate, OnDeactivate {
  MessagesClient messagesClient;
  Router router;
  Session session;
  ChatId chatId;
  HtmlWebSocketChannel webSocketChannel;
  List<Message> messages;
  String newMessageText = '';

  ChatComponent(this.messagesClient, this.router, this.session);

  send() async {
    final newMessage = Message(
        chat: chatId,
        author: session.currentUser,
        text: newMessageText,
        createdAt: DateTime.now());
    try {
      final createdMessage = await messagesClient.create(newMessage);
      messages.add(createdMessage);
    } on HttpException catch (e) {
      print('Sending message failed');
      print(e);
    }

    newMessageText = '';
  }

  toChatList() {
    router.navigate(RoutePaths.chats.toUrl());
  }

  @override
  onActivate(_, RouterState current) async {
    chatId = ChatId(current.parameters['chatId']);
    messages = await messagesClient.read(chatId);
    webSocketChannel = HtmlWebSocketChannel.connect('ws://localhost:3333/ws');
    webSocketChannel.stream.listen((data) {
      final recievedMessage = Message.fromJson(json.decode(data));
      if (recievedMessage.chat == chatId &&
          recievedMessage.author.id != session.currentUser.id) {
        messages.add(recievedMessage);
      }
    });
  }

  @override
  onDeactivate(RouterState current, _) {
    webSocketChannel.sink.close();
  }
}
