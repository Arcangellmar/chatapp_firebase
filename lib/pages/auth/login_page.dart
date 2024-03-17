import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/register_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formKey = GlobalKey<FormState>();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  AuthService authService = AuthService();
  bool _isLoading = false;

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await authService
          .loginWithEmailAndPassword(
          emailTextEditingController.text,
          passwordTextEditingController.text
      ).then((value) async {
        if (value != null) {

          QuerySnapshot snapshot =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(emailTextEditingController.text);

          // saving the values to our shared preferences
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(emailTextEditingController.text);
          await HelperFunction.saveUserNameSF(snapshot.docs[0]['fullName']);


          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false
          );
        } else {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error al loguearse"),
              backgroundColor: Colors.red,
            ),
          );

          setState(() => _isLoading = false);
        }
      }
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _isLoading
      ? Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor
          )
        )
      : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Chat App Firebase",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Logeate para comenzar a chatear",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Image.asset("assets/login.png"),
              TextFormField(
                controller: emailTextEditingController,
                decoration: textInputDecoration.copyWith(
                  labelText: 'Correo',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordTextEditingController,
                decoration: textInputDecoration.copyWith(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(
                    Icons.password,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  onPressed: login,
                  child: const Text(
                    'Loguearse',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "¿No tienes cuenta?",
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage())),
                      text: " Registrate",
                      style: const TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
