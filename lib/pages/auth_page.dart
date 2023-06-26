import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:techpack/authentication/auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String? errorMessage = "";
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Form(
              key:formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.jpg',width: 200,height: 100,),
                  TextFormField(
                      controller: _controllerEmail,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) {
                          if (value!.isEmpty) {
                            return "This field is required";
                          } else {
                            return null;
                          }
                      },
                  ),
                  TextFormField(
                      controller: _controllerPassword,
                      obscureText:true,
                      decoration: const InputDecoration(labelText: "Password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field is required";
                        } else {
                          return null;
                        }
                      },
                  ),
                  const SizedBox(height: 25,),
                  Text(errorMessage == "" ? "" : "Humm ? $errorMessage"),
                  const SizedBox(height: 25,),
                  ElevatedButton(
                      onPressed: ()  {
                        final isValid = formKey.currentState?.validate();
                        if (isValid == true) {
                          isLogin
                              ? signInWithEmailAndPassword()
                              : createUserWithEmailAndPassword();
                        }
                      },
                      child: Text(isLogin ? "Login" : "Register")),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child:
                          Text(isLogin ? "Register instead" : "Login instead")),
                ],
              ),
            )));
  }
}
