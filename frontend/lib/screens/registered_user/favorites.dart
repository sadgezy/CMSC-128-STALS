import 'package:flutter/material.dart';
import '../../classes.dart';
import '../../UI_parameters.dart' as UIParameter;
// COMPONENTS
import '../../components/accom_card.dart';
import '../../components/search_bar.dart' as sb;
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
// import 'package:stals_frontend/providers/token_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import '../pdf/pdf_model.dart';
import '../pdf/pdf_viewer.dart';
// import '../pdf/invoice.dart';
// import '../pdf/pdf_model.dart';
// import '../pdf/pdf_view.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  /*
  DUMMY OBJECTS
  <Object will come from database fetch later or from calling screen>
  */
  Future<List<AccomCardDetails>>? _accommodationsFavoritesFuture;

  List<dynamic> user = [];
  String id = '';
  String email = '';
  String username = '';
  String user_type = '';

  @override
  void initState() {
    super.initState();
    getUserInfo();
    _accommodationsFavoritesFuture = fetchUserFavoritesAccommodations();
  }

  Future<void> getUserInfo() async {
    user = Provider.of<UserProvider>(context, listen: false).userInfo;
    id = user[0];
    email = user[1];
    username = user[2];
    user_type = user[3];
  }

  // var accom = AccomCardDetails("jk23fvgw23", "Centtro Residences", "6437e2f6fe3f89a27b315950",
  //     "Example Description", sampleImage, 3, false, true);

  // var accom2 = AccomCardDetails(
  //     'test1234',
  //     'Casa Del Mar',
  //     "6437e2f6fe3f89a27b315950",
  //     'Casa Del Mar is located at Sapphire street.',
  //     sampleImage,
  //     5,
  //     false,
  //     true);

  Future<List<AccomCardDetails>> fetchUserFavoritesAccommodations() async {
    var favoritesDecoded;
    final favoritesUrl =
        Uri.parse('http://127.0.0.1:8000/view-all-user-favorites/');
    final body = json.encode({'email': email});
    final favoritesResponse = await http.post(favoritesUrl,
        body: body, headers: {'Content-Type': 'application/json'});

    if (favoritesResponse.statusCode == 200) {
      // Request was successful
      favoritesDecoded = json.decode(favoritesResponse.body);
      // Handle the favorites response
    } else {
      // Request failed
      print('Request failed with status: ${favoritesResponse.statusCode}');
    }

    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/view-all-establishment/'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      List<AccomCardDetails> accommodations = jsonResponse
          .map((accommodation) => AccomCardDetails.fromJson(accommodation))
          .toList();

      //  Apply the filter
      List<AccomCardDetails> filteredAccommodations = accommodations
          .where((accommodation) => favoritesDecoded
              .contains(accommodation.ID)) // && accommodation.verified)
          .toList();

      return filteredAccommodations;
    } else {
      throw Exception('Failed to load accommodations');
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<AccomCardDetails> favorites = [accom, accom2];

    return Scaffold(
      appBar: AppBar(
          title: const Text('Favorites'),
          backgroundColor: UIParameter.MAROON,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushNamed(context, '/signed_homepage');
            },
            color: Colors.black,
          ),
          actions: <Widget>[
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.save_alt),
                  color: UIParameter.WHITE,
                  onPressed: () async {
                    List<AccomCardDetails>? pdfData =
                        await _accommodationsFavoritesFuture;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PDFViewScreen(estabData: pdfData)));
                  },
                );
              },
            )
          ]),
      body: SingleChildScrollView(
        child: FutureBuilder<List<AccomCardDetails>>(
          future: _accommodationsFavoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<AccomCardDetails> accommodations = snapshot.data!;
              // print(accommodations[0].getImage());
              return Center(
                  child: ConstrainedBox(
                      constraints: new BoxConstraints(maxWidth: 550),
                      child: FittedBox(
                          child: Column(
                        children: accommodations.map((accommodation) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: AccomCard(
                              details: accommodation,
                              isFavorite: true,
                              func: () {
                                Navigator.pop(context);
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
                          );
                        }).toList(),
                      ))));
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
                      Text("No establishments added yet")
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return Center(
              child:
                  CircularProgressIndicator(), // Or any loading indicator widget
            );
          },
        ),
      ),
    );
  }
}
