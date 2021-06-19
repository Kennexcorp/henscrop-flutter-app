import 'package:flutter/material.dart';
import 'package:henscrop/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuList extends StatefulWidget {
  MenuList({Key key}) : super(key: key);

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  static int _selectedDestination = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          selected: _selectedDestination == 0,
          onTap: () {
            selectDestination(0);
            // Navigator.pop(context);
            Navigator.pushNamed(context, '/home');
          },
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text('Photos'),
          selected: _selectedDestination == 1,
          onTap: () {
            selectDestination(1);
            Navigator.pushNamed(context, '/photos');
          },
        ),
        ListTile(
          leading: Icon(Icons.file_copy_sharp),
          title: Text('Documents'),
          selected: _selectedDestination == 2,
          onTap: () {
            selectDestination(2);
            Navigator.pushNamed(context, '/documents');
          },
        ),
        ListTile(
          leading: Icon(Icons.video_collection),
          title: Text('Videos'),
          selected: _selectedDestination == 3,
          onTap: () {
            selectDestination(3);
            Navigator.pushNamed(context, '/videos');
          },
        ),
        ListTile(
          leading: Icon(Icons.power_settings_new),
          title: Text('Logout'),
          onTap: () {
            _logout();
          },
        )
      ],
    );
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });

    Navigator.pop(context);
  }

  void _logout() async {
    final result = await logout();
    print(result);
    if (result['success']) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.remove('user');
      preferences.remove('token');
      Navigator.pushNamed(context, "/login");
    }
  }
}
