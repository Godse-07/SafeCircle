import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woman_safety/components/custom_textfield.dart';
import 'package:woman_safety/components/primary_button.dart';
import 'package:woman_safety/components/secondary_button.dart';
import 'package:woman_safety/db/shared_pref.dart';

import 'package:woman_safety/home_screen.dart';
import 'package:woman_safety/parent/parent_homescreen.dart';
import 'package:woman_safety/registed_parent.dart';
import 'package:woman_safety/register_child.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, String>{};
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
              email: _formData['email']!,
              password: _formData['password']!);

      if (userCredential.user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        setState(() {
          isLoading = false;
        });

        if (!mounted) return;

        if (userDoc.exists) {
          final userType = userDoc.data()?['type'] as String?;
          if (userType == 'parent') {
            SharedPref.saveUserType('parent');
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ParentHomescreen()));
          } else if (userType == 'child') {
            SharedPref.saveUserType('child');
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>HomeScreen()));
          } else {
            _showErrorDialog("Unknown user type");
          }
        } else {
          _showErrorDialog("User document not found");
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found for that email.";
          break;
        case 'wrong-password':
          errorMessage = "The password does not match the provided email.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        case 'invalid-credential':
          errorMessage = "The provided credentials are incorrect. Please check your email and password.";
          break;
        default:
          errorMessage = "An error occurred: ${e.message}";
      }
      _showErrorDialog(errorMessage);
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
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
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
                const Padding(
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
                        prefix: const Icon(Icons.person),
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
                      const SizedBox(height: 20),
                      CustomTextfield(
                        hintText: "Enter Password",
                        isPassword: isPasswordShown,
                        prefix: const Icon(Icons.password),
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
                      const SizedBox(height: 30),
                      isLoading
                          ? const CircularProgressIndicator()
                          : PrimaryButton(
                              title: "Login",
                              onPress: _onSubmit,
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Forget Password?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFD40061),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SecondaryButton(
                      title: "Press here",
                      onPress: () {
                        // Implement password reset functionality
                        print("Forget Password");
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20),
                SecondaryButton(
                  title: "Create new account as a child",
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterChild()));
                  },
                ),
                const SizedBox(height: 20),
                SecondaryButton(
                  title: "Create new account as a Parent",
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ParentLoginScreen()));
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