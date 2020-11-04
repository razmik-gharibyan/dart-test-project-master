import 'dart:io';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/api/api_client.dart';
import 'package:chat_mobile/helpers/user_helper.dart';
import 'package:chat_mobile/widgets/common_ui.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_mobile/globals.dart' as globals;
import 'package:chat_mobile/helpers/global_consts.dart' as consts;
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {

  static const String routeName = '/account-screen';

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountData {
  String login = '';
  String password = '';
  String email = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
}

class _AccountScreenState extends State<AccountScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _AccountData _accountData = _AccountData();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final UserHelper _userHelper = UserHelper();
  bool _enableEdit = false;
  bool _isLoading = false;

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

  String _validatePhoneNumber(String value) {
    if (value.length < 9) {
      // check phone rules here
      return 'Phone number should be at least 9 characters.';
    }
    return null;
  }


  @override
  void initState() {
    super.initState();
    _userToAccountData(_userHelper.user);
  }

  @override
  void dispose() {
    _clearUi();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your account'),
          actions: <Widget>[LogoutButton(),],
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: _isLoading ? Platform.isAndroid ? CircularProgressIndicator() : CupertinoActivityIndicator() :  Form(
                key: this._formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Account Page',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.yellow,
                      child: Text(
                        '${_accountData.firstName.isNotEmpty ? _accountData.firstName[0] : 'A'}'
                        '${_accountData.lastName.isNotEmpty ? _accountData.lastName[0] : 'A'}',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      _accountData.login,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      enabled: _enableEdit,
                      controller: _emailController,
                      validator: this._validateEmail,
                      onSaved: (String value) {
                        this._accountData.email = value;
                      },
                      decoration: new InputDecoration(
                          hintText: 'E-mail', labelText: 'Your e-mail'),
                    ),
                    TextFormField(
                      enabled: _enableEdit,
                      controller: _passwordController,
                      obscureText: true,
                      // Use secure text for passwords.
                      validator: this._validatePassword,
                      onSaved: (String value) {
                        this._accountData.password = value;
                      },
                      decoration: new InputDecoration(
                          hintText: 'Password', labelText: 'Your password'),
                    ),
                    TextFormField(
                      enabled: _enableEdit,
                      controller: _firstNameController,
                      validator: this._validateFirstName,
                      onSaved: (String value) {
                        this._accountData.firstName = value;
                      },
                      decoration: new InputDecoration(
                          hintText: 'First name', labelText: 'Your first name'),
                    ),
                    TextFormField(
                      enabled: _enableEdit,
                      controller: _lastNameController,
                      validator: this._validateLastName,
                      onSaved: (String value) {
                        this._accountData.lastName = value;
                      },
                      decoration: new InputDecoration(
                          hintText: 'Last name', labelText: 'Your last name'),
                    ),
                    TextFormField(
                      enabled: _enableEdit,
                      controller: _phoneController,
                      validator: this._validatePhoneNumber,
                      keyboardType: TextInputType.number,
                      onSaved: (String value) {
                        this._accountData.phone = value;
                      },
                      decoration: InputDecoration(
                          hintText: 'Phone number', labelText: 'Your phone number'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child:
                          RaisedButton(
                              child: Text("Edit"),
                              onPressed: () {
                                setState(() {
                                  _enableEdit = true;
                                });
                              }),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child:
                          RaisedButton(
                              child: Text("Save"),
                              onPressed: () {
                                _signUp(scaffoldContext);
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }

  void _userToAccountData(User user) {
    _accountData.login = user.name ?? '';
    _accountData.password = user.password ?? '';
    _passwordController.text = _accountData.password;
    _accountData.email = user.email ?? '';
    _emailController.text = _accountData.email;
    _accountData.firstName = user.firstName ?? '';
    _firstNameController.text = _accountData.firstName;
    _accountData.lastName = user.lastName ?? '';
    _lastNameController.text = _accountData.lastName;
    _accountData.phone = user.phone ?? '';
    _phoneController.text = _accountData.phone;
  }

  _signUp(BuildContext context) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      UsersClient usersClient = UsersClient(MobileApiClient());
      await usersClient
          .update(
          User(password: _accountData.password, email: _accountData.email,
              firstName: _accountData.firstName, lastName: _accountData.lastName, phone: _accountData.phone ))
          .then((updatedUser) async {
        globals.currentUser = updatedUser;
        _userHelper.setUser(updatedUser);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(consts.PASSWORD, _accountData.password);
        setState(() {
          _isLoading = false;
          _enableEdit = false;
        });
        final snackBar = SnackBar(
            content: Text('Changes successfully saved'));
        Scaffold.of(context).showSnackBar(snackBar);
      }).catchError((updateDataError) {
        final snackBar = SnackBar(
            content: Text('Saving failed: ${updateDataError.message}'));
        Scaffold.of(context).showSnackBar(snackBar);
        print('Saving data failed');
        print(updateDataError);
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  void _clearUi() {
    _passwordController.clear();
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneController.clear();
  }
}
