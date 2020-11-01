import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/screens/main_screen.dart';
import 'package:chat_mobile/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

import 'package:chat_mobile/api/api_client.dart';
import 'package:chat_mobile/globals.dart' as globals;

class LoginPage extends StatefulWidget {

  static const String routeName = "/login-screen";

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginData {
  String login = '';
  String password = '';
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _loginData = new _LoginData();
  final TextEditingController _loginController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  String _validateLogin(String value) {
    if (value.length < 2) {
      // check login rules here
      return 'The Login must be at least 2 characters.';
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 2) {
      // check password rules here
      return 'The Password must be at least 2 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(
      builder: (BuildContext scaffoldContext) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Form(
              key: this._formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login Page',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  TextFormField(
                    controller: _loginController,
                    validator: this._validateLogin,
                    onSaved: (String value) {
                      this._loginData.login = value;
                    },
                    decoration: InputDecoration(
                        hintText: 'Login', labelText: 'Enter your login'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    // Use secure text for passwords.
                    validator: this._validatePassword,
                    onSaved: (String value) {
                      this._loginData.password = value;
                    },
                    decoration: new InputDecoration(
                        hintText: 'Password', labelText: 'Enter your password'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                            child: Text("Login"),
                            onPressed: () {
                              _login(scaffoldContext);
                            }),
                        FlatButton(
                            child: Text("Sign up"),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  _login(BuildContext context) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        UsersClient usersClient = UsersClient(MobileApiClient());
        var user =
            await usersClient.login(_loginData.login, _loginData.password);
        globals.currentUser = user;
        Navigator.of(context).pushReplacementNamed(MainScreen.routeName).then((_) {
          globals.currentUser = null;
          globals.authToken = null;
        });
        _clearUi();
      } on Exception catch (e) {
        final snackBar = SnackBar(content: Text('Login failed'));
        Scaffold.of(context).showSnackBar(snackBar);
        print('Login failed');
        print(e);
      }
    }
  }

  void _clearUi() {
    _loginController.clear();
    _passwordController.clear();
  }
}
