// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random/Screens/auth_screen.dart';
import 'package:random/Screens/cart_screen.dart';
import 'package:random/Screens/home_screen.dart';
import 'package:random/Screens/nav_screen.dart';
import 'package:random/providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LoginScreen());
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: NavigationScreen(),
            //initialRoute: AuthScreen.id,
            routes: {
              AuthScreen.id: (context) => AuthScreen(),
              NavigationScreen.id:(context)=> NavigationScreen(),
              HomeScreen.id: (context) => HomeScreen(),
              CartScreen.id: (context) => CartScreen(),
            },
          );
        },
      ),
    );
  }
}
