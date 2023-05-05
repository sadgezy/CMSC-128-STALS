import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String _firstName = '';
  String _lastName = '';
  String _middleInitials = '';
  String? _suffix = '';
  String _username = '';
  String _password = '';
  String _email = '';
  String _phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
              onChanged: (value) => _firstName = value,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
              onChanged: (value) => _lastName = value,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Middle Initials',
              ),
              onChanged: (value) => _middleInitials = value,
            ),
            DropdownButtonFormField(
              items: [
                DropdownMenuItem(
                  child: Text('Mr.'),
                  value: 'Mr.',
                ),
                DropdownMenuItem(
                  child: Text('Ms.'),
                  value: 'Ms.',
                ),
                DropdownMenuItem(
                  child: Text('Mrs.'),
                  value: 'Mrs.',
                ),
              ],
              onChanged: (value) => _suffix = value,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
              ),
              onChanged: (value) => _username = value,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              onChanged: (value) => _password = value,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (value) => _email = value,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
              onChanged: (value) => _phone = value,
            ),
            MaterialButton(
              child: Text('Sign Up'),
              onPressed: () {
                // TODO: Sign up the user.
              },
            ),
          ],
        ),
      ),
    );
  }
}
