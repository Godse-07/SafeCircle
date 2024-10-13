import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woman_safety/components/custom_textfield.dart';
import 'package:woman_safety/components/primary_button.dart';
import 'package:woman_safety/components/secondary_button.dart';

import 'package:woman_safety/home_screen.dart';
import 'package:woman_safety/registed_parent.dart';
import 'package:woman_safety/register_child.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _formData['email'] as String,
              password: _formData['password'] as String);

      setState(() {
        isLoading = false;
      });

      if (userCredential.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      // Check for specific error codes
      if (e.code == 'user-not-found') {
        _showErrorDialog("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        _showErrorDialog("The password does not match the provided email.");
      } else if (e.code == 'invalid-email') {
        _showErrorDialog("The email address is not valid.");
      } else if (e.code == 'invalid-credential') {
        _showErrorDialog(
            "The provided credentials are incorrect. Please check your email and password.");
      } else {
        _showErrorDialog("An error occurred: ${e.message}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog("An unexpected error occurred.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    "User Login",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD40061),
                    ),
                  ),
                ),
                Image.asset(
                  "assets/new_logo.png",
                  height: 450,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextfield(
                        hintText: "Enter email",
                        prefix: Icon(Icons.person),
                        validate: (email) {
                          if (email == null || email.isEmpty) {
                            return "Email is required";
                          }
                          if (!email.contains("@")) {
                            return "Email is invalid";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onsave: (email) {
                          _formData['email'] = email ?? "";
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextfield(
                        hintText: "Enter Password",
                        isPassword: isPasswordShown,
                        prefix: Icon(Icons.password),
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordShown = !isPasswordShown;
                            });
                          },
                          icon: Icon(
                            isPasswordShown
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        validate: (password) {
                          if (password == null || password.isEmpty) {
                            return "Password is required";
                          }
                          if (password.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        onsave: (password) {
                          _formData['password'] = password ?? "";
                        },
                      ),
                      SizedBox(height: 30),
                      isLoading
                          ? CircularProgressIndicator()
                          : PrimaryButton(
                              title: "Login",
                              onPress: _onSubmit,
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forget Password?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFD40061),
                      ),
                    ),
                    SizedBox(width: 10),
                    SecondaryButton(
                      title: "Press here",
                      onPress: () {
                        // Implement password reset functionality
                        print("Forget Password");
                      },
                    )
                  ],
                ),
                SizedBox(height: 20),
                SecondaryButton(
                  title: "Create new account as a child",
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterChild()));
                  },
                ),
                SizedBox(height: 20),
                SecondaryButton(
                  title: "Create new account as a Parent",
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ParentLoginScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
