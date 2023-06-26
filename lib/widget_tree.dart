import 'package:flutter/material.dart';
import 'package:techpack/authentication/auth.dart';
import 'package:techpack/pages/mainpage.dart';
import 'package:techpack/pages/auth_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Mainpage();
          } else {
            return const AuthPage();
          }
        });
  }
}
