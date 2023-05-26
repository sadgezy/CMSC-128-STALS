import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../../models/user_model.dart';

class ViewUsersPage extends StatefulWidget {
  const ViewUsersPage({super.key});
  @override
  State<ViewUsersPage> createState() => _ViewUsersPageState();
}


class _ViewUsersPageState extends State<ViewUsersPage> {

  List<User> users = [];
  bool isLoading = false;
  String apiUrl = 'http://127.0.0.1:8000/view-all-users/';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      Dio dio = new Dio();
      dio.options.headers["Authorization"] = 'Token ${Provider.of<TokenProvider>(context, listen: false).currToken}';
      Response response = await dio.get(apiUrl);
      print(response.data);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print(data);

        List<User> fetchedUsers =
            data.map((user) => User.fromJson(user)).toList();
        setState(() {
          users = fetchedUsers;
        });
      }
    } catch (error) {
      print(error.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  

  int selectedIndex = 0;

  // @override
  // Widget build(BuildContext context) {
    
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: Container(
  //       width: 460,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         border: Border.all(),
  //         borderRadius: BorderRadius.circular(18),
  //         boxShadow: const [
  //           BoxShadow(
  //             color: Colors.black12,
  //             blurRadius: 3.0,
  //             offset: Offset(0, -5.0),
  //           ),
  //         ],
  //       ),
  //       child: ListView.builder(
  //         itemCount: users.length,
  //         itemBuilder: ((context, index) {
  //           // var user = users[index];
  //           return ListTile(
  //             onTap: () {},
  //             leading: Icon(Icons.person),
  //             title: Text("${users[index]}"),
  //             trailing: ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                   shape: const StadiumBorder(),
  //                   backgroundColor: Color.fromRGBO(212, 57, 65, 1),
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 26, vertical: 13),
  //                   textStyle: const TextStyle(fontSize: 12)),
  //               onPressed: () {},
  //               child: null,
  //             ),
  //           );
  //         }),
  //       ),
  //     ),

  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Users List'),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {


                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      '${users[index].firstName} ${users[index].lastName}\n'
                      '${users[index].userType}',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username: ${users[index].username}'),
                        Text('Email: ${users[index].email}'),
                        Text('Verified: ${users[index].verified}'),
                        Text('Archived: ${users[index].archived}'),
                      ],
                    ),
                  );

                },
              ),
      ),
    );
  }

}
