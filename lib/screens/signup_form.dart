import 'package:flutter/material.dart';
import 'package:stals_frontend/screens/verify_user.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
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
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
              onChanged: (value) => _firstName = value,
              controller: firstNameController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
              onChanged: (value) => _lastName = value,
              controller: lastNameController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Middle Name',
              ),
              onChanged: (value) => _middleName = value,
              controller: middleNameController,
            ),
            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(
                  value: 'Mr.',
                  child: Text('Jr.'),
                ),
                DropdownMenuItem(
                  value: 'Ms.',
                  child: Text('III'),
                ),
              ],
              onChanged: (value) => _suffix = value,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              onChanged: (value) => _username = value,
              controller: usernameController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              onChanged: (value) => _password = value,
              controller: passwordController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (value) => _email = value,
              controller: emailController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
              onChanged: (value) => _phone = value,
              controller: phoneController,
            ),
            MaterialButton(
              child: const Text('Next'),
              onPressed: () {
                Navigator.pushNamed(context, '/verify_user');
              },
            ),
          ],
        ),
      ),
    );
  }
}
