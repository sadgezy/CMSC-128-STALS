import 'package:flutter/material.dart';
import '../classes.dart';
import '../UI_parameters.dart' as UIParameter;
// COMPONENTS
import '../components/accom_card.dart';
import '../components/search_bar.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
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
  Filter accomFilter = Filter(null, null, null, null, null, null);
  String searchVal = '';
  bool fetchedAll = false;

  @override
  void initState() {
    super.initState();
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

      fetchedAll = true;
      // Apply the filter
      return filteredAccommodations1;
    } else {
      throw Exception('Failed to load accommodations');
    }
  }

  List<dynamic> accommList = [];

  @override
  Widget build(BuildContext context) {
    if (!fetchedAll) {
      _accommodationsFuture = fetchAllAccommodations();
      accommList.clear();
      //print("HEU");
    }
    /*
    DUMMY OBJECT
    <Object will come from database fetch later>
    */

    // var accom = AccomCardDetails("jk23fvgw23", "Centrro Residences", "6437e2f6fe3f89a27b315950",
    //     "Description of Centrro Residences", "assets/images/room_stock.jpg", 3,false,false);

    var filterTitleList = [];
    var filterValueList = [];
    var filterRaw = accomFilter.getFiltersApplied();
    for (int i = 0; i < filterRaw.length; i++) {
      filterValueList.add(filterRaw[i][0]);
      filterTitleList.add(filterRaw[i][1]);
    }

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
            title: Row(
              children: [
                Expanded(
                  flex: 16,
                  child: CustomSearchBar(
                    hintText: 'Search',
                    onChanged: (value) {
                      /* PUT SEARCH FUNCTION HERE */
                      searchVal = value;
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                Expanded(
                    flex: 2,
                    child: IconButton(
                        onPressed: () async {
                          // print(searchVal);
                          // print(filterTitleList);
                          // print(filterValueList);

                          String url =
                              "http://127.0.0.1:8000/search-establishment/";
                          final response = await json
                              .decode((await http.post(Uri.parse(url), body: {
                            'name': searchVal,
                            'location_exact': filterValueList[1] ?? "",
                            //'location_approx': args.middleName,
                            'establishment_type': filterValueList[2] ?? "",
                            'tenant_type': filterValueList[3] ?? "",
                            'price_lower': filterValueList[4] == null
                                ? ""
                                : "int(${filterValueList[4]})",
                            'price_upper': filterValueList[5] == null
                                ? ""
                                : "int(${filterValueList[5]})",
                            //'capacity': args.userType,
                          }))
                                  .body);
                          //print(response);

                          setState(() {
                            // for (int i = 0; i < response.length; i++) {
                            //   accommList.add(response[i]);
                            // }
                            accommList = response;
                          });
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )))
              ],
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("Login to filter the accommodations!")));
                    },
                  );
                },
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10))
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return AlertDialog(
              //             title: Text('Routes'),
              //             content: Container(
              //               constraints: BoxConstraints(
              //                 minHeight: 200, //minimum height
              //                 minWidth: 100, // minimum width
              //                 maxHeight:
              //                     MediaQuery.of(context).size.height * 0.65,
              //                 maxWidth: MediaQuery.of(context).size.width * 0.25,
              //               ),
              //               width: double.maxFinite,
              //               child: ListView(
              //                 shrinkWrap: true,
              //                 children: <Widget>[
              //                   TextButton(
              //                     child: Text('Signin Page'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(context, '/signin');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Sign Up'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(context, '/signup');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Sign Up Form'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(context, '/signup_info');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Verification Page'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(context, '/verify_user');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Homepage'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(context, '/homepage');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Registered Homepage'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(
              //                           context, '/signed_homepage');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Accomodation Page'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(context, '/accomm');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Add Accom'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(
              //                           context, '/add_accommodation');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Admin Page'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(context, '/admin');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('View Owned Accom'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(
              //                           context, '/view_owned_accomms');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Owned Accom'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(context, '/owned/accomm');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Edit Owned Accom'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(
              //                           context, '/owned/accomm/edit');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Admin View Users'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(
              //                           context, '/admin/view_users');
              //                     },
              //                   ),
              //                   TextButton(
              //                     child: Text('Admin View Accoms'),
              //                     onPressed: () {
              //                       Navigator.pushNamed(
              //                           context, '/admin/view_accomms');
              //                     },
              //                   ),
              //                   ElevatedButton(
              //                     child: Text('Close'),
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     },
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           );
              //         },
              //       );
              //     },
              //     child: Text('Page Routes'),
              //   ),
              // ),
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
            child: Center(
                child: ConstrainedBox(
                    constraints: new BoxConstraints(maxWidth: 550),
                    child: FittedBox(
                      child: Column(
                        children: [
                          if (!fetchedAll)
                            SingleChildScrollView(
                              child: FutureBuilder<List<AccomCardDetails>>(
                                future: _accommodationsFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    // print("RAN");
                                    //print(snapshot);
                                    List<AccomCardDetails> accommodations =
                                        snapshot.data!;
                                    //print(accommodations);
                                    return Column(
                                      children:
                                          accommodations.map((accommodation) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7, horizontal: 15),
                                          child:
                                              AccomCard(details: accommodation),
                                        );
                                      }).toList(),
                                    );
                                  } else if (snapshot.hasData &&
                                          snapshot.data!.isEmpty ||
                                      !snapshot.hasData) {
                                    return Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          children: [
                                            const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20)),
                                            Image.asset(
                                              'assets/images/no_archived.png',
                                              height: 70,
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10)),
                                            Text(
                                                "No Accommodations Available! ")
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
                          if (fetchedAll)
                            SingleChildScrollView(
                              child: Column(
                                children: accommList.map((accommodation) {
                                  //print(accommodation);
                                  //print(accommodation["name"]);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 15),
                                    child: AccomCard(
                                        details: AccomCardDetails(
                                            accommodation["_id"],
                                            accommodation["name"],
                                            accommodation["owner"],
                                            accommodation["description"],
                                            accommodation["loc_picture"],
                                            4.0,
                                            accommodation["archived"],
                                            accommodation["verified"])),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    )))));
  }
}
