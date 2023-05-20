import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Widget _buildButton(String btnText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(220, 60),
          maximumSize: const Size(220, 60),
          elevation: 0,
          // backgroundColor: Colors.black.withOpacity(0.3)
        ),
        child: Text(btnText, style: const TextStyle(fontSize: 18)),
        onPressed: () {
          if (btnText == "Owner") {
            Navigator.pushNamed(context, '/signup_info',
                arguments: {"type": "Owner"});
          } else if (btnText == "Customer") {
            Navigator.pushNamed(context, '/signup_info',
                arguments: {"type": "User"});
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: const Color.fromARGB(255, 67, 134, 221),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
            textStyle: const TextStyle(fontSize: 12)),
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
    );

    if (Provider.of<TokenProvider>(context, listen: false).currToken == "") {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "You are\na/an",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 75),
              _buildButton("Owner"),
              _buildButton("Customer"),
              const SizedBox(height: 100),
              backButton
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Text("You are logged in"),
      );
    }
  }
}