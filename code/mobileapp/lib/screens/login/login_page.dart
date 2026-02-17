import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:mobileapp/config/env.dart';
import 'package:mobileapp/config/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/widgets/header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool failedLogin = false;
  bool _showPassword = false;

  void login(String email, String password) async {
    try {
      Response response = await post(Uri.parse('$apiUrl/auth/login'), body: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // Save the user token to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userToken', data['Token']);

        Map<String, dynamic> userData = data['User'];
        prefs.setInt('userId', userData['id']);

        // If this page was pushed onto the stack, pop and return true to the caller
        if (Navigator.of(context).canPop()) {
          context.pop(true);
        } else {
          // Otherwise, navigate to the home route which will recreate the Home widget and therefore refresh state
          context.go(AppRoutes.home);
        }
      } else {
        setState(() {
          failedLogin = true;
          passwordController.clear();
          emailController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to login, please try again.")),
        );
      }
      debugPrint("THERE WAS AN EXCEPTION: ");
      debugPrint(e.toString());
    }
  }

  void remember() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: const Header(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (failedLogin) ...[
                Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: const BorderRadius.all(Radius.circular(30))),
                  child: Text(
                    'Email of wachtwoord incorrect',
                    style: TextStyle(color: Theme.of(context).colorScheme.onError, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: _showPassword ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => _showPassword = !_showPassword);
                    },
                  ),
                ),
                obscureText: !_showPassword,
                enableSuggestions: false,
                autocorrect: false,
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    login(emailController.text.toString(), passwordController.text.toString());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      launchUrl(Uri.parse(forgotPasswordUrl));
                    },
                    child: Text('Wachtwoord vergeten?')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
