import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woman_safety/components/custom_textfield.dart';
import 'package:woman_safety/components/primary_button.dart';
import 'package:woman_safety/components/secondary_button.dart';
import 'package:woman_safety/constant.dart';
import 'package:woman_safety/login_screen.dart';

class RegisterChild extends StatefulWidget {
  @override
  State<RegisterChild> createState() => _RegisterChildState();
}

class _RegisterChildState extends State<RegisterChild> {
  bool isPasswordShown = true;

  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object>();

  void _onSubmit() {
    _formKey.currentState!.save();
    if (_formData['password'] != _formData['rpassword']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password does not match"),
      ));
      return;
    } else {
      progress(context);
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        auth
            .createUserWithEmailAndPassword(
                email: _formData['email'].toString(),
                password: _formData['password'].toString())
            .whenComplete(() => Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen())));
      } on FirebaseAuthException catch (e) {
        _dialogueBox(context, e.message.toString());
      } catch (e) {
        print(e.toString());
      }
    }
    print(_formData);
  }

  void _dialogueBox(BuildContext context, String message) {
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
                child: Container(
                  child: Column(
                    children: [
                      CustomTextfield(
                        hintText: "Enter Name",
                        prefix: Icon(Icons.person_outline_outlined),
                        validate: (name) {
                          if (name!.isEmpty) {
                            return "name is required";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onsave: (name) {
                          _formData['name'] = name ?? "";
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextfield(
                        hintText: "Enter phone",
                        prefix: Icon(Icons.phone),
                        validate: (number) {
                          if (number!.isEmpty || number.length < 10) {
                            return "number is required";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onsave: (number) {
                          _formData['number'] = number ?? "";
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextfield(
                        hintText: "Enter email",
                        prefix: Icon(Icons.email_rounded),
                        validate: (email) {
                          if (email!.isEmpty) {
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
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextfield(
                        hintText: "Enter gurdian's email",
                        prefix: Icon(Icons.email_rounded),
                        validate: (gemail) {
                          if (gemail!.isEmpty) {
                            return "gurdian's email is required";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onsave: (gemail) {
                          _formData['gemail'] = gemail ?? "";
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                            icon: isPasswordShown
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility)),
                        validate: (password) {
                          if (password!.isEmpty) {
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
                      SizedBox(
                        height: 20,
                      ),
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
                            icon: isPasswordShown
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility)),
                        validate: (password) {
                          if (password!.isEmpty) {
                            return "Password is required";
                          }
                          if (password.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        onsave: (password) {
                          _formData['rpassword'] = password ?? "";
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      PrimaryButton(
                        title: "Login",
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            _onSubmit();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              SecondaryButton(
                  title: "Login with existing account",
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
