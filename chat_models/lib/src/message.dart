import 'package:data_model/data_model.dart';

import 'chat.dart';
import 'user.dart';

class Message implements Model<MessageId> {
  MessageId id;
  ChatId chat;
  User author;
  String text;
  final DateTime createdAt;
  Message({this.id, this.chat, this.author, this.text, this.createdAt});
  factory Message.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Message(
        id: MessageId(json['id']),
        chat: ChatId(json['chat']),
        author: User.fromJson(json['author']),
        text: json['text'],
        createdAt: json['createdAt'] is DateTime
            ? json['createdAt'].toLocal()
            : DateTime.parse(json['createdAt']).toLocal());
  }

  Map<String, dynamic> get json => {
        'id': id?.json,
        'chat': chat?.json,
        'author': author?.json,
        'text': text,
        'createdAt': createdAt.toUtc()
      };
}

class MessageId extends ObjectId {
  MessageId._(id) : super(id);
  factory MessageId(id) {
    if (id == null) return null;
    return MessageId._(id);
  }
}
