import 'package:flutter/material.dart';
import '../../classes.dart';
import '../../UI_parameters.dart' as UIParameter;
import '../../components/accom_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';

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

  Future<void> deleteAccommodation(String id) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/delete-establishment/$id/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _accommodationsFuture = fetchAccommodations();
      });
    } else {
      // print('Status code: ${response.statusCode}');
      // print('Response body: ${response.body}');
      throw Exception('Failed to delete accommodation');
    }
  }

  Future<void> unarchiveAccommodation(String id) async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/unarchive-establishment/$id/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _accommodationsFuture = fetchAccommodations();
      });
    } else {
      throw Exception('Failed to archive accommodation');
    }
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
    if (!context.watch<UserProvider>().isAdmin) {
      //Navigator.pop(context);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });

      return const CircularProgressIndicator();
    }
    return Scaffold(
      //  appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     color: Colors.black,
      //   ),
      //   title: Text(
      //     "",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
        body: Center(
            child: ConstrainedBox(
      constraints: new BoxConstraints(maxWidth: 550),
      child: SingleChildScrollView(
        child: FutureBuilder<List<AccomCardDetails>>(
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
                          child:
                              Text("Archived", style: TextStyle(fontSize: 18)),
                        )),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        AccomCardDetails accommodation = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Column(children: [
                            AccomCard(details: accommodation, isFavorite: false,
                                                  func: () {},),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: UIParameter.DARK_TEAL,
                                      shape: RoundedRectangleBorder(
                                        // borderRadius: BorderRadius.circular(UIParameter.CARD_BORDER_RADIUS),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      unarchiveAccommodation(accommodation.ID);
                                    },
                                    child: Text(
                                      "RESTORE",
                                      style: TextStyle(
                                        color: UIParameter.WHITE,
                                        fontSize: UIParameter.FONT_BODY_SIZE,
                                        fontFamily: UIParameter.FONT_REGULAR,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: UIParameter.MAROON,
                                      shape: RoundedRectangleBorder(
                                        // borderRadius: BorderRadius.circular(UIParameter.CARD_BORDER_RADIUS),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      deleteAccommodation(accommodation.ID);
                                    },
                                    child: Text(
                                      "DELETE",
                                      style: TextStyle(
                                        color: UIParameter.WHITE,
                                        fontSize: UIParameter.FONT_BODY_SIZE,
                                        fontFamily: UIParameter.FONT_REGULAR,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ]),
                        );

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 7),
                        //   child: AccomCard(details: accommodation),
                        // );
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
    )));
  }
}
