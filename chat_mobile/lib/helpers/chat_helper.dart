import 'package:chat_mobile/widgets/chat_component.dart';

class ChatHelper {

  static final ChatHelper _chatHelper = ChatHelper._privateConstructor();
  factory ChatHelper() {
    return _chatHelper;
  }

  ChatHelper._privateConstructor();

  ChatComponent chatComponent;

}