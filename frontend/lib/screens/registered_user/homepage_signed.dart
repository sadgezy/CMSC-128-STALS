import 'package:flutter/material.dart';
import '../../classes.dart';
import '../../UI_parameters.dart' as UIParameter;
import '../pdf/pdf_viewer.dart';
import 'favorites.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// COMPONENTS
import '../../components/accom_card.dart';
import '../../components/search_bar.dart';
import '../../components/filter_drawer.dart';

class RegisteredHomepage extends StatefulWidget {
  const RegisteredHomepage({Key? key}) : super(key: key);

  @override
  _RegisteredHomepageState createState() => _RegisteredHomepageState();
}

class _RegisteredHomepageState extends State<RegisteredHomepage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Filter accomFilter = Filter(null, null, null, null, null, null);
  String searchVal = '';
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

  // put data into a list. Will iterate over it to build cards
  List<dynamic> accommList = [];
  //List<dynamic> accommList = [{"_id":"jk23fvgw23", "name": "Centtro Residences", "location_exact": "LOCATION"}];
  /*
  a callback function that returns the filter(object) that the user chose
  Filter(
    rating;
    location;
    establishmentType;
    tenantType;
    minPrice; 
    maxPrice;
  )
   */
  void getFilter(Filter newFilter) {
    // print filter object for debug
    // print(
    //     "${newFilter.getRating()}\n${newFilter.getLocation()}\n${newFilter.getTenantType()}\n${newFilter.getEstablishmentType()}\n${newFilter.getMinPrice()}\n${newFilter.getMaxPrice()}\n");
    setState(() {
      accomFilter = newFilter;
    });
  }

  // this builds the filters shown on the homepage according to user/s filter choices/selections
  Widget _displayFilter(String filterValue, String filterTitle) {
    var isRating = false;
    var isMinPrice = false;
    var isMaxPrice = false;

    // if the filter is `rating'
    if (filterTitle == "Rating") {
      isRating = true;
      // if the filter is the min price
    } else if (filterTitle == "Min Price") {
      isMinPrice = true;
      // if the filter is the max price
    } else if (filterTitle == "Max Price") {
      isMaxPrice = true;
    }

    if (isRating) {
      // turn the rating into a single integet and make it into a string
      filterValue = ((double.parse(filterValue)).toInt()).toString();
    }
    if (isMinPrice) {
      // add MIN:
      filterValue = "MIN: $filterValue";
    }
    if (isMaxPrice) {
      // add MAX:
      filterValue = "MAX: $filterValue";
    }

    return UnconstrainedBox(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: UIParameter.LIGHT_TEAL,
        ),
        child: Row(
          children: [
            Text(
              filterValue,
              style: const TextStyle(
                  fontFamily: UIParameter.FONT_REGULAR,
                  fontSize: UIParameter.FONT_BODY_SIZE,
                  color: Colors.white),
            ),
            // if the filter is `rating` we will append a star icon to the text
            isRating
                ? const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  )
                : Container(),
            InkWell(
                /*
                allows user to remove/delete existing filters
                automatically updates the `Filter` of the homepage using setState which should also
                update the accommodations shown (reload accomms in homepage)
                */
                onTap: () {
                  Filter newFilter = Filter(
                      filterTitle == "Rating" ? null : accomFilter.getRating(),
                      filterTitle == "Location"
                          ? null
                          : accomFilter.getLocation(),
                      filterTitle == "Establishment Type"
                          ? null
                          : accomFilter.getEstablishmentType(),
                      filterTitle == "Tenant Type"
                          ? null
                          : accomFilter.getTenantType(),
                      filterTitle == "Min Price"
                          ? null
                          : accomFilter.getMinPrice(),
                      filterTitle == "Max Price"
                          ? null
                          : accomFilter.getMaxPrice());
                  setState(() {
                    accomFilter = newFilter;
                  });
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 16,
                )),
          ],
        ),
      ),
    );
  }

  /*
  TO-DO: GET LIST OF ACCOMMODATIONS FROM DATABASE AND FILTER ACCORDING TO `accomFilter`
  initally, the homepage `accomFilter` will all be set to null, meaning all accomms will be displayed since all filter parameters are null
  as user chooses his/her filter, `accomFilter` will be set to its new state according to the filter/s the user selected
  the setstate should trigger the accomms in the homepage to reload (display accomms that fit the new filter)
  */
  @override
  Widget build(BuildContext context) {
    /*
    DUMMY OBJECT
    <Object will come from database fetch later>
    */
    var accom = AccomCardDetails(
        "jk23fvgw23",
        "Centtro Residences",
        "6437e2f6fe3f89a27b315950",
        "Example Description",
        "assets/images/room_stock.jpg",
        3,
        false,
        true);
    var accom2 = AccomCardDetails(
        'test1234',
        'Casa Del Mar',
        "6437e2f6fe3f89a27b315950",
        'Casa Del Mar is located at Sapphire street.',
        "assets/images/room_stock.jpg",
        5,
        true,
        false);

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
                      print(response);

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
                    )),
              )
            ],
          ),
          // filter icon for filtered search
          // opens right drawer on tap
          // thinking to implement yung katulad ng filter sa shoppee?
          actions: <Widget>[
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.filter_alt),
                  color: UIParameter.MAROON,
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.save_alt),
                  color: UIParameter.MAROON,
                  onPressed: () async {
                    List<AccomCardDetails>? pdfData =
                        await _accommodationsFuture;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PDFViewScreen(
                                  estabData: pdfData,
                                )));
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
                child: const Text('PROFILE'),
              ),
            ),
            ListTile(
              title: const Text('Favorites'),
              onTap: () {
                // NOT SURE IF THIS IS THE PROPER WAY, TEMPORARY Navigator.push
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Favorites();
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () {
                Provider.of<TokenProvider>(context, listen: false)
                    .removeToken("DO NOT REMOVE THIS PARAM");
                Provider.of<UserProvider>(context, listen: false)
                    .removeUser("DO NOT REMOVE THIS PARAM");

                print("Logged out");

                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      // the right drawer
      endDrawer: FilterDrawer(filter: accomFilter, callback: getFilter),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    child: AccomCard(details: accommodation),
                  );
                }).toList(),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty ||
                !snapshot.hasData) {
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
