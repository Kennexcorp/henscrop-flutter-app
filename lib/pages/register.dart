import 'package:flutter/material.dart';
import 'package:henscrop/models/user.dart';
import 'package:henscrop/services/auth.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _cPasswordController = TextEditingController();

  bool _isLoading = false;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:  Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Field is required";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
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
                  height: 5,
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
                  height: 5,
                ),
                TextFormField(
                  controller: _cPasswordController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Field is required";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _register();
                        setState(() {
                          _isLoading = true;
                        });
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                _isLoading ? const LinearProgressIndicator() : Text(_error, style: TextStyle(color: Colors.red),),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void _register() async {
    final data = await register(
        cPassword: _cPasswordController.text,
        dName: 'Tecno CD7',
        email: _emailController.text,
        name: _nameController.text,
        password: _passwordController.text);

    final result = data.data;
    
    if (data.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(
          'token', json.encode(result['data']['token']));
      await preferences.setString('user', json.encode(result['data']['user']['id']));

      Navigator.pushNamedAndRemoveUntil(
          context, '/home', ModalRoute.withName('/home'),
          arguments: result['data']['user']['id']);
    } else {
      print(result['error']);
      setState(() {
        _isLoading = false;
        _error = result['error'];
      });
    }
  }
}
