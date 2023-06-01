import 'package:flutter/material.dart';
import 'package:stals_frontend/screens/verify_user.dart';
import '../models/signup_arguments.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController suffixController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String _firstName = '';
  String _lastName = '';
  String _middleName = '';
  String? _suffix = '';
  String _username = '';
  String _password = '';
  String _email = '';
  String _phone = '';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    Map<String, String>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: height * 0.04),
            const Text(
              "Welcome!",
              style: TextStyle(fontSize: 30, color: Color(0xFF363f93)),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                    onChanged: (value) => _firstName = value,
                    controller: firstNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                    onChanged: (value) => _lastName = value,
                    controller: lastNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Middle Name',
                    ),
                    onChanged: (value) => _middleName = value,
                    controller: middleNameController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Suffix',
                    ),
                    onChanged: (value) => _suffix = value,
                    controller: suffixController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    onChanged: (value) => _username = value,
                    controller: usernameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    onChanged: (value) => _password = value,
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$')
                          .hasMatch(value)) {
                        return 'Password must have at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    onChanged: (value) => _email = value,
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    onChanged: (value) => _phone = value,
                    controller: phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
                        return 'Please enter a valid mobile number starting with 09';
                      }
                      return null;
                    },
                  ),
                  MaterialButton(
                    child: const Text('Next'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(context, '/verify_user',
                            arguments: SignupArguments(
                                _firstName,
                                _lastName,
                                _middleName,
                                _suffix,
                                _username,
                                _password,
                                _email,
                                _phone,
                                args?['type'] ?? ''));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
