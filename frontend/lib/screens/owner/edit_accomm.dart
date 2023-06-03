import 'package:stals_frontend/components/rating.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../UI_parameters.dart' as UIParameter;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../../classes.dart';

class EditAccomm extends StatefulWidget {
  const EditAccomm({super.key});
  @override
  _EditAccommState createState() => _EditAccommState();
}

/*
Edit Accom: Basically the same as Accom page but
: with textfieldforms for title/information/descripts/etc.. text boxes basically
: Add Card button? for Room information in the card carousel
: remove/add Highlight features
*/

//data information:
class Item1 extends StatelessWidget {
  const Item1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffff4000),
              Color(0xffffcc66),
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.single_bed_outlined,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 75,
          ),
          Text("1 Bedroom",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)),
          Text("Max Capacity : 4",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Price: Php69,420",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Available : Yes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 1],
            colors: [Color(0xff5f2c82), Color(0xff49a09d)]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 75,
          ),
          Text("2 Bedroom",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)),
          Text("Max Capacity : 6",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Price: Php69,420",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Available : No",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffff4000),
              Color(0xffffcc66),
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/bed.png',
            height: 180.0,
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}

class Item4 extends StatelessWidget {
  Item4({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Hanse",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)),
          Text("Papasok kaba",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          Text("Syempre hindi",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)),
          Text("Tara kain",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _EditAccommState extends State<EditAccomm> {
  double rating = 4.0;
  int _index = 1;
  bool favorite = false;
  int _currentIndex = 0;
  Future<List<AccomCardDetails>>? _accommodationsFuture;
  TextEditingController _controller = TextEditingController();
  TextEditingController _newEstablishmentNameController =
      TextEditingController();
  TextEditingController _newEstablishmentLocationController =
      TextEditingController();
  TextEditingController _newEstablishmentDescriptionController =
      TextEditingController();
  var responseData;
  List<String> user = [];
  String user_id = '';
  String email = '';
  String username = '';
  String user_type = '';
  String response_Address = "";
  String response_Owner = "";
  String response_phoneNo = "";
  String response_Name = "";
  String owner_id = "";
  String id = "";
  String response_Description = "";

  Future<void> fetchData() async {
    // controller: emailController;
    List<String> user =
        Provider.of<UserProvider>(context, listen: false).userInfo;
    user_id = user[0];
    email = user[1];
    username = user[2];
    user_type = user[3];

    // print(id);
    // print(email);
    // print(username);
    // print(user_type);
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      // Do something with the passed data
      final card_id = arguments as String;
      id = card_id;
      // print('Received ID: id');
    }
    String url1 = "http://127.0.0.1:8000/view-establishment/" + id + "/";
    final response = await http.get(Uri.parse(url1));
    responseData = json.decode(response.body);
    response_Name = responseData['name'];
    response_Address = responseData['location_exact'];
    owner_id = responseData['owner'];
    response_Description = responseData['description'];

    String url2 =
        "http://127.0.0.1:8000/get-one-user-using-id/" + owner_id + "/";
    final response2 = await http.get(Uri.parse(url2));
    var responseData2 = json.decode(response2.body);
    response_phoneNo = responseData2['phone_no'];
    // print(owner_id);
    // print("http://127.0.0.1:8000/get-one-user-using-id/" + owner_id + "/");
  }

  @override
  void initState() {
    super.initState();

    // _userInfoFuture = fetchOwnedAccommodations();
  }

  String userInput = "NA";
  List cardList = [Item1(), Item2(), Item3(), Item4()];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<UserProvider>().isOwner) {
      //Navigator.pop(context);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });

      return const CircularProgressIndicator();
    }
    fetchData();
    return Scaffold(
        //App bar start
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
          title: const Text(
            "Cancel Edit",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        //end of Appbar

        //Main Content for body start

        /*
        Row content Arrangement: 
        > Image
        > Apt. name - Star rating
        > Apt. Location/ Owner name and contact no.
        > Keycards/box of Rooms
          >Available or not
          >Price
          >Max occu.
          >type of room
        >Detailed Info of Apt
        >Highlighted features of Apt./Room
        >Reviews
          >Name of reviewee
          >Date
          >Review content

        */

        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
                height: 2000,
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Stack(alignment: Alignment.topRight, children: [
                          SizedBox(
                            height: 280,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              'assets/images/room_stock.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                //on button pushed it saves the editted details and routes back the owned accoms page
                                //setState(() {});
                                print("edit accommodation complete.");
                                String url =
                                    "http://127.0.0.1:8000/edit-establishment/" +
                                        id +
                                        "/";
                                final Map<String, dynamic> requestBody = {
                                  "owner": owner_id,
                                  "name": _newEstablishmentNameController.text,
                                  "location_exact":
                                      _newEstablishmentLocationController.text,
                                  "location_approx":
                                      responseData['location_approx'],
                                  "establishment_type":
                                      responseData['establishment_type'],
                                  "tenant_type": responseData['tenant_type'],
                                  "utilities": [],
                                  "description":
                                      _newEstablishmentDescriptionController
                                          .text,
                                  "photos": [],
                                  "proof_type": responseData['proof_type'],
                                  "proof_number": responseData['proof_number'],
                                  "loc_picture": responseData['loc_picture'],
                                  "proof_picture": responseData['loc_picture'],
                                  "reviews": responseData['reviews'],
                                  "verified": responseData['verified'],
                                  "archived": responseData['archived'],
                                  "accommodations":
                                      responseData['accommodations']
                                };
                                final headers = {
                                  'Content-Type': 'application/json',
                                };
                                final response = await http.put(Uri.parse(url),
                                    headers: headers,
                                    body: json.encode(requestBody));
                                // final decodedResponse = json.decode(response.body);
                                // Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, '/view_owned_accomms');
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      const Color.fromARGB(255, 25, 83, 95)),
                              child: const Icon(
                                Icons.save_as,
                                size: 20,
                              ))
                        ])
                      ]),
                  const SizedBox(
                    height: 10,
                  ),

                  //Apartment Details
                  //Reviews

                  Row(
                    //optional
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 35,
                      ),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: TextFormField(
                          controller: _newEstablishmentNameController,
                          decoration: InputDecoration(
                              hintText: response_Name,
                              //label text should be the value before editting
                              labelText: 'Edit Establishment Name'),
                        ),
                      ),
                      const SizedBox(
                        width: 35,
                      ),
                      Column(children: [
                        StarRating(
                          rating: rating,
                          onRatingChanged: (rating) =>
                              setState(() => this.rating = rating),
                          color: Colors.black,
                        ),
                        const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "100+ reviews",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),

                  //Contact Information Box
                  Column(
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      //Profile icon and name of owner
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          //Profile of Owner
                          const CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                AssetImage("assets/images/room_stock.jpg"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: Text(
                              username,
                              style: const TextStyle(
                                  fontSize: UIParameter.FONT_BODY_SIZE,
                                  fontFamily: UIParameter.FONT_REGULAR),
                            ),
                          ),
                        ],
                      ),
                      //Location Details
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.location_pin,
                            color: Colors.blue,
                            size: 40,
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: TextFormField(
                              controller: _newEstablishmentLocationController,
                              decoration: InputDecoration(
                                  hintText: response_Address,
                                  labelText: 'Edit Location Details'),
                            ),
                          ),
                        ],
                      ),
                      //Contact Info
                      Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 6,
                          ),
                          const Icon(
                            Icons.phone_in_talk_rounded,
                            color: Colors.blue,
                            size: 33,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: TextFormField(
                              controller: _controller,
                              decoration: InputDecoration(
                                  hintText: response_phoneNo,
                                  labelText: 'Edit Contact Details'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  //end of Owner Information

                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),

                  //Cards information
                  //Alternative Cards
                  Column(
                    children: [
                      // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      //   const Text("Click Here to add Room details",
                      //       style: TextStyle(color: Colors.black)),
                      //   //this button should reroute to the Add Rooms route?
                      //   ElevatedButton(
                      //       onPressed: () {
                      //         Navigator.pushNamed(
                      //             context, '/add_accommodation');
                      //       },
                      //       style: ElevatedButton.styleFrom(
                      //           shape: const CircleBorder(),
                      //           backgroundColor: Colors.white,
                      //           foregroundColor:
                      //               const Color.fromARGB(255, 25, 83, 95)),
                      //       child: const Icon(
                      //         Icons.save_as,
                      //         size: 20,
                      //       )),
                      // ]),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 200.0,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 1000),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          pauseAutoPlayOnTouch: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: cardList.map((card) {
                          return Builder(builder: (BuildContext context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.30,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                color: Colors.blueAccent,
                                child: card,
                              ),
                            );
                          });
                        }).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: map<Widget>(cardList, (index, url) {
                          return Container(
                            width: 10.0,
                            height: 10.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.blueAccent
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  //End of Cards

                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),

                  //Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 4,
                        width: 25,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          const FittedBox(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "About Name",
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                            width: 5,
                          ),
                          SizedBox(
                            height: 100,
                            width: 600,
                            child: TextFormField(
                              maxLines: 5,
                              controller:
                                  _newEstablishmentDescriptionController,
                              decoration: InputDecoration(
                                  hintText: response_Description,
                                  labelText: 'Edit Description'),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                  //end of Description
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),

                  //Highlights
                  const FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      "Highlights",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                      height: 2000,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.pets,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "Pets Allowed",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.bathtub_outlined,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "Own Bathroom",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.restaurant_menu,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "Cooking Allowed",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.wifi,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "With Internet Connection",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.ac_unit,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "Air - Conditioned Room",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.bedtime_off,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "No Curfew",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.electric_meter_outlined,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "Own Meter",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.bed_sharp,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "Furnished",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.desk,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "Semi Furnished",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.drive_eta_outlined,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "Parking Space",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.local_laundry_service_outlined,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "Laundry Allowed",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.nights_stay_outlined,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "Overnight Visitors Allowed",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.directions_walk,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "Visitors Allowed",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.video_camera_front_outlined,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                                FittedBox(
                                    fit: BoxFit.fill,
                                    child: Text(
                                      "CCTV in the Area",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      )),
                  //End of Highlights
                ]))
          ]),
        ));
  }
}
