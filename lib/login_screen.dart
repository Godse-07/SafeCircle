import 'package:flutter/material.dart';
import 'package:woman_safety/components/custom_textfield.dart';
import 'package:woman_safety/components/primary_button.dart';
import 'package:woman_safety/components/secondary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/new_logo.png",
                  height: 450,
                ),
              ),
              CustomTextfield(
                hintText: "Enter name",
                prefix: Icon(Icons.person),
              ),
              SizedBox(
                height: 35,
              ),
              CustomTextfield(
                hintText: "Enter Password",
                prefix: Icon(Icons.password),
              ),
              SizedBox(
                height: 30,
              ),
              PrimaryButton(
                title: "Login",
                onPress: () {
                  print("Login");
                },
              ),
              SizedBox(
                height: 20,
              ),
              SecondaryButton(
                title: "Register",
                onPress: () {
                  print("Register");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
