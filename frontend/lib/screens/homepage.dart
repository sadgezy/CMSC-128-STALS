import 'package:flutter/material.dart';
import '../classes.dart';
import '../UI_parameters.dart' as UIParameter;
// COMPONENTS
import '../components/accom_card.dart';
import '../components/search_bar.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
// import 'package:stals_frontend/providers/token_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class UnregisteredHomepage extends StatefulWidget {
  const UnregisteredHomepage({Key? key}) : super(key: key);

  @override
  _UnregisteredHomepageState createState() => _UnregisteredHomepageState();
}

class _UnregisteredHomepageState extends State<UnregisteredHomepage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<AccomCardDetails>>? _accommodationsFuture;

  @override
  void initState() {
    super.initState();
    _accommodationsFuture = fetchAllAccommodations();
  }

  Future<List<AccomCardDetails>> fetchAllAccommodations() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/view-all-establishment/'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
        List<AccomCardDetails> filteredAccommodations1 = jsonResponse
          .map((accommodation) => AccomCardDetails.fromJson(accommodation))
          .where((accommodation) => (accommodation.verified &&
              !accommodation
                  .archived)) // Only include accommodations marked false on verified and archived
          .toList();



      // Apply the filter
      return filteredAccommodations1;
    } else {
      throw Exception('Failed to load accommodations');
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
    DUMMY OBJECT
    <Object will come from database fetch later>
    */

    // var accom = AccomCardDetails("jk23fvgw23", "Centrro Residences", "6437e2f6fe3f89a27b315950",
    //     "Description of Centrro Residences", "assets/images/room_stock.jpg", 3,false,false);

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
          // search bar at the top of the homepage
          title: CustomSearchBar(
            hintText: 'Search',
            onChanged: (value) {
              /* PUT SEARCH FUNCTION HERE */
            },
          ),
          // filter icon for filtered search
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
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Routes'),
                        content: Container(
                          constraints: BoxConstraints(
                            minHeight: 200, //minimum height
                            minWidth: 100, // minimum width
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.65,
                            maxWidth: MediaQuery.of(context).size.width * 0.25,
                          ),
                          width: double.maxFinite,
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              TextButton(
                                child: Text('Signin Page'),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signin');
                                },
                              ),
                              TextButton(
                                child: Text('Sign Up'),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                              ),
                              TextButton(
                                child: Text('Sign Up Form'),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signup_info');
                                },
                              ),
                              TextButton(
                                child: Text('Verification Page'),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/verify_user');
                                },
                              ),
                              TextButton(
                                child: Text('Homepage'),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/homepage');
                                },
                              ),
                              TextButton(
                                child: Text('Registered Homepage'),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/signed_homepage');
                                },
                              ),
                              TextButton(
                                child: Text('Accomodation Page'),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/accomm');
                                },
                              ),
                              TextButton(
                                child: Text('Add Accom'),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/add_accommodation');
                                },
                              ),
                              TextButton(
                                child: Text('Admin Page'),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/admin');
                                },
                              ),
                              TextButton(
                                child: Text('View Owned Accom'),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/view_owned_accomms');
                                },
                              ),
                              TextButton(
                                child: Text('Owned Accom'),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/owned/accomm');
                                },
                              ),
                              TextButton(
                                child: Text('Edit Owned Accom'),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/owned/accomm/edit');
                                },
                              ),
                              TextButton(
                                child: Text('Admin View Users'),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/admin/view_users');
                                },
                              ),
                              TextButton(
                                child: Text('Admin View Accoms'),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/admin/view_accomms');
                                },
                              ),
                              ElevatedButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text('Page Routes'),
              ),
            ),
          ]),
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
            ListTile(
              title: const Text('Sign In'),
              onTap: () {
                Navigator.pushNamed(context, '/signin');
              },
            ),
            ListTile(
              title: const Text('Sign Up'),
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<AccomCardDetails>>(
          future: _accommodationsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // print("RAN");
              print(snapshot);
              List<AccomCardDetails> accommodations = snapshot.data!;
              print(accommodations);
              return Column(
                children: accommodations.map((accommodation) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: AccomCard(details: accommodation),
                  );
                }).toList(),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty || !snapshot.hasData) {
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
                      Text("No Accommodations in database ")
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
