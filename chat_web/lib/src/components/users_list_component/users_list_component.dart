import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_web/services.dart';

@Component(
    selector: 'users-list',
    templateUrl: 'users_list_component.html',
    styleUrls: [
      'users_list_component.css'
    ],
    directives: [
      coreDirectives,
      MaterialListComponent,
      MaterialSelectItemComponent
    ],
    providers: [
      ClassProvider(UsersClient)
    ])
class UsersListComponent implements OnInit {
  UsersClient _usersClient;
  Session _session;

  List<User> users = [];
  SelectionModel<User> selectedUsers = SelectionModel.multi();
  UsersListComponent(this._usersClient, this._session);

  toggleSelection(User user) {
    if (selectedUsers.isSelected(user)) {
      selectedUsers.deselect(user);
    } else {
      selectedUsers.select(user);
    }
  }

  @override
  ngOnInit() async {
    try {
      List<User> found = await _usersClient.read({});
      users = found..removeWhere((user) => user.id == _session.currentUser.id);
    } on HttpException catch (e) {
      print('Getting users list failed');
      print(e);
    }
  }
}
