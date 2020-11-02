import 'package:chat_mobile/widgets/chat_list.dart';
import 'package:chat_mobile/widgets/common_ui.dart';
import 'package:chat_mobile/widgets/user_list.dart';
import 'package:flutter/material.dart';

class CustomTab {
  final String title;
  final IconData icon;
  final Widget tab;
  const CustomTab({this.title, this.icon, this.tab});
}

List<CustomTab> customTabList = <CustomTab>[
  CustomTab(title: 'Users', icon: Icons.group, tab: UserList()),
  CustomTab(title: 'Chats', icon: Icons.chat_outlined, tab: ChatListPage())
];

class MainScreen extends StatefulWidget {

  static const String routeName = "/main-screen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: customTabList.length,
      child: Scaffold(
            appBar: AppBar(
              title: Text('Chat Application'),
              leading: AccountButton(),
              actions: <Widget>[LogoutButton(),],
              automaticallyImplyLeading: false,
              bottom: TabBar(
                tabs: customTabList.map<Widget>((CustomTab tab) {
                  return Tab(
                    text: tab.title,
                    icon: Icon(tab.icon),
                  );
                }).toList()
              ),
            ),
            body: TabBarView(
              children: customTabList.map<Widget>((CustomTab tab) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: tab.tab,
                );
              }).toList()
            ),
      ),
    );
  }
}
