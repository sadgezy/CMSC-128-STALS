import 'package:flutter/material.dart';
import 'package:stals_frontend/screens/signup.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String user_type = "";

  @override
  Widget build(BuildContext context) {
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
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                borderSide:
                    const BorderSide(width: 0, style: BorderStyle.none)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
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
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                borderSide:
                    const BorderSide(width: 0, style: BorderStyle.none)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            labelText: 'Password',
          ),
        ));

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          String url = "http://127.0.0.1:8000/login/";
          final response = await json.decode((await http.post(Uri.parse(url),
                  body: {
                'email': emailController.text,
                'password': passwordController.text
              }))
              .body);
          if (response['message'] == "Login Successful") {
            String token = response['token'];
            Provider.of<TokenProvider>(context, listen: false).setToken(token);
            setState(() {});
            String url = "http://127.0.0.1:8000/get-one-user/";
            final response2 = await json.decode((await http.post(Uri.parse(url),
                    body: {
                  'email': emailController.text,
                }))
                .body);
            print(response2);
            user_type = response2[0]["user_type"];
            Provider.of<UserProvider>(context, listen: false).setUser(response2[0]["_id"], response2[0]["email"], response2[0]["username"], response2[0]["user_type"]);
          }
          else{
            print("Unsuccesful login!");
          }

        if(user_type == "user"){
            Navigator.pop(context);
            Navigator.pushNamed(context, '/signed_homepage');
        }
        else if(user_type == 'admin'){
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin');
        }
        else{
            Navigator.pop(context);
            Navigator.pushNamed(context, '/view_owned_accomms');
        }

        },
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
        'Make an account!',
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
          const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          password,
          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
          loginButton,
          const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          const Text(
            "No account yet?",
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 12, color: Color.fromARGB(255, 31, 36, 33)),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          signupButton
        ],
      ),
    );

    if (Provider.of<TokenProvider>(context, listen: false).currToken == "") {
      return Scaffold(
          body: SingleChildScrollView(
              child: Column(
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 70)),
          SizedBox(
              child: Image.asset('assets/images/stals_logo2.png',
                  fit: BoxFit.fill)),
          const Padding(
            padding: EdgeInsets.only(left: 45, top: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Welcome Back",
                style: TextStyle(
                    fontSize: 28,
                    // fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 31, 36, 33)),
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              // Image.asset('assets/images/stals_logo.png', fit: BoxFit.fill),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              loginFields
            ],
          ),
        ],
      ))
          // decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Color.fromARGB(255, 240, 243, 245),
          //     Color.fromARGB(255, 25, 83, 95)
          //   ],
          //   stops: [0.35, 0.95],
          // )),

          );
    } else {
      // print(Provider.of<UserProvider>(context, listen: false).userInfo);
      // Timer(const Duration(milliseconds: 500), () {
      //   Provider.of<TokenProvider>(context, listen: false).removeToken("");
      //   Provider.of<UserProvider>(context, listen: false).removeUser("");
      // });
      
      return Center(child: CircularProgressIndicator());
    }
  }
}