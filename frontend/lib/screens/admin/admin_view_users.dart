import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
//import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:stals_frontend/UI_parameters.dart' as UIParameter;
import 'package:stals_frontend/screens/admin/admin_viewusers_card.dart';
import 'package:stals_frontend/screens/homepage.dart';

import '../../models/user_model.dart';

class ViewUsersPage extends StatefulWidget {
  const ViewUsersPage({super.key});
  @override
  State<ViewUsersPage> createState() => _ViewAllUsersPageState();
  
}

class _ViewAllUsersPageState extends State<ViewUsersPage> {


  List<User> allUnverifiedUsersList = [];

  List<User> allVerifiedUsersList = [];
  List<User> allArchivedUsersList = [];


  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool isLoading = false;

  
  String apiUrl_allUnverifiedUsers =
      'http://127.0.0.1:8000/view-all-unverified-users/';

  String apiUrl_allVerifiedUsers =
      'http://127.0.0.1:8000/view-all-modifVerified-users/';

  String apiUrl_allArchivedUsers =
      'http://127.0.0.1:8000/view-all-modifArchived-users/';

  //----
  @override
  void initState() {
    super.initState();
    // fetchAllUsers();
    fetchAllUnverifiedUsers();
    fetchAllVerifiedUsers();
    fetchAllArchivedUsers();
  }


  // ---
  void onTabChosen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //---------------------------------------------
  Future<void> fetchAllVerifiedUsers() async {
    try {
      Response response = await Dio().get(apiUrl_allVerifiedUsers);
      // Dio dio = new Dio();
      // dio.options.headers["Authorization"] = 'Token ${Provider.of<TokenProvider>(context, listen: false).currToken}';
      // Response response = await dio.get(apiUrl);
      //print(response.data);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        //print(data);

        List<User> fetchedVerifiedUsers =
            data.map((user) => User.fromJson(user)).toList();
        
        fetchedVerifiedUsers = fetchedVerifiedUsers
          .where((user) =>
              user.userType != "Admin") // && accommodation.verified)
          .toList();

        setState(() {

          allVerifiedUsersList = fetchedVerifiedUsers;
        });
      }
    } catch (error) {
      print(error.toString());
    }
 
  }
  
  //---------------------------------------------
  Future<void> fetchAllUnverifiedUsers() async {
    try {
      Response response = await Dio().get(apiUrl_allUnverifiedUsers);
      //print(response.data);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        //print(data);

        
        List<User> fetchAllUnverifiedUsers =
            data.map((user) => User.fromJson(user)).toList();
        
        // Apply the filter
        fetchAllUnverifiedUsers = fetchAllUnverifiedUsers
          .where((user) =>
              user.userType != "Admin") // && accommodation.verified)
          .toList();

        setState(() {
          allUnverifiedUsersList = fetchAllUnverifiedUsers;
        });
      }
    } catch (error) {
      print(error.toString());
    }
  
  }

  //---------------------------------------------
  Future<void> fetchAllArchivedUsers() async {
    try {
      Response response = await Dio().get(apiUrl_allArchivedUsers);
      //print(response.data);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        //print(data);

        List<User> fetchedArchivedUsers =
            data.map((user) => User.fromJson(user)).toList();

        fetchedArchivedUsers = fetchedArchivedUsers
          .where((user) =>
              user.userType != "Admin") // && accommodation.verified)
          .toList();

        setState(() {
          allArchivedUsersList = fetchedArchivedUsers;
        });
      }
    } catch (error) {
      print(error.toString());
    }
    
    //initState();
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (!context.watch<UserProvider>().isAdmin) {
      //Navigator.pop(context);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });

      return const CircularProgressIndicator();
    }
    return MaterialApp(
      
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: UIParameter.MAROON,
            elevation: 0,
            // hamburger icon for profile
            // opens left drawer on tap
            leading: IconButton(
              icon: const Icon(Icons.menu),
              color: UIParameter.WHITE,
              onPressed: () {
                if (scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.closeDrawer();
                  //close drawer, if drawer is open
                } else {
                  scaffoldKey.currentState!.openDrawer();
                  //open drawer, if drawer is closed
                }
              },
            ),
            actions: <Widget>[
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.filter_alt),
                    color: UIParameter.MAROON,
                    onPressed: () {
                      // cannot use filter if not signed-in
                    },
                  );
                },
              )
            ]),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name != '/admin') {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin');
              } else {
                scaffoldKey.currentState!.closeDrawer();
              }
            },
          ),
          ListTile(
            title: const Text('Users'),
            leading: const Icon(Icons.account_box),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name !=
                  '/admin/view_users') {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin/view_users');
              } else {
                scaffoldKey.currentState!.closeDrawer();
              }
            },
          ),
          ListTile(
            title: const Text('Accommodations'),
            leading: const Icon(Icons.apartment),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name !=
                  '/admin/view_accomms') {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin/view_accomms');
              } else {
                scaffoldKey.currentState!.closeDrawer();
              }
            },
          ),
          ListTile(
            title: const Text('Reports'),
            leading: const Icon(Icons.flag),
            onTap: () {
              // TODO
              if (ModalRoute.of(context)?.settings.name !=
                '/admin/view_reports') {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/view_reports');
            } else {
              scaffoldKey.currentState!.closeDrawer();
            }
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () async {
              await Provider.of<TokenProvider>(context, listen: false)
                  .removeToken("DO NOT REMOVE THIS PARAM");
              await Provider.of<UserProvider>(context, listen: false)
                  .removeUser("DO NOT REMOVE THIS PARAM");

              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UnregisteredHomepage()));
            },
          ),
        ])),
          key: scaffoldKey,
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(20),
                      color: UIParameter.CREAM,
                      child: Center(


                          child: (_selectedIndex == 0)
                              ? ListView.builder(
                                  itemCount: allUnverifiedUsersList.length,
                                  itemBuilder: (context, index) {
                                    return Column(children: [
                                      //--------------------------------------------------
                                      
                                      PendingUserCard(
                                          name:
                                              '${allUnverifiedUsersList[index].firstName} ${allUnverifiedUsersList[index].lastName}',
                                          userId: '${allUnverifiedUsersList[index].id}',
                                          fetchUnverifiedUsers: fetchAllUnverifiedUsers,
                                                                                  
                                                  
                                      ),
                                          
                                      //--------------------------------------------------
                                      const SizedBox(height: 10)
                                    ]);
                                  },
                                )


                              : (_selectedIndex == 1)
                                  ? ListView.builder(
                                  itemCount: allVerifiedUsersList.length,
                                  itemBuilder: (context, index) {
                                    return Column(children: [
                                      //--------------------------------------------------
                                      VerifiedUserCard(
                                          name:
                                              '${allVerifiedUsersList[index].firstName} ${allVerifiedUsersList[index].lastName}',
                                          userId: '${allVerifiedUsersList[index].id}',
                                          fetchVerifiedUsers: fetchAllVerifiedUsers,
                                        ),
                                      
                                      //--------------------------------------------------
                                      const SizedBox(height: 10)
                                    ]);
                                  },
                                )

                              : (_selectedIndex == 2)                   //adjust later
                                            ? ListView.builder(
                                                itemCount: allArchivedUsersList.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      //--------------------------------------------------
                                                      ArchiveUserCard(
                                                        name:
                                                            '${allArchivedUsersList[index].firstName} ${allArchivedUsersList[index].lastName}',
                                                        userId: '${allArchivedUsersList[index].id}',
                                                        fetchArchivedUsers: fetchAllArchivedUsers,
                                                    
                                                      ),
                                                      //--------------------------------------------------
                                                      const SizedBox(height: 10),
                                                    ],
                                                  );
                                                },
                                              )
                                : Container(),
          ),
        ),
      ),
          
          
          bottomNavigationBar: BottomNavigationBar(
              // onTap: onTabChosen,
              onTap: (index) async {
                setState(() {
                  _selectedIndex = index;
                });

                if (index == 0) {
                  await fetchAllUnverifiedUsers();
                } else if (index == 1) {
                  await fetchAllVerifiedUsers();
                } else if (index == 2) {
                  await fetchAllArchivedUsers();
                }
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_add_outlined), label: "Pending"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people), label: "Approved"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: "Archived")
              ],
              selectedItemColor: UIParameter.DARK_TEAL,
              currentIndex: _selectedIndex)),
    );
    
  }

}