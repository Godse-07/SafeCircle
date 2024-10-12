import 'package:flutter/material.dart';
import 'package:woman_safety/components/custom_textfield.dart';
import 'package:woman_safety/components/primary_button.dart';
import 'package:woman_safety/components/secondary_button.dart';
import 'package:woman_safety/login_screen.dart';

class ParentLoginScreen extends StatefulWidget {
  const ParentLoginScreen({super.key});

  @override
  State<ParentLoginScreen> createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  @override
  bool isPasswordShown = true;

  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object>();

  void _onSubmit() {
    _formKey.currentState!.save();
    print(_formData);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Center(
                  child: Text(
                    "Register as a parent",
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
                        hintText: "Enter children's email",
                        prefix: Icon(Icons.email_rounded),
                        validate: (cemail) {
                          if (cemail!.isEmpty) {
                            return "children's email is required";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onsave: (cemail) {
                          _formData['cemail'] = cemail ?? "";
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
                          _formData['password'] = password ?? "";
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
    ));
  }
}
