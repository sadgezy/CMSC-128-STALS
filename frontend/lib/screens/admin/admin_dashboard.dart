import 'package:flutter/material.dart';
import '../../UI_parameters.dart' as UIParameter;
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
                //scaffoldKey.currentState!.closeDrawer();
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
            if (ModalRoute.of(context)?.settings.name != '/admin/view_users') {
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
            if (ModalRoute.of(context)?.settings.name != '/admin/view_accomms') {
              Navigator.pushNamed(context, '/admin/view_accomms');
            } else {
              Navigator.pop(context);
            }
          },
        ),
        ListTile(
          title: const Text('Reviews'),
          leading: const Icon(Icons.reviews),
          onTap: () {
            // TODO
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
          },
        ),
      ])),
      body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              color: UIParameter.WHITE,
              child: Center(
                  child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                      text: const TextSpan(
                          text: 'Hello, ',
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                        TextSpan(
                            text: 'Admin',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: "!"),
                      ])),
                ),
                const SizedBox(height: 20),
                const StatCard(
                    title: "Registered Users",
                    icon: Icons.person_outline_sharp,
                    value: 75),
                const SizedBox(height: 10),
                const StatCard(
                    title: "App Visits (Day)", icon: Icons.bar_chart, value: 7),
                const SizedBox(
                  height: 10,
                ),
                const StatCard(
                  title: "App Visits (Week)",
                  icon: Icons.bar_chart,
                  value: 75,
                )
              ])))),
    );
  }
}

// For cards
class StatCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final num value;
  const StatCard(
      {Key? key, required this.title, required this.icon, required this.value});

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      height: 100,
      color: UIParameter.LIGHT_TEAL,
      child: Row(children: [
        SizedBox(
            width: (MediaQuery.of(context).size.width - 40) / 3,
            child: Icon(
              widget.icon,
              size: 50,
              color: UIParameter.WHITE,
            )),
        SizedBox(
            width: (MediaQuery.of(context).size.width - 40) * 2 / 3,
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: UIParameter.WHITE,
                          fontSize: UIParameter.FONT_HEADING_SIZE,
                          fontFamily: UIParameter.FONT_REGULAR,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${widget.value}",
                      style: TextStyle(
                          color: UIParameter.WHITE,
                          fontSize: UIParameter.FONT_HEADING_SIZE,
                          fontFamily: UIParameter.FONT_REGULAR,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                )))
      ]),
    );
  }
}
