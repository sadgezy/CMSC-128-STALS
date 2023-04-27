import 'package:flutter/material.dart';
import 'package:stals_frontend/screens/signup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> emailKey = GlobalKey<FormState>();
    final GlobalKey<FormState> passKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final email = Form(
        key: emailKey,
        child: TextFormField(
          controller: emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty!';
            }
            return null;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            labelText: 'E-mail',
          ),
        ));

    final password = Form(
        key: passKey,
        child: TextFormField(
          controller: passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty!';
            }
            return null;
          },
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            labelText: 'Password',
          ),
        ));

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            shadowColor: Colors.black,
            elevation: 5,
            backgroundColor: const Color.fromARGB(255, 25, 83, 95),
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 15),
            textStyle: const TextStyle(
              fontSize: 15,
            )),
        child: const Text('Sign in', style: TextStyle(color: Colors.white)),
      ),
    );

    final signupButton = Container(
        child: GestureDetector(
      onTap: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SignUpPage(),
          ),
        );
      },
      child: const Text(
        'Make an Account!',
        style: TextStyle(color: Color.fromARGB(255, 25, 83, 95)),
      ),
    ));

    // ElevatedButton(
    //   onPressed: () async {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (context) => const SignUpPage(),
    //       ),
    //     );
    //   },
    //   style: ElevatedButton.styleFrom(
    //       shape: const StadiumBorder(),
    //       backgroundColor: const Color.fromARGB(255, 25, 83, 95),
    //       padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
    //       textStyle: const TextStyle(fontSize: 12)),
    //   child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
    // );

    final loginFields = Container(
      child: Column(
        children: [
          email,
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          password,
          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
          loginButton,
          const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          const Text(
            "No account yet?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12, color: Color.fromARGB(255, 240, 243, 245)),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
          signupButton
        ],
      ),
    );

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 240, 243, 245),
          Color.fromARGB(255, 25, 83, 95)
        ],
        stops: [0.35, 0.95],
      )),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            const Text(
              "Welcome Back!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
            loginFields
          ],
        ),
      ),
    ));
  }
}
