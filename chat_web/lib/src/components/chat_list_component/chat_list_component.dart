import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_web/components.dart';
import 'package:chat_web/routes.dart';
import 'package:chat_web/services.dart';

@Component(
    selector: 'chat-list',
    templateUrl: 'chat_list_component.html',
    styleUrls: [
      'chat_list_component.css'
    ],
    directives: [
      coreDirectives,
      MaterialListComponent,
      MaterialListItemComponent,
      MaterialButtonComponent,
      MaterialFabComponent,
      MaterialIconComponent,
      MaterialDialogComponent,
      ModalComponent,
      UsersListComponent
    ],
    providers: [
      overlayBindings,
      ClassProvider(ChatsClient)
    ])
class ChatListComponent implements OnInit {
  Session session;
  ChatsClient chatsClient;
  Router router;

  List<Chat> chats = [];
  bool showCreateChatDialog = false;

  @ViewChild(UsersListComponent)
  UsersListComponent usersList;

  ChatListComponent(this.session, this.chatsClient, this.router);

  String getChatMembers(ChatId chatId) => chats
      .firstWhere((chat) => chat.id == chatId)
      .members
      .map((user) => user.name)
      .join(', ');

  void selectChat(ChatId chatId) {
    router.navigate(RoutePaths.chat.toUrl(parameters: {'chatId': chatId.json}));
  }

  void createChat() async {
    try {
      final newChat = await chatsClient.create(Chat(
          members: usersList.selectedUsers.selectedValues.toList()
            ..add(session.currentUser)));
      chats.add(newChat);
      selectChat(newChat.id);
    } on HttpException catch (e) {
      print('Chat creation failed');
      print(e);
    }
  }

  @override
  ngOnInit() async {
    try {
      chats = await chatsClient.read({});
    } on HttpException catch (e) {
      print('Getting chat list failed');
      print(e);
    }
  }
}
