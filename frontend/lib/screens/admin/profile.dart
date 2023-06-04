import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/UI_parameters.dart' as UIParameter;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  final String userId;

  const Profile({super.key, required this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';
  String fullname = '';
  String email = '';
  String phone = '';
  String proofType = '';
  String proofNum = '';
  String proofPic = '';
  bool doneFetching = false;

  @override
  void initState() {
    super.initState();

    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      String url =
          "http://127.0.0.1:8000/get-one-user-using-id/${widget.userId}/";
      final response = await json.decode((await http.get(Uri.parse(url))).body);

      username = response["username"];
      fullname =
          "${response['first_name']} ${response['middle_initial']} ${response['last_name']} ${response['suffix']}";
      email = response["email"];
      phone = response["phone_no"];
      proofType = response["id_type"];
      proofNum = response["id_number"];
      proofPic = response["id_picture"];

      setState(() {
        doneFetching = true;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!doneFetching) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIParameter.MAROON,
        title: Text("$username's Profile"),
      ),
      body: buildPanel(),
    );
  }

  SingleChildScrollView buildPanel() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: UIParameter.CREAM,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 380,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: ListView(
                    children: [
                      buildInfo(),
                      Divider(
                        color: Colors.black,
                      ),
                      buildProof()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Text buildInfo() {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
              text: "Name: ", style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "$fullname\n"),
          const TextSpan(
              text: "Email: ", style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "$email\n"),
          const TextSpan(
              text: "Phone No: ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "$phone\n"),
        ],
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Column buildProof() {
    return Column(
      children: [
        Row(
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                      text: "ID Type: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "$proofType\n"),
                  const TextSpan(
                      text: "ID No: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "$proofNum\n"),
                  const TextSpan(
                      text: "ID Picture: \n",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        Image.memory(Uri.parse(proofPic).data!.contentAsBytes())
      ],
    );
  }
}
