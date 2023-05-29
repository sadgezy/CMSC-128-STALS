import 'package:flutter/material.dart';
import '../../UI_parameters.dart' as UIParameter;
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';

class ViewUserCardsTest extends StatefulWidget {
  const ViewUserCardsTest({super.key});

  @override
  State<ViewUserCardsTest> createState() => _ViewUserCardsTestState();
}

class _ViewUserCardsTestState extends State<ViewUserCardsTest> {
  int _selectedIndex = 0;

  void onTabChosen(int index) {
    setState(() {});
  }

  final List<Widget> _children = [
    // AdminDashBoard(),
    // AdminViewPendingApproved(),
    // ViewArchivedAccommodations(),
  ];

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
            if (ModalRoute.of(context)?.settings.name !=
                '/admin/view_accomms') {
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

            Navigator.pushNamed(context, '/signin');
          },
        ),
      ])),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            color: UIParameter.CREAM,
            child: const Center(
              child: Column(children: [UserCard(name: "John Doe")]),
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabChosen,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.person_add_outlined), label: "Pending"),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: "Approved"),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive), label: "Archived")
          ],
          selectedItemColor: UIParameter.DARK_TEAL,
          currentIndex: _selectedIndex)
    );
  }
}

class UserCard extends StatefulWidget {
  final String name;
  // TODO: image
  const UserCard({super.key, required this.name});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: UIParameter.WHITE,
            borderRadius: UIParameter.CARD_BORDER_RADIUS),
        width: (MediaQuery.of(context).size.width),
        height: 58,
        child: Row(children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width - 40) / 7,
            child: const Icon(Icons.person_pin_sharp,
                size: 34, color: Colors.black87),
          ),
          SizedBox(
              width: (MediaQuery.of(context).size.width - 40) * 2 / 7,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("John Doe",
                            style: TextStyle(
                                fontSize: UIParameter.FONT_HEADING_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR,
                                fontWeight: FontWeight.w600))),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tap to know more",
                            style: TextStyle(
                                fontSize: UIParameter.FONT_BODY_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR)))
                  ],
                ),
              )),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 40) * 4 / 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: UIParameter.DARK_TEAL,
                        borderRadius: UIParameter.CARD_BORDER_RADIUS),
                    width: 71.17,
                    height: 21,
                    child: Align(
                        child: Text("APPROVE",
                            style: TextStyle(
                                color: UIParameter.WHITE,
                                fontSize: UIParameter.FONT_BODY_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR,
                                fontWeight: FontWeight.w600)))),
                const SizedBox(width: 10),
                Container(
                    decoration: BoxDecoration(
                        color: UIParameter.MAROON,
                        borderRadius: UIParameter.CARD_BORDER_RADIUS),
                    width: 71.17,
                    height: 21,
                    child: Align(
                        child: Text("DELETE",
                            style: TextStyle(
                                color: UIParameter.WHITE,
                                fontSize: UIParameter.FONT_BODY_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR,
                                fontWeight: FontWeight.w600)))),
                const SizedBox(width: 10)
              ],
            ),
          ),
        ]));
  }
}
