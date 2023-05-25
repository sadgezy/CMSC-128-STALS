import 'package:flutter/material.dart';
import '../classes.dart';
import '../UI_parameters.dart' as UIParameter;
// COMPONENTS
import '../components/accom_card.dart';
import '../components/search_bar.dart';
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
    String responseName = "";
    String responseAddress = "";
    String responsedescription = "";
    String id = "";
  Future<void> fetchOneEstablishment() async {

            String url1 = "http://127.0.0.1:8000/view-establishment/6466debaba1cf72dc5afb016";
            final response = await http.get(Uri.parse(url1));
            var responseData = json.decode(response.body);
            responseName = responseData['name'];
            responseAddress = responseData['location_exact'];
            responsedescription = responseData['description'];
            print(responseName);
    } 

  @override
  Widget build(BuildContext context) {
    // var accom = AccomCardDetails(
    //   responseName,
    //   responseAddress,
    //   responsedescription,
    //   "assets/images/room_stock.jpg",
    //   3,
    //   false,
    //   false,
    // );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: UIParameter.WHITE,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: UIParameter.LIGHT_TEAL,
          onPressed: () {
            if (scaffoldKey.currentState!.isDrawerOpen) {
              scaffoldKey.currentState!.closeDrawer();
            } else {
              scaffoldKey.currentState!.openDrawer();
            }
          },
        ),
        title: CustomSearchBar(
          hintText: 'Search',
          onChanged: (value) {
            /* PUT SEARCH FUNCTION HERE */
          },
        ),
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
        ],
      ),
      drawer: Drawer(
        child: ListView(
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          color: UIParameter.WHITE,
          child: FutureBuilder(
            future: fetchOneEstablishment(), // Replace "yourFuture" with the actual future you have
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(
                  child: Column(
                    children: [
                      AccomCard(details:AccomCardDetails(
                                          responseName,
                                          responseAddress,
                                          responsedescription,
                                          "assets/images/room_stock.jpg",
                                          3,
                                          false,
                                          false,
                                        )),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
