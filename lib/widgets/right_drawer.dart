import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:henscrop/services/auth.dart';
import 'package:henscrop/widgets/menu_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Icon(
                  Icons.face,
                  size: 120.0,
                  color: Colors.white54,
                ),
                UserProfile()
              ],
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          MenuList(),
        ],
      ),
    );
  }
}

class UserProfile extends StatefulWidget {
  UserProfile({Key key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name;

  @override
  void initState() {
    super.initState();
    if (name == null) {
      _getUser();
    }
  }

  _getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = json.decode(localStorage.getString('user')).toString();
    var user = await getUser(id);

    print(user);
    if (user != null) {
      setState(() {
        name = user['data']['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return name != null
        ? Text(
            "Welcome $name",
            style: TextStyle(color: Colors.white),
          )
        : Text("Hi there!");
  }
}
