import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:stals_frontend/components/verification_banner.dart';
import 'package:stals_frontend/screens/user_profile.dart';
import '../../classes.dart';
import '../../UI_parameters.dart' as UIParameter;
import '../pdf/pdf_viewer.dart';
import 'favorites.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../homepage.dart';

// COMPONENTS
import '../../components/accom_card.dart';
import '../../components/search_bar.dart';
import '../../components/filter_drawer.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

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
  bool fetchedAll = false;
  List userFavorites = [];
  late Future<bool> checkedFavorites;
  bool checkedFavorites2 = false;
  bool loading = false;
  bool showNotFoundText = false;
  late SharedPreferences prefs;
  bool checkedPrefs = false;

  @override
  void initState() {
    super.initState();
    pref();
    checkedFavorites = getFavorites();
  }

  void pref() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("reload_reghome").isNull) {
      prefs.setBool("reload_reghome", false);
    } else {
      if (prefs.getBool("reload_reghome")!) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return RegisteredHomepage();
            },
          ),
        );
      }
    }

    checkedPrefs = true;
  }

  Future<bool> getFavorites() async {
    String url = "http://127.0.0.1:8000/view-all-user-favorites/";

    final response = await jsonDecode((await http.post(
      Uri.parse(url),
      body: {
        "email": Provider.of<UserProvider>(context, listen: false).getEmail
      },
    ))
        .body);

    //print(response);
    if (response.runtimeType.toString() == "String") {
      userFavorites = response
          .toString()
          .substring(1, response.toString().length - 1)
          .split(", ");

      
        setState(() {
          checkedFavorites2 = true;
        });
        return true;
    }
    return false;
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

  var filterTitleList = [];
  var filterValueList = [];

  void performSearch() async {
    String url = "http://127.0.0.1:8000/search-establishment/";
    final response = await json.decode((await http.post(Uri.parse(url), body: {
      'name': searchVal,
      'location_exact': filterValueList[1] ?? "",
      'establishment_type': filterValueList[2] ?? "",
      'tenant_type': filterValueList[3] ?? "",
      'price_lower':
          filterValueList[4] == null ? "" : "int(${filterValueList[4]})",
      'price_upper':
          filterValueList[5] == null ? "" : "int(${filterValueList[5]})",
    }))
        .body);

    setState(() {
      accommList = response;
      showNotFoundText = accommList.isEmpty;
    });
  }

  /*
  TO-DO: GET LIST OF ACCOMMODATIONS FROM DATABASE AND FILTER ACCORDING TO `accomFilter`
  initally, the homepage `accomFilter` will all be set to null, meaning all accomms will be displayed since all filter parameters are null
  as user chooses his/her filter, `accomFilter` will be set to its new state according to the filter/s the user selected
  the setstate should trigger the accomms in the homepage to reload (display accomms that fit the new filter)
  */
  @override
  Widget build(BuildContext context) {
    html.window.onUnload.listen((event) async {
      prefs.setBool("reload_reghome", true);
    });

    

    if (!fetchedAll) {
      _accommodationsFuture = fetchAllAccommodations();
      checkedFavorites = getFavorites();
    }

    String verified;
    bool isVerified = context.watch<UserProvider>().isVerified;
    bool isRejected = context.watch<UserProvider>().isRejected;
    // print(isVerified);
    // print(isRejected);

    if (!isVerified && !isRejected) {
      verified = 'pending';
    } else if (!isVerified && isRejected) {
      verified = 'rejected';
    } else {
      verified = '';
    }

    /*
    DUMMY OBJECT
    <Object will come from database fetch later>
    */

    filterTitleList = [];
    filterValueList = [];
    var filterRaw = accomFilter.getFiltersApplied();
    for (int i = 0; i < filterRaw.length; i++) {
      filterValueList.add(filterRaw[i][0]);
      filterTitleList.add(filterRaw[i][1]);
    }

    // String verified = context.watch<UserProvider>().isVerified
    //     ? ''
    //     : 'Your account’s verification is under review. Please wait.';
    //: 'Your account’s verification was declined. Please resubmit your details by editing your profile';

    Color banner =
        context.watch<UserProvider>().isVerified ? Colors.green : Colors.red;

    IconButton searchButton = IconButton(
        onPressed: performSearch,
        icon: const Icon(
          Icons.search,
          color: Color.fromARGB(255, 0, 0, 0),
        ));

    if (checkedPrefs) {
      prefs.setBool("reload_reghome", false);
    } else {
      searchButton.onPressed!.call();
    }

    if (!loading && !checkedFavorites2) {
      getFavorites();
      searchButton.onPressed!.call();
    }

    if (!loading && checkedFavorites2) {
      getFavorites();
      searchButton.onPressed!.call();
      loading = true;
    }

    //print(accommList);

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
                      onSubmitted: (value) {
                        // Add this property
                        setState(() {
                          accommList = [];
                        });
                        performSearch();
                      },
                    )),
                Expanded(
                  flex: 2,
                  child: searchButton,
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
                  child: const Text(''),
                ),
              ),
              ListTile(
                title: const Text('View Profile'),
                onTap: () {
                  String userId =
                      Provider.of<UserProvider>(context, listen: false).getID;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(userId: userId),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Favorites'),
                trailing: Icon(Icons.person_2_rounded),
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
            ],
          ),
        ),
        // the right drawer
        endDrawer: FilterDrawer(filter: accomFilter, callback: getFilter),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          if (!context.watch<UserProvider>().isVerified && checkedFavorites2)
            ConstrainedBox(
                constraints: new BoxConstraints(maxWidth: 550),
                child: VerificationBanner(
                  verificationStatus: verified,
                )),
          ConstrainedBox(
              constraints: new BoxConstraints(
                maxWidth: 550,
              ),
              child: Column(children: <Widget>[
                if (!accomFilter.isEmpty())
                  Wrap(children: [
                    for (int i = 0; i < filterValueList.length; i++)
                      if (filterValueList[i] != null)
                        _displayFilter(
                            filterValueList[i].toString(), filterTitleList[i])
                  ]),
                if (!fetchedAll)
                  SingleChildScrollView(
                    child: FutureBuilder<List<AccomCardDetails>>(
                      future: _accommodationsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          // print("RAN");
                          //print(snapshot);
                          List<AccomCardDetails> accommodations =
                              snapshot.data!;
                          //print(accommodations);
                          return FutureBuilder(
                              future: checkedFavorites,
                              builder: (context, snapshot2) {
                                return Column(children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(children: [
                                      if (snapshot2.hasData && snapshot2.data!)
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: accommodations.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              bool isFavorite;
                                              if (userFavorites.contains(
                                                  "'${accommodations[index].getID()}'")) {
                                                isFavorite = true;
                                              } else {
                                                //print(userFavorites.contains("'${accommodation.getID()}'"));
                                                isFavorite = false;
                                              }
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 7,
                                                        horizontal: 15),
                                                child: AccomCard(
                                                  details:
                                                      accommodations[index],
                                                  isFavorite: isFavorite,
                                                  func: () {},
                                                ),
                                              );
                                            }),
                                      if (snapshot2.hasData && !snapshot2.data!)
                                        CircularProgressIndicator()
                                    ]),
                                  ),
                                  if (!snapshot2.hasData)
                                    CircularProgressIndicator()
                                ]);
                              });
                        } else if (snapshot.hasData && snapshot.data!.isEmpty ||
                            !snapshot.hasData) {
                          return Center(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    CircularProgressIndicator(),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20)),
                                  if (snapshot.connectionState !=
                                      ConnectionState.waiting)
                                    Image.asset(
                                      'assets/images/no_archived.png',
                                      height: 70,
                                    ),
                                  if (snapshot.connectionState !=
                                      ConnectionState.waiting)
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10)),
                                  if (snapshot.connectionState !=
                                      ConnectionState.waiting)
                                    const Text("No Accommodations Available! ")
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
                    child: showNotFoundText
                        ? Center(
                            child: Column(
                              children: [
                                const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20)),
                                Image.asset(
                                  'assets/images/no_pending.png',
                                  height: 70,
                                ),
                                const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10)),
                                Text("No Accommodations Found")
                              ],
                            ),
                          )
                        : Column(
                            children: accommList.map((accommodation) {
                              //print(accommodation);
                              //print(accommodation["name"]);
                              bool isFavorite;
                              if (userFavorites
                                  .contains("'${accommodation["_id"]}'")) {
                                isFavorite = true;
                              } else {
                                isFavorite = false;
                              }
                              //print(userFavorites);
                              //print(accommodation["_id"]);
                              //print(isFavorite);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 15),
                                child: AccomCard(
                                  details: AccomCardDetails(
                                      accommodation["_id"],
                                      accommodation["name"],
                                      accommodation["owner"],
                                      accommodation["description"],
                                      4.0,
                                      accommodation["archived"],
                                      accommodation["verified"]),
                                  isFavorite: isFavorite,
                                  func: () {},
                                ),
                              );
                            }).toList(),
                          ),
                  ),
              ]))
        ]))));
  }
}
