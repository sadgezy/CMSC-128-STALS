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
      List<AccomCardDetails> accommodations = jsonResponse
          .map((accommodation) => AccomCardDetails.fromJson(accommodation))
          .toList();

      // Apply the filter
      return accommodations;
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
            )
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
            if (snapshot.hasData) {
              print("RAN");
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
