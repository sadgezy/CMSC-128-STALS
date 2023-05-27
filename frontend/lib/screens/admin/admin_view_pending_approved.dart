import 'package:flutter/material.dart';
import 'package:stals_frontend/components/pending_accom_card.dart';
import '../../classes.dart';
import '../../UI_parameters.dart' as UIParameter;
import '../../components/accom_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                  child: PendingAccomCard(
                    accomName: details.name,
                    ownerName: details.name,
                    verified: details.verified,
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
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20)),
                    Image.asset(
                      'assets/images/no_pending.png',
                      height: 70,
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10)),
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
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5)),
              const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Approved", style: TextStyle(fontSize: 18)),
                  ),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 7)),
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
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20)),
                  Image.asset(
                    'assets/images/no_pending.png',
                    height: 70,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10)),
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


    // var accom1 = AccomCardDetails(
    //     "accommId1",
    //     "Accommodation1",
    //     "This is a description for accommodation 1",
    //     "assets/images/room_stock.jpg",
    //     3, false,true);
    // var accom2 = AccomCardDetails(
    //     "accommId2",
    //     "Accommodation2",
    //     "This is a description for accommodation 2",
    //     "assets/images/room_stock.jpg",
    //     5,true,false);
    // var accom3 = AccomCardDetails(
    //     "accommId3",
    //     "Accommodation3",
    //     "This is a description for accommodation 3",
    //     "assets/images/room_stock.jpg",
    //     2, true, true);

    // var pendingaccom1 = PendingAccomCard(
    //     accomName: "Villegas Compound", ownerName: "Owner Name", true);
    // var pendingaccom2 = PendingAccomCard(
    //     accomName: "Carlos Santos Apartments", ownerName: "Owner Name", true);

    // var approvedAccomms = Column(children: [
    //   const Padding(
    //     padding: EdgeInsets.symmetric(vertical: 5),
    //   ),
    //   const Padding(
    //     padding: EdgeInsets.only(left: 10),
    //     child: Align(
    //       alignment: Alignment.topLeft,
    //       child: Text("Approved", style: TextStyle(fontSize: 18)),
    //     ),
    //   ),
    //   const Padding(
    //     padding: EdgeInsets.symmetric(vertical: 7),
    //   ),
    //   AccomCard(details: accom1),
    //   const Padding(
    //     padding: EdgeInsets.symmetric(vertical: 7),
    //   ),
    //   AccomCard(details: accom2),
    //   const Padding(
    //     padding: EdgeInsets.symmetric(vertical: 7),
    //   ),
    //   AccomCard(details: accom3),
    // ]);

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
      appBar: AppBar(
        backgroundColor: UIParameter.MAROON,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              color: UIParameter.WHITE,
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
    );
  }
}
