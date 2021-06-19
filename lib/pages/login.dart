import 'dart:convert';
import 'package:henscrop/services/auth.dart';
import 'package:henscrop/models/apiSuccess.dart';
import 'package:henscrop/models/user.dart';
import 'package:henscrop/models/apiError.dart';
import 'package:henscrop/models/apiResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _error = '';

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Field is required";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Field is required";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _login();
                        
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                _isLoading ? const LinearProgressIndicator() : Text(_error, style: TextStyle(color: Colors.red),),

                SizedBox(
                   
                   
                        
                       
                                        height: 25,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Already have an account? Register',
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    final data = await login(_emailController.text, _passwordController.text);
    final result = data.data;

    if (data.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(
          'token', json.encode(result['data']['token']));
      await preferences.setString(
          'user', json.encode(result['data']['user']['id']));
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', ModalRoute.withName('/home'),
          arguments: result['data']['user']['id']);
    } else {
      print(result['error']);
      print('Hello');
      setState(() {
        _isLoading = false;
        _error = result['error'];
      });
    }
  }
}
