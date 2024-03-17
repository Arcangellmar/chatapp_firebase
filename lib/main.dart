import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();

    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) => setState(() => _isSignedIn = value ?? false));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.primaryColor),
        useMaterial3: true,
      ),
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}

