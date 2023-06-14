import 'package:flutter/material.dart';
import '../../classes.dart';
import '../../UI_parameters.dart' as UIParameter;
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
// import 'package:stals_frontend/providers/token_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:stals_frontend/screens/homepage.dart';

// COMPONENTS
import '../../components/accom_card.dart';

class ViewOwnedAccomms extends StatefulWidget {
  const ViewOwnedAccomms({Key? key}) : super(key: key);

  @override
  _ViewOwnedAccommsState createState() => _ViewOwnedAccommsState();
}

class _ViewOwnedAccommsState extends State<ViewOwnedAccomms> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<AccomCardDetails>>? _accommodationsFuture;

  List<dynamic> user = [];
  String id = '';
  String email = '';
  String username = '';
  String user_type = '';

  @override
  void initState() {
    super.initState();
    _accommodationsFuture = fetchOwnedAccommodations();
  }

  Future<void> getUserInfo() async {
    user = Provider.of<UserProvider>(context, listen: false).userInfo;
    id = user[0];
    email = user[1];
    username = user[2];
    user_type = user[3];
  }

  Future<List<AccomCardDetails>> fetchOwnedAccommodations() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/view-all-establishment/'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      List<AccomCardDetails> accommodations = jsonResponse
          .map((accommodation) => AccomCardDetails.fromJson(accommodation))
          .toList();

      // Apply the filter
      List<AccomCardDetails> filteredAccommodations = accommodations
          .where((accommodation) =>
              accommodation.owner == id) // && accommodation.verified)
          .toList();

      return filteredAccommodations;
    } else {
      throw Exception('Failed to load accommodations');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<UserProvider>().isOwner) {
      //Navigator.pop(context);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });

      return const CircularProgressIndicator();
    }
    // var accom = AccomCardDetails("jk23fvgw23", "Centtro Residences",
    //     "Example Description", "assets/images/room_stock.jpg", 3, true, false);
    getUserInfo();

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: UIParameter.WHITE,
          elevation: 0,
          // hamburger icon for profile
          // opens left drawer on tap
          leading: IconButton(
            icon: const Icon(Icons.menu),
            color: UIParameter.LIGHT_TEAL,
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
        ),
        // the left drawer
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: UIParameter.LIGHT_TEAL,
                  ),
                  child: const Text(''),
                ),
              ),
              // ListTile(
              //   title: const Text('Edit Accommodationomm'),
              //   onTap: () {
              //     // Update the state of the app.
              //     // ...
              //     Navigator.pushNamed(context, '/owned/accomm/edit');
              //   },
              // ),
              ListTile(
                title: const Text('Add Accommodation'),
                onTap: () {
                  // Update the state of the app.
                  Navigator.pushNamed(context, '/add_accommodation');
                },
              ),
              ListTile(
                title: const Text('Logout'),
                trailing: const Icon(Icons.logout),
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
              )
            ],
          ),
        ),
        // the right drawer
        body: SingleChildScrollView(
          child: FutureBuilder<List<AccomCardDetails>>(
            future: _accommodationsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                print("RAN");
                List<AccomCardDetails> accommodations = snapshot.data!;
                // print(accommodations[0].getImage());
                return Center(
                    child: ConstrainedBox(
                        constraints: new BoxConstraints(maxWidth: 550),
                        child: FittedBox(
                            child: Column(
                          children: accommodations.map((accommodation) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 15),
                              child: AccomCard(details: accommodation),
                            );
                          }).toList(),
                        ))));
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20)),
                        Image.asset(
                          'assets/images/no_archived.png',
                          height: 70,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Text("No establishments added yet")
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return Center(
                child:
                    CircularProgressIndicator(), // Or any loading indicator widget
              );
            },
          ),
        ));
  }
}
