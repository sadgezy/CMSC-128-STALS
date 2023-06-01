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

import '../../models/user_model.dart';

class ViewReportsPage extends StatefulWidget {
  const ViewReportsPage({super.key});
  @override
  State<ViewReportsPage> createState() => _ViewReportsPageState();
}

class _ViewReportsPageState extends State<ViewReportsPage> {
  List allTickets = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAllTickets();
  }

  void onTabChosen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //---------------------------------------------
  Future<void> fetchAllTickets() async {
    try {
      String url1 = "http://127.0.0.1:8000/ticket-details/";
      final response = await http.get(Uri.parse(url1));
      var responseData = json.decode(response.body);

      setState(() {
        allTickets = responseData;
      });
      print(responseData);
    } catch (error) {
      print(error.toString());
    }

    // initState();

    //initState();
    setState(() {
      isLoading = false;
    });
  }

  final List<Widget> _children = [
    // AdminDashBoard(),
    // AdminViewPendingApproved(),
    // ViewArchivedAccommodations(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
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
                Navigator.pushNamed(context, '/admin');
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            title: const Text('Users'),
            leading: const Icon(Icons.account_box),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name !=
                  '/admin/view_users') {
                Navigator.pushNamed(context, '/admin/view_users');
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            title: const Text('Accommodations'),
            leading: const Icon(Icons.apartment),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name !=
                  '/admin/view_accomms') {
                Navigator.pushNamed(context, '/admin/view_accomms');
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            title: const Text('Reports'),
            leading: const Icon(Icons.flag),
            onTap: () {
              // TODO
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              // TODO
              Provider.of<TokenProvider>(context, listen: false)
                  .removeToken("DO NOT REMOVE THIS PARAM");
              Provider.of<UserProvider>(context, listen: false)
                  .removeUser("DO NOT REMOVE THIS PARAM");

              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ])),
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
                      child: ListView.builder(
                    itemCount: allTickets.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        //--------------------------------------------------
                        TicketCard(
                          name: '${allTickets[index]["description"]}',
                          ticketId: '${allTickets[index]["_id"]}',
                          resolved: allTickets[index]["resolved"],
                          fetchAllTickets: fetchAllTickets,
                        ),

                        //--------------------------------------------------
                        const SizedBox(height: 10)
                      ]);
                    },
                  )),
                ),
              ),
      ),
    );
  }
}
