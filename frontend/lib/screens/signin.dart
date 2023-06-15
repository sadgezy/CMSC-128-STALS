import 'package:flutter/material.dart';
import 'package:stals_frontend/screens/signup.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:stals_frontend/UI_parameters.dart' as UIParam;
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
            if (value!.isEmpty) {
              return 'This field cannot be empty!';
            }
            if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,7}$')
                .hasMatch(value)) {
              return 'Please enter a valid email address!';
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
          if (emailKey.currentState!.validate() &&
              passKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                showCloseIcon: true,
                closeIconColor: UIParam.WHITE,
                content: Text("Logging in...")));

            String url = "http://127.0.0.1:8000/login/";
            final response = await json.decode((await http.post(Uri.parse(url),
                    body: {
                  'email': emailController.text,
                  'password': passwordController.text
                }))
                .body);
            if (response['message'] == "Login Successful") {
              String token = response['token'];
              Provider.of<TokenProvider>(context, listen: false)
                  .setToken(token);
              setState(() {});
              String url = "http://127.0.0.1:8000/get-one-user/";
              final response2 =
                  await json.decode((await http.post(Uri.parse(url), body: {
                'email': emailController.text,
              }))
                      .body);
              //print(response2);
              user_type = response2[0]["user_type"];
              Provider.of<UserProvider>(context, listen: false).setUser(
                  response2[0]["_id"],
                  response2[0]["email"],
                  response2[0]["username"],
                  response2[0]["user_type"],
                  response2[0]["verified"],
                  response2[0]["rejected"]);

              String url3 = "http://127.0.0.1:8000/add-login-count/";
              final response3 = await http.get(Uri.parse(url3));

              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  showCloseIcon: true,
                  closeIconColor: UIParam.WHITE,
                  content: const Text("Logged in!")));
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Password is incorrect or account does not exist!")));
            }
          }

          if (user_type == "user") {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/signed_homepage');
          } else if (user_type == 'admin') {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin');
          } else if (user_type == 'owner') {
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
          signupButton,
          const Padding(padding: EdgeInsets.symmetric(vertical: 20))
        ],
      ),
    );

    if (Provider.of<TokenProvider>(context, listen: false).currToken == "") {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Leave a Review'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black,
            ),
          ),
          body: SingleChildScrollView(
              child: Center(
                  child: ConstrainedBox(
                      constraints: new BoxConstraints(maxWidth: 550.0),
                      child: Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 50)),
                          SizedBox(
                              child: Image.asset(
                                  'assets/images/stals_logo2.png',
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(
                                  left: 40.0, right: 40.0),
                              children: <Widget>[
                                // Image.asset('assets/images/stals_logo.png', fit: BoxFit.fill),
                                const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10)),
                                loginFields
                              ],
                            ),
                          ),
                        ],
                      )))));
    } else {
      // print(Provider.of<UserProvider>(context, listen: false).userInfo);
      // Timer(const Duration(milliseconds: 500), () {
      //   Provider.of<TokenProvider>(context, listen: false).removeToken("");
      //   Provider.of<UserProvider>(context, listen: false).removeUser("");
      // });

      return Center(
          child: CircularProgressIndicator(
        color: UIParam.MAROON,
      ));
    }
  }
}
