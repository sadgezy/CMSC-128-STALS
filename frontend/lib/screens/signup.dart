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
              minimumSize: const Size(150, 150),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 1,
              backgroundColor: btnText == "Owner"
                  ? const Color(0xff7B2D26)
                  : const Color(0xff0B7A75)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(btnText, style: const TextStyle(fontSize: 20)),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              SizedBox(
                height: 60,
                child: Image.asset(
                  btnText == "Owner"
                      ? 'assets/images/flat.png'
                      : 'assets/images/user.png',
                  fit: BoxFit.fitWidth,
                ),
              )
            ],
          ),
          onPressed: () {
            if (btnText == "Owner") {
              Navigator.pushNamed(context, '/signup_info',
                  arguments: {"type": "owner"});
            } else if (btnText == "Consumer") {
              Navigator.pushNamed(context, '/signup_info',
                  arguments: {"type": "user"});
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<TokenProvider>(context, listen: false).currToken == "") {
      return Scaffold(
          backgroundColor: const Color(0xffF0F3F5),
          body: SingleChildScrollView(
              child: Center(
                  child: ConstrainedBox(
            constraints: new BoxConstraints(maxWidth: 550.0),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 70)),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Which one are you?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                      FractionallySizedBox(
                        widthFactor: 0.85,
                        child: Row(children: [
                          Expanded(child: _buildButton("Owner")),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20)),
                          Expanded(child: _buildButton("Consumer")),
                        ]),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 50)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  style: ElevatedButton.styleFrom(
                    elevation: 1,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(100, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Cancel",
                      style: TextStyle(fontSize: 17, color: Color(0xff1F2421))),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              ],
            ),
          ))));
    } else {
      return const Center(
        child: Text("You are logged in"),
      );
    }
  }
}
