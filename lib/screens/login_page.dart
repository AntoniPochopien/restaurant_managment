import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final _formKey = new GlobalKey<FormState>();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    @override
    void dispose() {
      _loginController.dispose();
      _passwordController.dispose();
      super.dispose();
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
                flex: 5,
                child: Container(
                  color: Color.fromARGB(255, 81, 148, 224),
                )),
            Expanded(
              flex: 3,
              child: Container(
                color: Color.fromARGB(255, 64, 114, 172),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login page',
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                        SizedBox(
                          height: _height * 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _loginController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter login';
                              }
                              if (value.length < 6) {
                                return 'Login is too short';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text('Login'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              if (value.length < 6) {
                                return 'Password is too short';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text('Password'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height * 0.05,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      UserCredential result =
                                          await auth.signInWithEmailAndPassword(
                                              email: _loginController.text,
                                              password:
                                                  _passwordController.text);
                                      
                                      Navigator.of(context).popAndPushNamed(
                                          '/mainPage',
                                          arguments: {'userId': result.user!.uid});
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Invalid credentials or user did not exists')),
                                      );
                                    }
                                  }
                                },
                                child: Text('Log in'),
                              )),
                        )
                      ]),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  color: Color.fromARGB(255, 81, 148, 224),
                )),
          ],
        ),
      ),
    );
  }
}
