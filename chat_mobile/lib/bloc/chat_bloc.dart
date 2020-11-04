import 'dart:async';
import 'dart:collection';

import 'package:chat_mobile/bloc/bloc.dart';
import 'package:chat_mobile/helpers/chat_helper.dart';
import 'package:chat_models/chat_models.dart';

class ChatBloc implements Bloc {

  var _chatComponent = ChatHelper().chatComponent;
  Set<ChatId> _unreadChats = HashSet<ChatId>();
  StreamSubscription<Set<ChatId>> _unreadMessagesSubscription;
  final _streamController = StreamController<Set<ChatId>>();

  Stream<Set<ChatId>> get unreadMessages => _streamController.stream;

  void subscribeForMessages() {
    _unreadMessagesSubscription = _chatComponent
        .subscribeUnreadMessagesNotification((unreadChatIds) {
      _unreadChats.clear();
      _unreadChats.addAll(unreadChatIds);
      _streamController.sink.add(_unreadChats);
    });
  }

  @override
  void dispose() {
   _unreadMessagesSubscription.cancel();
   _streamController.close();
  }

}