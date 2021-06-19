import 'package:flutter/material.dart';
import 'package:henscrop/services/auth.dart';
import 'package:henscrop/models/user.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(16.0), child: Center(
        child: const LinearProgressIndicator(),
      ),),
    );
  }

  void _loadUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    _userId = (preferences.getString('user') ?? "");

    if (_userId == "") {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
    } else {
      var result = await getUser(_userId);
      print(result);
      if (result['success']) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', ModalRoute.withName('/home'),
            arguments: (result['data']['id']));
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', ModalRoute.withName('/login'));
      }
    }
  }
}
