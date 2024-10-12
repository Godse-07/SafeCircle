import 'package:flutter/material.dart';
import 'package:woman_safety/components/custom_textfield.dart';
import 'package:woman_safety/components/primary_button.dart';
import 'package:woman_safety/components/secondary_button.dart';
import 'package:woman_safety/register_child.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  void _onSubmit() {
    _formKey.currentState!.save();
    print(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Center(
                    child: Text(
                      "Login",
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
                          hintText: "Enter email",
                          prefix: Icon(Icons.person),
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
                          height: 35,
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
                    SizedBox(
                      width: 10,
                    ),
                    SecondaryButton(
                        title: "Press here",
                        onPress: () {
                          print("Forget Password");
                        })
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SecondaryButton(
                    title: "Create new account",
                    onPress: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RegisterChild();
                      }));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
