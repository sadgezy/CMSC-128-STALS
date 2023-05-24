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
              minimumSize: const Size(100, 240),
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
              const SizedBox(height: 30),
              SizedBox(
                height: 80,
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
            } else if (btnText == "Customer") {
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
        body: Column(
          children: [
            const SizedBox(
              height: 160,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "You are\na/an",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 43),
                  ),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 37),
                    child: SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: Row(children: [
                        Expanded(child: _buildButton("Owner")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(child: _buildButton("Customer")),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 50),
                    child: ElevatedButton(
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
                          style: TextStyle(
                              fontSize: 17, color: Color(0xff1F2421))),
                    ),
                  )),
            )
          ],
        ),
      );
    } else {
      return const Center(
        child: Text("You are logged in"),
      );
    }
  }
}
