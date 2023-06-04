import 'package:flutter/material.dart';
import 'package:stals_frontend/screens/admin/admin_dashboard.dart';
import 'package:stals_frontend/screens/admin/admin_view_pending_approved.dart';
import 'package:stals_frontend/screens/admin/admin_view_archived.dart';
import '../../UI_parameters.dart' as UIParameter;
import '../homepage.dart';
import '../registered_user/homepage_signed.dart';


import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';

class AdminViewAccommodations extends StatefulWidget {
  const AdminViewAccommodations({Key? key}) : super(key: key);

  @override
  _AdminViewAccommodationsState createState() =>
      _AdminViewAccommodationsState();
}

class _AdminViewAccommodationsState extends State<AdminViewAccommodations> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1;

  final List<Widget> _children = [
    //AdminDashBoard(),
    AdminViewPendingApproved(),
    ViewArchivedAccommodations(),
  ];

  void onTabChosen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //check if admin
    if (!context.watch<UserProvider>().isAdmin) {
      //Navigator.pop(context);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });

      return const CircularProgressIndicator();
    }

    return Scaffold(
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
            onTap: () {
              // TODO
              Provider.of<TokenProvider>(context, listen: false)
                  .removeToken("DO NOT REMOVE THIS PARAM");
              Provider.of<UserProvider>(context, listen: false)
                  .removeUser("DO NOT REMOVE THIS PARAM");

              scaffoldKey.currentState!.closeDrawer();
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pop(context);
              //Navigator.push(context, MaterialPageRoute(builder: (context) => const UnregisteredHomepage()));
              Navigator.pushNamed(context, '/homepage');
            },
          ),
        ])),
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabChosen,
        backgroundColor: UIParameter.WHITE,
        items: const <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.arrow_back_outlined), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.house), label: "Accommodations"),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archived"),
        ],
        selectedItemColor: Color(0xff19535F),
        currentIndex: _selectedIndex,
        selectedIconTheme: IconThemeData(opacity: 0.0, size: 0),
        unselectedIconTheme: IconThemeData(opacity: 0.0, size: 0),
      ),
    );
  }
}
