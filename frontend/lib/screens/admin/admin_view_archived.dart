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
