import 'package:flutter/material.dart';
import '../../classes.dart';
import '../../UI_parameters.dart' as UIParameter;
import '../../components/accom_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewArchivedAccommodations extends StatefulWidget {
  const ViewArchivedAccommodations({super.key});

  @override
  State<ViewArchivedAccommodations> createState() =>
      _ViewArchivedAccommodationsState();
}

class _ViewArchivedAccommodationsState
    extends State<ViewArchivedAccommodations> {
  Future<List<AccomCardDetails>>? _accommodationsFuture;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _accommodationsFuture = fetchAccommodations();
  }

  Future<List<AccomCardDetails>> fetchAccommodations() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/view-all-establishment/'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      // Filter the establishments based on the 'archived' property
      List<AccomCardDetails> filteredAccommodations = jsonResponse
          .map((accommodation) => AccomCardDetails.fromJson(accommodation))
          .where((accommodation) => accommodation
              .archived) // Only include accommodations marked as 'archived'
          .toList();
      return filteredAccommodations;
    } else {
      throw Exception('Failed to load accommodations');
    }
  }

  @override
  Widget build(BuildContext context) {
    // var accom1 = AccomCardDetails(
    //     "accommId1",
    //     "Accommodation1",
    //     "This is a description for accommodation 1",
    //     "assets/images/room_stock.jpg",
    //     3,
    //     true,
    //     true);
    // var accom2 = AccomCardDetails(
    //     "accommId2",
    //     "Accommodation2",
    //     "This is a description for accommodation 2",
    //     "assets/images/room_stock.jpg",
    //     5,
    //     true,
    //     true);
    // var accom3 = AccomCardDetails(
    //     "accommId3",
    //     "Accommodation3",
    //     "This is a description for accommodation 3",
    //     "assets/images/room_stock.jpg",
    //     2,
    //     true,
    //     true);

    // var archivedAccomms = Column(children: [
    //   const Padding(
    //     padding: EdgeInsets.symmetric(vertical: 5),
    //   ),
    //   const Padding(
    //     padding: EdgeInsets.only(left: 10),
    //     child: Align(
    //       alignment: Alignment.topLeft,
    //       child: Text("Archived", style: TextStyle(fontSize: 18)),
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

    // return Scaffold(
    //   body: SingleChildScrollView(
    //     child: Column(children: [
    //       Container(
    //         height: MediaQuery.of(context).size.height,
    //         width: MediaQuery.of(context).size.width,
    //         padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
    //         color: UIParameter.WHITE,
    //         child: SingleChildScrollView(
    //           child: Column(children: [
    //             const Padding(
    //               padding: EdgeInsets.symmetric(vertical: 10),
    //             ),
    //             archivedAccomms,
    //             const Padding(
    //               padding: EdgeInsets.symmetric(vertical: 30),
    //             ),
    //           ]),
    //         ),
    //       ),
    //     ]),
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIParameter.MAROON,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<AccomCardDetails>>(
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
                          child: Text("Archived", style: TextStyle(fontSize: 18)),
                        )),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 7)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        AccomCardDetails accommodation = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: AccomCard(details: accommodation),
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
                          'assets/images/no_archived.png',
                          height: 70,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Text("No Archived Accommodations"),
                      ],
                    ),
                  ),
                );
              }
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
