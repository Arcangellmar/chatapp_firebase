import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  AuthService authService = AuthService();

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
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Chat App",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Crea tu cuenta para empezar a chatear",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400
                    )
                  ),
                  Image.asset("assets/register.png"),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "Nombre Completo",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      )
                    ),
                    controller: nameTextEditingController,
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "No debe ser vacio";
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "Correo",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      )
                    ),
                    controller: emailTextEditingController,
                    validator: (val) {
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!)
                          ? null
                          : "Ingrese un correo valido";
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: passTextEditingController,
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                      labelText: "Contraseña",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).primaryColor,
                      )
                    ),
                    validator: (val) {
                      if (val!.length < 6) {
                        return "La contraseña debe ser mayor a 6 caracteres";
                      } else {
                        return null;
                      }
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
                      onPressed: register,
                      child: const Text(
                        "Registrarse",
                        style:
                        TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: "¿Ya tienes una cuenta? ",
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Logueate",
                          style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pop()
                        ),
                      ],
                    )
                  ),
                ],
              )
            ),
          ),
      ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await authService
          .registerWithEmailAndPassword(
          nameTextEditingController.text,
          emailTextEditingController.text,
          passTextEditingController.text
        ).then((value) async {
          if (value != null) {
            // saving the shared preference state
            await HelperFunction.saveUserLoggedInStatus(true);
            await HelperFunction.saveUserEmailSF(emailTextEditingController.text);
            await HelperFunction.saveUserNameSF(nameTextEditingController.text);
            
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false
            );
          } else {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error al registrarse"),
                backgroundColor: Colors.red,
              ),
            );

            setState(() => _isLoading = false);
          }
        }
      );
    }
  }
}