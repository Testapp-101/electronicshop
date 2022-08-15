// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import '../constants.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this._isLoading, {Key? key}) : super(key: key);
  final bool _isLoading;
  final void Function(
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  var username = '';
  var email = '';
  var password = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(email.trim(), password.trim(), _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _passwordController = TextEditingController();
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Electronic',
                      style: TextStyle(
                        fontSize: 45.0,
                        color: Colors.yellow.shade800,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Shop',
                      style: TextStyle(
                        fontSize: 45.0,
                        color: Colors.yellow.shade800,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                TextFormField(
                    key: ValueKey('email'),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is Required';
                      }
                      if (!RegExp(
                              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                          .hasMatch(value)) {
                        return 'Please enter a valid email Address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email')),
                SizedBox(height: 12.0),
                  TextFormField(
                      controller: _passwordController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return 'Password must be at least 8 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value!;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your password')),
                SizedBox(height: 12.0),
                if (!_isLogin)
                TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Password do not match';
                      }
                      return null;
                    },
                    // onSaved: (value) {
                    //   password = value!;
                    // },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Confirm your password')),
                SizedBox(height: 12.0),
                if (widget._isLoading)
                  LinearProgressIndicator(
                    backgroundColor: Colors.yellow.shade800,
                  ),
                if (!widget._isLoading)
                  RaisedButton(
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                    color: Colors.green,
                    onPressed: _trySubmit,
                  ),
                if (!widget._isLoading)
                  FlatButton(
                    textColor: Colors.tealAccent,
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'Already have an account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
