import 'package:chat_mobile/screens/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/api/api_client.dart';
import 'package:chat_mobile/globals.dart' as globals;

class SignUpScreen extends StatefulWidget {

  static const String routeName = '/sign-up-screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpData {
  String login = '';
  String password = '';
  String email = '';
  String firstName = '';
  String lastName = '';
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _SignUpData _signUpData = _SignUpData();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

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

  String _validateEmail(String value) {
    if (value.length == 0) {
      // check email rules here
      return 'The E-mail must not be empty.';
    } else if(!value.contains('@') || !value.contains('.')) {
      return 'Invalid E-mail.';
    }
    return null;
  }

  String _validateFirstName(String value) {
    if (value.length < 2) {
      // check first name rules here
      return 'First name should be at least 2 characters.';
    }
    return null;
  }

  String _validateLastName(String value) {
    if (value.length < 2) {
      // check last name rules here
      return 'First name should be at least 2 characters.';
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
                    'Sign Up Page',
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
                      this._signUpData.login = value;
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
                      this._signUpData.password = value;
                    },
                    decoration: new InputDecoration(
                        hintText: 'Password', labelText: 'Enter your password'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: this._validateEmail,
                    onSaved: (String value) {
                      this._signUpData.email = value;
                    },
                    decoration: new InputDecoration(
                        hintText: 'E-mail', labelText: 'Enter your e-mail'),
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    validator: this._validateFirstName,
                    onSaved: (String value) {
                      this._signUpData.firstName = value;
                    },
                    decoration: new InputDecoration(
                        hintText: 'First name', labelText: 'Enter your first name'),
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    validator: this._validateLastName,
                    onSaved: (String value) {
                      this._signUpData.lastName = value;
                    },
                    decoration: new InputDecoration(
                        hintText: 'Last name', labelText: 'Enter your last name'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child:
                        RaisedButton(
                          child: Text("Sign Up"),
                          onPressed: () {
                            _signUp(scaffoldContext);
                        }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  _signUp(BuildContext context) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
        UsersClient usersClient = UsersClient(MobileApiClient());
        usersClient
            .create(
            User(name: _signUpData.login, password: _signUpData.password, email: _signUpData.email,
                firstName: _signUpData.firstName, lastName: _signUpData.lastName ))
            .then((createdUser) {
             globals.currentUser = createdUser;
          _clearUi();
          Navigator.of(context).pushReplacementNamed(ChatListPage.routeName);
        }).catchError((signUpError) {
          final snackBar = SnackBar(
              content: Text('Sign up failed: ${signUpError.message}'));
          Scaffold.of(context).showSnackBar(snackBar);
          print('Sign up failed');
          print(signUpError);
      });
    }
  }

  void _clearUi() {
    _loginController.clear();
    _passwordController.clear();
  }

}