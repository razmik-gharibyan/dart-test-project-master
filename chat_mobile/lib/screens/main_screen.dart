import 'package:chat_mobile/screens/chat_list.dart';
import 'package:flutter/material.dart';

class CustomTab {
  final String title;
  final IconData icon;
  final Widget tab;
  const CustomTab({this.title, this.icon, this.tab});
}

const List<CustomTab> customTabList = <CustomTab>[
  CustomTab(title: 'Users', icon: Icons.group),
  CustomTab(title: 'Chats', icon: Icons.chat_outlined)
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
        child: Scaffold(
          appBar: AppBar(
            title: Text('Chat Application'),
            bottom: TabBar(
              tabs: customTabList.map<Widget>((CustomTab tab) {
                return Tab(
                  text: tab.title,
                  icon: Icon(tab.icon),
                );
              })
            ),
          ),
          body: TabBarView(
            children: [

            ],
          ),
        )
    );
  }
}
