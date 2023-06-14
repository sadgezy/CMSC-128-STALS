import 'package:flutter/material.dart';
import 'package:stals_frontend/components/pending_accom_card.dart';
import '../../classes.dart';
import '../../UI_parameters.dart' as UIParameter;
import '../../components/accom_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';

class AdminViewPendingApproved extends StatefulWidget {
  const AdminViewPendingApproved({Key? key}) : super(key: key);

  @override
  _AdminViewPendingApprovedState createState() =>
      _AdminViewPendingApprovedState();
}

class _AdminViewPendingApprovedState extends State<AdminViewPendingApproved> {
  Future<List<AccomCardDetails>>? _accommodationsPendingFuture;
  Future<List<AccomCardDetails>>? _accommodationsFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  // int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _accommodationsPendingFuture = fetchPendingAccommodations();
    _accommodationsFuture = fetchApprovedAccommodations();
  }

  Future<void> approveAccommodation(String id) async {
    print(id);
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/verify-establishment/$id/'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve accommodation');
    }
  }

  Future<void> disapproveAccommodation(String id) async {
    print(id);

    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/archive-establishment/$id/'),
    );

    String url2 = "http://127.0.0.1:8000/set-reject-establishment/";
    final response2 = await json.decode((await http
            .post(Uri.parse(url2), body: {'_id': id, 'rejected': "True"}))
        .body);

    if (response.statusCode != 200) {
      throw Exception('Failed to archive accommodation');
    }
  }

  Future<List<AccomCardDetails>> fetchPendingAccommodations() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/view-all-establishment/'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      // Filter the establishments based on the 'waitingVerification' property
      List<AccomCardDetails> filteredAccommodations = jsonResponse
          .map((accommodation) => AccomCardDetails.fromJson(accommodation))
          .where((accommodation) => (!accommodation.verified &&
              !accommodation
                  .archived)) // Only include accommodations marked true on verified and archived
          .toList();
      // print(filteredAccommodations);
      return filteredAccommodations;
    } else {
      throw Exception('Failed to load accommodations');
    }
  }

  Future<List<AccomCardDetails>> fetchApprovedAccommodations() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/view-all-establishment/'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      // Filter the establishments based on the 'waitingVerification' property
      List<AccomCardDetails> filteredAccommodations1 = jsonResponse
          .map((accommodation) => AccomCardDetails.fromJson(accommodation))
          .where((accommodation) => (accommodation.verified &&
              !accommodation
                  .archived)) // Only include accommodations marked false on verified and archived
          .toList();
      // print(filteredAccommodations1);
      return filteredAccommodations1;
    } else {
      throw Exception('Failed to load accommodations');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<UserProvider>().isAdmin) {
      //Navigator.pop(context);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });

      return const CircularProgressIndicator();
    }
    Widget pendingAccomms = FutureBuilder<List<AccomCardDetails>>(
      future: _accommodationsPendingFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                AccomCardDetails details = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/admin/verify_accomm',
                          arguments: details.ID);
                    },
                    child: PendingAccomCard(
                      accomName: details.name,
                      ownerName: details.name,
                      verified: details.verified,
                      ID: details.ID,
                      onApproved: () async {
                        try {
                          await approveAccommodation(details.ID);
                          print(
                              "Approved accommodation with ID: ${details.ID}");
                          // Refresh the list of pending and approved accommodations
                          setState(() {
                            _accommodationsPendingFuture =
                                fetchPendingAccommodations();
                            _accommodationsFuture =
                                fetchApprovedAccommodations();
                          });
                        } catch (e) {
                          print("Error approving accommodation: $e");
                        }
                      },
                      onDisapproved: () async {
                        try {
                          await disapproveAccommodation(details.ID);
                          print(
                              "Disapproved and archived accommodation with ID: ${details.ID}");
                          // Refresh the list of pending and approved accommodations
                          setState(() {
                            _accommodationsPendingFuture =
                                fetchPendingAccommodations();
                            _accommodationsFuture =
                                fetchApprovedAccommodations();
                          });
                        } catch (e) {
                          print("Error disapproving accommodation: $e");
                        }
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                    Image.asset(
                      'assets/images/no_pending.png',
                      height: 70,
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Text("No Pending Accommodations")
                  ],
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );

    Widget approvedAccomms = FutureBuilder<List<AccomCardDetails>>(
      future: _accommodationsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return Column(
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Approved", style: TextStyle(fontSize: 18)),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    AccomCardDetails details = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: AccomCard(details: details),
                    );
                  },
                ),
              ],
            );
          } else {
            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                    Image.asset(
                      'assets/images/no_pending.png',
                      height: 70,
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Text("No Approved Accommodations"),
                  ],
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );

    FutureBuilder<List<AccomCardDetails>>(
      future: _accommodationsPendingFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              AccomCardDetails details = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: PendingAccomCard(
                  accomName: details.name,
                  ownerName: details.name,
                  verified: details.verified,
                  ID: details.ID,
                  onApproved: () async {
                    try {
                      await approveAccommodation(details.ID);
                      print("Approved accommodation with ID: ${details.ID}");
                      // Refresh the list of pending and approved accommodations
                      setState(() {
                        _accommodationsPendingFuture =
                            fetchPendingAccommodations();
                        _accommodationsFuture = fetchApprovedAccommodations();
                      });
                    } catch (e) {
                      print("Error approving accommodation: $e");
                    }
                  },
                  onDisapproved: () async {
                    try {
                      await disapproveAccommodation(details.ID);
                      print(
                          "Disapproved and archived accommodation with ID: ${details.ID}");
                      // Refresh the list of pending and approved accommodations
                      setState(() {
                        _accommodationsPendingFuture =
                            fetchPendingAccommodations();
                        _accommodationsFuture = fetchApprovedAccommodations();
                      });
                    } catch (e) {
                      print("Error disapproving accommodation: $e");
                    }
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );

    FutureBuilder<List<AccomCardDetails>>(
      future: _accommodationsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              AccomCardDetails details = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: PendingAccomCard(
                  accomName: details.name,
                  ownerName: details.name,
                  verified: details.verified,
                  ID: details.ID,
                  onApproved: () async {
                    try {
                      await approveAccommodation(details.ID);
                      print("Approved accommodation with ID: ${details.ID}");
                      // Refresh the list of pending and approved accommodations
                      setState(() {
                        _accommodationsPendingFuture =
                            fetchPendingAccommodations();
                        _accommodationsFuture = fetchApprovedAccommodations();
                      });
                    } catch (e) {
                      print("Error approving accommodation: $e");
                    }
                  },
                  onDisapproved: () async {
                    try {
                      await disapproveAccommodation(details.ID);
                      print(
                          "Disapproved and archived accommodation with ID: ${details.ID}");
                      // Refresh the list of pending and approved accommodations
                      setState(() {
                        _accommodationsPendingFuture =
                            fetchPendingAccommodations();
                        _accommodationsFuture = fetchApprovedAccommodations();
                      });
                    } catch (e) {
                      print("Error disapproving accommodation: $e");
                    }
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );

    // see code below for when there are no pending and archived accommodations
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
      child: ConstrainedBox(
        constraints: new BoxConstraints(maxWidth: 550),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: SingleChildScrollView(
                child: Column(children: [
                  pendingAccomms,
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1.25,
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                  ),
                  approvedAccomms,
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
