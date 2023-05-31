import 'package:stals_frontend/components/rating.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stals_frontend/UI_parameters.dart' as UIParams;
import '../components/report_listing.dart';
import 'package:stals_frontend/screens/review.dart';

class AccommPage extends StatefulWidget {
  AccommPage({super.key});
  @override
  _AccommPageState createState() => _AccommPageState();
}

/*possible values:
bool isOwner = true/false
if true then it is the owner there   will be an edit button to edit the current information on the page/cards/image/highlights/etc..
if false then there will be a favorite button for the user 

Highlights booleans
if true it will show in the highlights
if false it wont show
bool isPet = ?
bool isbathroom = ?
bool isCook = ?
bool isNet = ?
bool isConnectNet = ?
bool isAircon = ?
bool isCurfew = ?
bool isMeter = ?
bool isFurnished = ?
bool isSemiFurnished = ?
bool isParking = ? 
bool isLaundry = ? 
bool isOvernight = ?
bool isVisitors = ?
bool isCCTV = ?
bool isMeter = ?
bool isRef = ?


*/

class Item extends StatefulWidget {
  const Item(
      {Key? key,
      required this.availability,
      required this.priceLower,
      required this.priceUpper,
      required this.capacity,
      required this.index})
      : super(key: key);
  final int priceLower;
  final int priceUpper;
  final bool availability;
  final int capacity;
  final int index;

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  String available = "";
  late Color color1;
  late Color color2;

  @override
  Widget build(BuildContext context) {
    if (widget.availability == true) {
      available = "Yes";
    } else {
      available = "No";
    }
    if (widget.index % 4 == 0) {
      color1 = const Color(0xffff4000);
      color2 = const Color(0xffffcc66);
    } else if (widget.index % 4 == 1) {
      color1 = const Color(0xff5f2c82);
      color2 = const Color(0xff49a09d);
    } else if (widget.index % 4 == 2) {
      color1 = const Color.fromARGB(255, 17, 149, 21);
      color2 = const Color.fromARGB(255, 85, 94, 120);
    } else {
      color1 = Color.fromARGB(255, 32, 27, 26);
      color2 = Color.fromARGB(255, 232, 154, 53);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 1],
            colors: [color1, color2]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.king_bed_outlined,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 75,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 50,
              ),
              Text("${widget.index + 1}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50.0,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          Text("Max Capacity : ${widget.capacity}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          if (widget.priceLower == widget.priceUpper)
            Text("Price: ${widget.priceLower}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600))
          else
            Text("Price: ${widget.priceLower} -  ${widget.priceUpper}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600)),
          Text("Available : $available",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}

class _AccommPageState extends State<AccommPage> {
  double rating = 4.0;
  int _index = 1;
  bool favorite = false;
  int _currentIndex = 0;
  List cardList = [];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  TextEditingController emailController = TextEditingController();
  var responseData = "";
  var responseData2 = "";
  String response_Name = "";
  String response_Address = "";
  String owner_id = "";
  String response2_ownerName = "";
  String response2_phone_no = "";
  String response2_firstname = "";
  String response2_lastname = "";
  String id = "";
  String user_id = "";
  String username = "";
  String email = "";
  String user_type = "";
  String loc_picture = "";
  String description = "";

  @override
  Widget build(BuildContext context) {
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
      var responseData = json.decode(response.body);
      loc_picture = responseData["loc_picture"];
      description = responseData["description"];

      owner_id = responseData['owner'];
      // print(owner_id);
      // print("http://127.0.0.1:8000/get-one-user-using-id/" + owner_id + "/");
      String url2 =
          "http://127.0.0.1:8000/get-one-user-using-id/" + owner_id + "/";
      final response2 = await http.get(Uri.parse(url2));
      var responseData2 = json.decode(response2.body);

      response_Name = responseData['name'];
      response_Address = responseData['location_exact'];
      response2_firstname = responseData2['first_name'];

      response2_lastname = responseData2['last_name'];
      response2_ownerName = response2_firstname + " " + response2_lastname;
      response2_phone_no = responseData2['phone_no'];

      String url3 = "http://127.0.0.1:8000/search-room/";
      final response3 = await json.decode((await http.post(Uri.parse(url3),
              body: {"establishment_id": id, "user_type": user_type}))
          .body);

      for (int i = 0; i < response3.length; i++) {
        cardList.add(Item(
            availability: response3[i]["availability"],
            priceLower: response3[i]["price_lower"],
            priceUpper: response3[i]["price_upper"],
            capacity: response3[i]["capacity"],
            index: i));
      }
    }

    Widget buildUserTypeIcon() {
      if (user_type == "user") {
        return Icon(
          Icons.bookmark_outline,
          size: 20,
        );
      } else if (user_type == "owner") {
        return Icon(
          Icons.edit,
          size: 20,
        );
      } else if (user_type == "owner") {
        return Icon(
          Icons.edit,
          size: 20,
        );
      } else {
        return Icon(
          Icons.bookmark,
          size: 20,
        );
      }
    }

    return Scaffold(
      //App bar start
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: Text(
          "Return to Homepage",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      // end of Appbar

      // Main Content for body start

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

      body: FutureBuilder(
        future:
            fetchData(), // Replace fetchData with your actual future function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the data is being fetched, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height / 3.5,
                              width: MediaQuery.of(context).size.width,
                              child: Image.memory(Uri.parse(loc_picture)
                                  .data!
                                  .contentAsBytes())),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (user_type == 'user')
                                ElevatedButton(
                                  onPressed: () {
                                    // Action for the first icon button
                                    Navigator.pushNamed(
                                        context, '/owned/accomm/edit',
                                        arguments: id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    primary: Colors.white,
                                    onPrimary: Color.fromARGB(255, 25, 83, 95),
                                  ),
                                  child: buildUserTypeIcon(), // First icon
                                ),
                              if (user_type == 'owner')
                                ElevatedButton(
                                  onPressed: () {
                                    // Action for the second icon button
                                    Navigator.pushNamed(
                                        context, '/view_owned_accomms',
                                        arguments: id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    primary: Colors.white,
                                    onPrimary: Color.fromARGB(255, 25, 83, 95),
                                  ),
                                  child: buildUserTypeIcon(), // Second icon
                                ),
                              if (user_type == 'owner')
                                ElevatedButton(
                                  onPressed: () async {
                                    // Action for the third icon button
                                    String url =
                                        "http://127.0.0.1:8000/delete-establishment/" +
                                            id +
                                            "/";
                                    final response =
                                        await http.delete(Uri.parse(url));
                                    Navigator.pushNamed(
                                        context, '/view_owned_accomms');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    primary: Colors.white,
                                    onPrimary: Color.fromARGB(255, 25, 83, 95),
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    size: 20,
                                  ), // Third icon
                                ),
                              if (user_type == 'owner')
                                ElevatedButton(
                                  onPressed: () async {
                                    // Action for the third icon button
                                    String url =
                                        "http://127.0.0.1:8000/archive-establishment/" +
                                            id +
                                            "/";
                                    final response =
                                        await http.put(Uri.parse(url));
                                    Navigator.pushNamed(
                                        context, '/view_owned_accomms');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    primary: Colors.white,
                                    onPrimary: Color.fromARGB(255, 25, 83, 95),
                                  ),
                                  child: const Icon(
                                    Icons.archive,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    //optional
                    children: [
                      const SizedBox(
                        width: 35,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          response_Name,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 35,
                      ),
                      // Column(children: [
                      //   StarRating(
                      //     rating: rating,
                      //     onRatingChanged: (rating) =>
                      //         setState(() => this.rating = rating),
                      //     color: Colors.black,
                      //   ),
                      //   FittedBox(
                      //     fit: BoxFit.scaleDown,
                      //     child: Text(
                      //       "100+ reviews",
                      //       style: TextStyle(
                      //           fontSize: 10, fontWeight: FontWeight.bold),
                      //     ),
                      //   ),
                      // ]),
                    ],
                  ),

                  //spacing and divider line
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 3,
                      ),

                      //Owner Name
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                AssetImage("assets/images/room_stock.jpg"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FittedBox(
                            fit: BoxFit.fill,
                            child: Text(
                              response2_ownerName,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),

                      //Location Details
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.location_pin,
                            color: Colors.blue,
                            size: 40,
                          ),
                          FittedBox(
                            fit: BoxFit.fill,
                            child: Text(
                              response_Address,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),

                      //Contact Info
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 6,
                          ),
                          Icon(
                            Icons.phone_in_talk_rounded,
                            color: Colors.blue,
                            size: 33,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FittedBox(
                            fit: BoxFit.fill,
                            child: Text(
                              response2_phone_no,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),

                      if (user_type == "user" || user_type == "guest")
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    print(user_type);
                                    if (user_type == "guest") {
                                      return AlertDialog(
                                          content: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text("Sign in to file a report"),
                                      ));
                                    }
                                    return AlertDialog(
                                      scrollable: true,
                                      title: const Text("Report Listing"),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Form(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Text("Select Reason"),
                                              ),
                                              ReportListing(),
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: SizedBox(
                                                  width: 200,
                                                  child: TextFormField(
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      hintText:
                                                          "Report description",
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                    ),
                                                    maxLines: 5,
                                                    minLines: 5,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                child: Text(
                                                  "Report",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        UIParams.MAROON),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.flag_outlined),
                              label: Text("Report this listing"),
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xff7B2D26),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    print(user_type);
                                    if (user_type == "guest") {
                                      return AlertDialog(
                                          content: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text("Sign in to post a review"),
                                      ));
                                    }
                                    return Review(accommName: response_Name, estabId: id, username: username, userId: user_id);
                                  },
                                );
                              },
                              icon: Icon(Icons.rate_review),
                              label: Text("Write a review"),
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xff7B2D26),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),

                  Divider(
                    color: Colors.black,
                  ),

                  //CARD Carousel for ROOM Capacity/Type/Price/Availability
                  //Cards Information/Data are on items1-4()
                  //starting from lines 45-223
                  Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 200.0,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 1000),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          pauseAutoPlayOnTouch: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            _currentIndex = index;
                            print(index);
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: map<Widget>(cardList, (index, url) {
                      //     return Container(
                      //       width: 10.0,
                      //       height: 10.0,
                      //       margin: EdgeInsets.symmetric(
                      //           vertical: 10.0, horizontal: 2.0),
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: _currentIndex == index
                      //             ? Colors.blueAccent
                      //             : Colors.grey,
                      //       ),
                      //     );
                      //   }),
                      // ),
                    ],
                  ),
                  //End of Cards

                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  //Description
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          const Text(
                            "Description",
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 60,
                          ),
                          SizedBox(
                            width: 450,
                            child: Text(description,
                                style: TextStyle(fontWeight: FontWeight.normal),
                                textAlign: TextAlign.center),
                          ),
                        ],
                      ))
                    ],
                  ),
                  //end of Description
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Colors.black,
                  ),

                  //Highlights
                  // FittedBox(
                  //   fit: BoxFit.fill,
                  //   child: Text(
                  //     "Highlights",
                  //     style: TextStyle(
                  //         fontSize: 22, fontWeight: FontWeight.normal),
                  //   ),
                  // ),
                  // SizedBox(
                  //     child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     SizedBox(
                  //       height: 5,
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.pets,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "Pets Allowed",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.bathtub_outlined,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "Own Bathroom",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.restaurant_menu,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "Cooking Allowed",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.wifi,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "With Internet Connection",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.ac_unit,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "Air - Conditioned Room",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.bedtime_off,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "No Curfew",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.electric_meter_outlined,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "Own Meter",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.bed_sharp,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "Furnished",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.desk,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "Semi Furnished",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.drive_eta_outlined,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "Parking Space",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.local_laundry_service_outlined,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "Laundry Allowed",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.nights_stay_outlined,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "Overnight Visitors Allowed",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.directions_walk,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "Visitors Allowed",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //     FittedBox(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.video_camera_front_outlined,
                  //             color: Colors.blue,
                  //             size: 40,
                  //           ),
                  //           FittedBox(
                  //               fit: BoxFit.fill,
                  //               child: Text(
                  //                 "CCTV in the Area",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.normal),
                  //               )),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // )),
                  //End of Highlights
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
