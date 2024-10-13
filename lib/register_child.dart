import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woman_safety/components/custom_textfield.dart';
import 'package:woman_safety/components/primary_button.dart';
import 'package:woman_safety/components/secondary_button.dart';
import 'package:woman_safety/constant.dart';
import 'package:woman_safety/login_screen.dart';
import 'package:woman_safety/model/user_model.dart';

class RegisterChild extends StatefulWidget {
  @override
  State<RegisterChild> createState() => _RegisterChildState();
}

class _RegisterChildState extends State<RegisterChild> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  void _onSubmit() async {
    _formKey.currentState!.save();
    if (_formData['password'] != _formData['rpassword']) {
      _showErrorDialog("Password does not match");
      return;
    }
    
    // Check if email already exists
    bool emailExists = await _checkEmailExists(_formData['email'].toString());
    if (emailExists) {
      _showErrorDialog("An account with this email already exists");
      return;
    }
    
    // If everything is correct, show progress bar and register user
    progress(context);
    _registerUser();
  }

  Future<bool> _checkEmailExists(String email) async {
    try {
      // Using Firebase Auth to check if email exists
      var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      print("Error checking email existence: $e");
      return false;
    }
  }

  void _registerUser() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: _formData['email'].toString(),
        password: _formData['password'].toString(),
      );

      if (userCredential.user != null) {
        DocumentReference<Map<String, dynamic>> db = FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid);
        final user = UserModel(
          name: _formData['name'].toString(),
          number: _formData['number'].toString(),
          child_mail: _formData['email'].toString(),
          parent_email: _formData['gemail'].toString(),
          id: userCredential.user!.uid,
        );
        await db.set(user.toJson()).whenComplete(() {
          Navigator.of(context).pop(); // Dismiss progress dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Dismiss progress dialog
      _showErrorDialog(e.message ?? "An error occurred during registration");
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss progress dialog
      _showErrorDialog("An unexpected error occurred");
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
    // The build method remains unchanged
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Center(
                  child: Text(
                    "Register as a child",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD40061),
                    ),
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  "assets/new_logo.png",
                  height: 450,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextfield(
                      hintText: "Enter Name",
                      prefix: Icon(Icons.person_outline_outlined),
                      validate: (name) {
                        if (name!.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      onsave: (name) {
                        _formData['name'] = name ?? "";
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextfield(
                      hintText: "Enter phone",
                      prefix: Icon(Icons.phone),
                      validate: (number) {
                        if (number!.isEmpty || number.length < 10) {
                          return "Valid phone number is required";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      onsave: (number) {
                        _formData['number'] = number ?? "";
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextfield(
                      hintText: "Enter email",
                      prefix: Icon(Icons.email_rounded),
                      validate: (email) {
                        if (email!.isEmpty || !email.contains("@")) {
                          return "Valid email is required";
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
                      hintText: "Enter guardian's email",
                      prefix: Icon(Icons.email_rounded),
                      validate: (gemail) {
                        if (gemail!.isEmpty || !gemail.contains("@")) {
                          return "Valid guardian's email is required";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onsave: (gemail) {
                        _formData['gemail'] = gemail ?? "";
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
                        if (password!.isEmpty || password.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                      onsave: (password) {
                        _formData['password'] = password ?? "";
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextfield(
                      hintText: "Re-enter Password",
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
                        if (password!.isEmpty || password.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                      onsave: (password) {
                        _formData['rpassword'] = password ?? "";
                      },
                    ),
                    SizedBox(height: 30),
                    PrimaryButton(
                      title: "Register",
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          _onSubmit();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SecondaryButton(
                title: "Login with existing account",
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
