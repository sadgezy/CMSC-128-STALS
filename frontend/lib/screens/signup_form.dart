import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    Widget navigationButtons =
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xff7B2D26),
          minimumSize: const Size(100, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text("Back", style: TextStyle(fontSize: 17)),
      ),
      ElevatedButton(
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
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xff0B7A75),
          minimumSize: const Size(100, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text("Next", style: TextStyle(fontSize: 17)),
      ),
    ]);

    return Scaffold(
        backgroundColor: Color(0xffF0F3F5),
        body: SingleChildScrollView(
            child: Center(
          child: ConstrainedBox(
            constraints: new BoxConstraints(maxWidth: 550.0),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: <Widget>[
                  SizedBox(height: height * 0.04),
                  const Text(
                    "Welcome!",
                    style: TextStyle(
                        fontSize: 28,
                        // fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 31, 36, 33)),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        TextFormField(
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(25, 10, 10, 10),
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 175, 31, 18),
                                    width: 2,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 175, 31, 18),
                                    width: 1,
                                  )),
                              labelText: "First Name"),
                          onChanged: (value) => _firstName = value,
                          controller: firstNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(25, 10, 10, 10),
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 175, 31, 18),
                                    width: 2,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 175, 31, 18),
                                    width: 1,
                                  )),
                              labelText: "Last Name"),
                          onChanged: (value) => _lastName = value,
                          controller: lastNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(25, 10, 10, 10),
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 175, 31, 18),
                                    width: 2,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 175, 31, 18),
                                    width: 1,
                                  )),
                              labelText: "Middle Name"),
                          onChanged: (value) => _middleName = value,
                          controller: middleNameController,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(25, 10, 10, 10),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              labelText: "Suffix"),
                          onChanged: (value) => _suffix = value,
                          controller: suffixController,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(25, 10, 10, 10),
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 175, 31, 18),
                                    width: 2,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 175, 31, 18),
                                    width: 1,
                                  )),
                              labelText: "Username"),
                          onChanged: (value) => _username = value,
                          controller: usernameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(25, 10, 25, 10),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 2,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 1,
                                )),
                            labelText: "Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          onChanged: (value) => _password = value,
                          controller: passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (!RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?:{}|<>]).{8,}$')
                                .hasMatch(value)) {
                              return 'Password must have at least 8 characters, 1 uppercase letter, \n1 lowercase letter, 1 number, and 1 special character';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(25, 10, 10, 10),
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 175, 31, 18),
                                    width: 2,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 175, 31, 18),
                                    width: 1,
                                  )),
                              labelText: "E-mail"),
                          onChanged: (value) => _email = value,
                          controller: emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        const SizedBox(height: 10),
                        TextFormField(
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(25, 10, 10, 10),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 175, 31, 18),
                                      width: 2,
                                    )),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 175, 31, 18),
                                      width: 1,
                                    )),
                                labelText: "Phone Number"),
                            onChanged: (value) => _phone = value,
                            controller: phoneController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
                                return 'Please enter a valid mobile number starting with 09';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ]),
                        const SizedBox(height: 50),
                        navigationButtons
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
