import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
                padding: const EdgeInsets.all(16.0), 
                child: loginOptions(context))
        ),
    );
  }

  Widget loginOptions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Create an account'),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(5.0)),
            )),
            Divider(),
            SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Create an account'),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(5.0)),
            )),
      ],
    );
  }
}

