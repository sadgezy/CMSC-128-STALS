import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
//import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../../models/user_model.dart';

class ViewUsersPage extends StatefulWidget {
  const ViewUsersPage({super.key});
  @override
  State<ViewUsersPage> createState() => _ViewAllUsersPageState();
}

class _ViewAllUsersPageState extends State<ViewUsersPage> {
  List<User> allUsersList = [];
  List<User> allVerifiedUsersList = []; 
  List<User> allUnverifiedUsersList = [];
  List<User> allArchivedUsersList = [];

  bool isLoading = false;
  String apiUrl_allUsers = 'http://127.0.0.1:8000/view-all-users/';
  String apiUrl_allVerifiedUsers = 'http://127.0.0.1:8000/view-all-verified-users/';
  String apiUrl_allUnverifiedUsers = 'http://127.0.0.1:8000/view-all-unverified-users/';
  String apiUrl_allArchivedUsers = 'http://127.0.0.1:8000/view-all-archived-users/';

  //----
  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      Response response = await Dio().get(apiUrl_allUsers);
      print(response.data);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        //print(data);

        List<User> fetchedUsers =
            data.map((user) => User.fromJson(user)).toList();

        setState(() {
          allUsersList = fetchedUsers;
        });
      }
    } catch (error) {
      print(error.toString());
    }

    fetchAllVerifiedUsers();
  }

  //---------------------------------------------
  Future<void> fetchAllVerifiedUsers() async {

    try {
      Response response = await Dio().get(apiUrl_allVerifiedUsers);
      // Dio dio = new Dio();
      // dio.options.headers["Authorization"] = 'Token ${Provider.of<TokenProvider>(context, listen: false).currToken}';
      // Response response = await dio.get(apiUrl);
      print(response.data);
      

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print(data);

        List<User> fetchedVerifiedUsers =
            data.map((user) => User.fromJson(user)).toList();

        setState(() {
          allVerifiedUsersList = fetchedVerifiedUsers;
        });
      }
    } catch (error) {
      print(error.toString());
    }

    fetchAllUnverifiedUsers();
  }

  //---------------------------------------------
  Future<void> fetchAllUnverifiedUsers() async {

    try {
      Response response = await Dio().get(apiUrl_allUnverifiedUsers);
      print(response.data);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print(data);

        List<User> fetchAllUnverifiedUsers =
            data.map((user) => User.fromJson(user)).toList();

        setState(() {
          allUnverifiedUsersList = fetchAllUnverifiedUsers;
        });
      }
    } catch (error) {
      print(error.toString());
    }



    fetchAllArchivedUsers();
  }


 //---------------------------------------------
  Future<void> fetchAllArchivedUsers() async {

    try {
      Response response = await Dio().get(apiUrl_allArchivedUsers);
      print(response.data);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print(data);

        List<User> fetchedArchivedUsers =
            data.map((user) => User.fromJson(user)).toList();

        setState(() {
          allArchivedUsersList = fetchedArchivedUsers;
        });
      }
    } catch (error) {
      print(error.toString());
    }

    setState(() {
      isLoading = false;
    });

  } 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Users List'),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [


                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'All User List',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: allUsersList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.person),
                          title: Text(
                            '${allUsersList[index].firstName} ${allUsersList[index].lastName}\n'
                            '${allUsersList[index].userType}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Username: ${allUsersList[index].username}'),
                              Text('Email: ${allUsersList[index].email}'),
                              Text('Verified: ${allUsersList[index].verified}'),
                              Text('Archived: ${allUsersList[index].archived}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'All Verified User List',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: allVerifiedUsersList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.accessibility),
                          title: Text(
                            '${allVerifiedUsersList[index].firstName} ${allVerifiedUsersList[index].lastName}\n'
                            '${allVerifiedUsersList[index].userType}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Username: ${allVerifiedUsersList[index].username}'),
                              Text('Email: ${allVerifiedUsersList[index].email}'),
                              Text('Verified: ${allVerifiedUsersList[index].verified}'),
                              Text('Archived: ${allVerifiedUsersList[index].archived}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'All Unverified User List',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: allUnverifiedUsersList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.accessibility_new_outlined),
                          title: Text(
                            '${allUnverifiedUsersList[index].firstName} ${allUnverifiedUsersList[index].lastName}\n'
                            '${allUnverifiedUsersList[index].userType}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Username: ${allUnverifiedUsersList[index].username}'),
                              Text('Email: ${allUnverifiedUsersList[index].email}'),
                              Text('Verified: ${allUnverifiedUsersList[index].verified}'),
                              Text('Archived: ${allUnverifiedUsersList[index].archived}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'All Archived User List',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: allArchivedUsersList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.accessibility),
                          title: Text(
                            '${allArchivedUsersList[index].firstName} ${allArchivedUsersList[index].lastName}\n'
                            '${allArchivedUsersList[index].userType}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Username: ${allArchivedUsersList[index].username}'),
                              Text('Email: ${allArchivedUsersList[index].email}'),
                              Text('Verified: ${allArchivedUsersList[index].verified}'),
                              Text('Archived: ${allArchivedUsersList[index].archived}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),



                ],
              ),
      ),
    );
  }
  





// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         title: Text('Users List'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Users List',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: allUsersList.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: Icon(Icons.person),
//                   title: Text(
//                     '${allUsersList[index].firstName} ${allUsersList[index].lastName}\n'
//                     '${allUsersList[index].userType}',
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Username: ${allUsersList[index].username}'),
//                       Text('Email: ${allUsersList[index].email}'),
//                       Text('Verified: ${allUsersList[index].verified}'),
//                       Text('Archived: ${allUsersList[index].archived}'),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),


//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text(
//                 'Sidebar',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),


//             ListTile(
//               title: Text('View All'),
//               onTap: () {
//                 setState(() {
//                   allUsersList = allUsersList;
//                 });
//                 Navigator.pop(context);
//               },
//             ),


//             // ListTile(
//             //   title: Text('View Verified'),
//             //   onTap: () {
//             //     setState(() {
//             //       allUsersList = allVerifiedUsersList;
//             //     });
//             //     Navigator.pop(context);
//             //   },
//             // ),

//             // ListTile(
//             //   title: Text('View Verified'),
//             //   onTap: () {
//             //     Navigator.pop(context);
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (context) => VerifiedUsersScreen(allVerifiedUsersList),
//             //       ),
//             //     );
//             //   },
//             // ),



//             // ListTile(
//             //   title: Text('View Unverified'),
//             //   onTap: () {
//             //     setState(() {
//             //       allUsersList = allUnverifiedUsersList;
//             //     });
//             //     Navigator.pop(context);
//             //   },
//             // ),


//             // ListTile(
//             //   title: Text('View Archived'),
//             //   onTap: () {
//             //     setState(() {
//             //       allUsersList = allArchivedUsersList;
//             //     });
//             //     Navigator.pop(context);
//             //   },
//             // ),
//           ],
//         ),
//       ),


//     ),
//   );
// }



}