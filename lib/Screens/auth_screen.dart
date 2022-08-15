import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random/Screens/home_screen.dart';
import 'package:random/Screens/nav_screen.dart';
import 'package:random/componenets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const String id = 'auth_screen';

  AuthScreen({Key? key}) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final storage = FlutterSecureStorage();
  FirebaseAuth _auth = FirebaseAuth.instance;
  var errorMessage;
  bool _isLoading = false;
  //to submit the form
  void _submitAuthForm(
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential _userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        await storage.write(key: "uid", value: _userCredential.user!.uid);
        Navigator.pushNamedAndRemoveUntil(context, NavigationScreen.id, (r) => false);
        setState(() {
          _isLoading = false;
        });
      } else {
        _userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userCredential.user!.uid)
            .set({'email': email});
        Navigator.pushNamedAndRemoveUntil(context, NavigationScreen.id, (r) => false);
        setState(() {
          _isLoading = false;
        });
      }
    } on PlatformException catch (err) {
      if (err.message != null) {
        var message = err.message!;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
