import 'package:flutter/material.dart';
import 'package:lat_uas/models/user.dart';

import 'package:lat_uas/providers/current_user.dart';

import 'package:lat_uas/providers/user_log.dart';
import 'package:lat_uas/services/auth_service.dart';
import 'package:lat_uas/views/widget_tree.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  /*************  ✨ Windsurf Command ⭐  *************/
  /// Attempts to log in with the provided username and password.
  /// If the fields are empty, shows a snackbar asking to fill all fields.
  /// If the credentials are invalid, shows a snackbar with the message "Invalid Credentials".
  /// If the credentials are valid, logs in the user and navigates to the WidgetTree.
  /*******  608716d4-0907-4df4-9852-0019e7b6bf8b  *******/
  void login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    bool isValid = false;
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
    } else {
      final user = await AuthService.login(username, password);

      if (user != null) {
        context.read<CurrentUser>().changeCurrentUser(user);
        context.read<UserLog>().login(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WidgetTree();
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Login Page"),
                    SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: "enter username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: "enter password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      child: Text("Loginn"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
