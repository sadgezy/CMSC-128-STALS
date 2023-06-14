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
import 'package:toggle_switch/toggle_switch.dart';

import '../../classes.dart';

class EditAccomm extends StatefulWidget {
  const EditAccomm({super.key});
  @override
  _EditAccommState createState() => _EditAccommState();
}

/*
Edit Accom: Basically the same as Accom page but
: with textfieldforms for title/information/descripts/etc.. text boxes basically
: remove/add Highlight features

*/

//These checkurl is a check mark png if its available
// noturl is a not avaiable png
//not yet implemented to change so i'll comment out the image

const _checkurl = 'https://img.icons8.com/?size=512&id=11695&format=png';
const _noturl = 'https://img.icons8.com/?size=512&id=TfRrgMHDWJk3&format=png';

class Item extends StatefulWidget {
  const Item(
      {Key? key,
      required this.id,
      required this.availability,
      required this.priceLower,
      required this.priceUpper,
      required this.capacity,
      required this.index})
      : super(key: key);
  final String id;
  final int priceLower;
  final int priceUpper;
  final bool availability;
  final int capacity;
  final int index;

  @override
  State<Item> createState() => _ItemState();
}

// hintText: "${widget.capacity}",
// hintText: "${widget.priceLower} -  ${widget.priceUpper}",
// hintText: "${widget.priceUpper}",

class _ItemState extends State<Item> {
  String available = "";
  late Color color1;
  late Color color2;
  bool isAvailable = false;

  final TextEditingController maxTenantsController = TextEditingController();
  final TextEditingController priceLowerController = TextEditingController();
  final TextEditingController priceUpperController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController availability = TextEditingController();

  bool isEditing = false; // Track editing state
  bool switchValue = false;

  @override
  void initState() {
    super.initState();
    // Initialize switchValue based on widget.availability
    switchValue = widget.availability;
  }

  @override
  Widget build(BuildContext context) {
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
          colors: [color1, color2],
        ),
      ),
      child: Stack(
        children: [
          Column(
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
                  Text(
                    "${widget.index + 1}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 300),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "Max Capacity",
                    hintText: widget.capacity.toString(),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                     hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 3)),
                  ), // Enable/disable editing based on isEditing flag
                  controller: maxTenantsController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.priceLower == widget.priceUpper)
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 200),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: "Price",
                      hintText: widget.priceLower.toString(),
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 3)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                    ), // Enable/disable editing based on isEditing flag
                    controller: priceController,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 150),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: "Price Lower",
                          hintText: widget.priceLower.toString(),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 3)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12.0),
                        ), // Enable/disable editing based on isEditing flag
                        controller: priceLowerController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 150),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: "Price Upper",
                          hintText: widget.priceUpper.toString(),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 3)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12.0),
                        ), // Enable/disable editing based on isEditing flag
                        controller: priceUpperController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Available",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Switch(
                      value: switchValue,
                      onChanged: (value) {
                        setState(() {
                          switchValue = value;
                        });
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.white.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () async {
                String url =
                    "http://127.0.0.1:8000/edit-room/" + widget.id + "/";
                if (widget.priceLower == widget.priceUpper) {
                  final Map<String, dynamic> requestBody = {
                    "availability": isAvailable,
                    "price_lower": priceController.text,
                    "price_upper": priceController.text,
                    "capacity": maxTenantsController.text,
                  };
                  final headers = {
                    'Content-Type': 'application/json',
                  };
                  final response = await http.put(Uri.parse(url),
                      headers: headers, body: json.encode(requestBody));
                } else {
                  final Map<String, dynamic> requestBody = {
                    "availability": isAvailable,
                    "price_lower": priceLowerController.text,
                    "price_upper": priceUpperController.text,
                    "capacity": maxTenantsController.text,
                  };
                  final headers = {
                    'Content-Type': 'application/json',
                  };
                  final response = await http.put(Uri.parse(url),
                      headers: headers, body: json.encode(requestBody));
                }
                Navigator.pushNamed(context, '/view_owned_accomms');
              },
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Changes here
List<DropdownMenuItem<String>> get dropdownEstab {
  List<DropdownMenuItem<String>> esType = [
    DropdownMenuItem(child: 
                    Text(
                      "House",
                        style: TextStyle(
                        fontSize: 15, // Adjust the text size as desired
                        fontWeight: FontWeight.normal, // Customize the font weight
                        color: Colors.grey, // Customize the text color
                      ),
                    ), 
                    value: "house"),
    DropdownMenuItem(child: Text(
                      "Dormitory", 
                        style: TextStyle(
                        fontSize: 15, // Adjust the text size as desired
                        fontWeight: FontWeight.normal, // Customize the font weight
                        color: Colors.grey, // Customize the text color
                      ),
                    ), value: "dormitory"),
    DropdownMenuItem(child: Text(
                      "Apartment", 
                        style: TextStyle(
                        fontSize: 15, // Adjust the text size as desired
                        fontWeight: FontWeight.normal, // Customize the font weight
                        color: Colors.grey, // Customize the text color
                      ),), value: "apartment"),
    DropdownMenuItem(child: Text(
                      "Transient", 
                        style: TextStyle(
                        fontSize: 15, // Adjust the text size as desired
                        fontWeight: FontWeight.normal, // Customize the font weight
                        color: Colors.grey, // Customize the text color
                      ),), value: "transient"),
    DropdownMenuItem(child: Text(
                      "Hotel", 
                        style: TextStyle(
                        fontSize: 15, // Adjust the text size as desired
                        fontWeight: FontWeight.normal, // Customize the font weight
                        color: Colors.grey, // Customize the text color
                      ),), value: "hotel"),
  ];
  
  return esType;
}

List<DropdownMenuItem<String>> get dropdownTenant {
  List<DropdownMenuItem<String>> tenantItems = [
    DropdownMenuItem(child: Text("Students"), value: "students"),
    DropdownMenuItem(child: Text("Teachers"), value: "teachers"),
    DropdownMenuItem(child: Text("Professionals"), value: "professionals"),
    DropdownMenuItem(child: Text("Anyone"), value: "anyone"),
  ];
  return tenantItems;
}

class _EditAccommState extends State<EditAccomm> {
  double rating = 4.0;
  int _index = 1;
  bool favorite = false;
  bool showEditAccommError = false;
  int _currentIndex = 0;
  Future<void>? _accommodationsFuture;
  TextEditingController _controller = TextEditingController();
  TextEditingController _newEstablishmentNameController =
      TextEditingController();
  TextEditingController _newEstablishmentLocationController =
      TextEditingController();
  TextEditingController _newEstablishmentDescriptionController =
      TextEditingController();
  List cardList = [];
  bool isLoading = true;

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
  String loc_picture = "";
  String id = "";
  String response_Description = "";
  //Changes here
  String selectedValueEsType = "apartment";
  String selectedValueTenant = "students";

  String response_estab_type = "";

  @override
  void initState() {
    super.initState();
    // _accommodationsFuture = fetchData();
    // _userInfoFuture = fetchOwnedAccommodations();
  }

  Future<void> fetchData() async {
    // controller: emailController;
    List<dynamic> user =
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
    loc_picture = responseData["loc_picture"];
    response_Name = responseData['name'];
    response_Address = responseData['location_exact'];
    owner_id = responseData['owner'];
    response_Description = responseData['description'];
    response_estab_type = responseData["establishment_type"];

    String url2 =
        "http://127.0.0.1:8000/get-one-user-using-id/" + owner_id + "/";
    final response2 = await http.get(Uri.parse(url2));
    var responseData2 = json.decode(response2.body);
    response_phoneNo = responseData2['phone_no'];
    // print(owner_id);
    // print("http://127.0.0.1:8000/get-one-user-using-id/" + owner_id + "/");

    String url3 = "http://127.0.0.1:8000/search-room/";
    final response3 = await json.decode((await http.post(Uri.parse(url3),
            body: {"establishment_id": id, "user_type": user_type}))
        .body);

    for (int i = 0; i < response3.length; i++) {
      cardList.add(Item(
          id: response3[i]["_id"],
          availability: response3[i]["availability"],
          priceLower: response3[i]["price_lower"],
          priceUpper: response3[i]["price_upper"],
          capacity: response3[i]["capacity"],
          index: i));
    }

    // await Future.delayed(Duration(seconds: 1));

    // setState(() {
    //   isLoading = false;
    //  });
  }

  String userInput = "NA";

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  // onToggleButton(int index) {
  //   setState(() {
  //     if (index == 0) {

  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
          child: Center(
            child: ConstrainedBox(
              constraints: new BoxConstraints(maxWidth: 550.0),
              child: FutureBuilder(
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
                    return Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                    height: 400,
                                    width: width < 550 ? width : 550,
                                    child: Image.memory(
                                        Uri.parse(loc_picture)
                                            .data!
                                            .contentAsBytes(),
                                        fit: BoxFit.cover)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(150, 50),
                                            maximumSize: const Size(150, 50),
                                            elevation: 0,
                                            backgroundColor:
                                                const Color.fromARGB(255, 25, 83, 95),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            // _chooseImage();
                                          },
                                          child: const Text("Upload image")
                                        ),
                                       ElevatedButton(
                                        onPressed: () async {
                                          //on button pushed it saves the editted details and routes back the owned accoms page
                                          //setState(() {});
                                          if (_newEstablishmentNameController.text == "") {
                                            _newEstablishmentNameController.text =
                                                responseData['name'];
                                          }
                                          if (_newEstablishmentLocationController.text ==
                                              "") {
                                            _newEstablishmentLocationController.text =
                                                responseData['location_exact'];
                                          }
                                          if (_newEstablishmentDescriptionController.text ==
                                              "") {
                                            _newEstablishmentDescriptionController.text =
                                                responseData['description'];
                                          }
                                          ;
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
                                                _newEstablishmentDescriptionController.text,
                                            "photos": [],
                                            "proof_type": responseData['proof_type'],
                                            "proof_number": responseData['proof_number'],
                                            "loc_picture": responseData['loc_picture'],
                                            "proof_picture": responseData['loc_picture'],
                                            "reviews": responseData['reviews'],
                                            "verified": responseData['verified'],
                                            "archived": responseData['archived'],
                                            "accommodations": responseData['accommodations']
                                          };
                                          final headers = {
                                            'Content-Type': 'application/json',
                                          };
                                          final response = await http.put(Uri.parse(url),
                                              headers: headers,
                                              body: json.encode(requestBody));
                                          // final decodedResponse = json.decode(response.body);
                                          // Navigator.pop(context);
                                          Navigator.pushNamed(context, '/view_owned_accomms');
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            backgroundColor: Colors.white,
                                            foregroundColor:
                                                const Color.fromARGB(255, 25, 83, 95)),
                                        child: const Icon(
                                          Icons.save_as,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        //Apartment Details
                        //Reviews
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                        Row(
                            //optional
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  const SizedBox(height: 5),
                                  SizedBox(
                                      height: 45,
                                      width: 150,
                                      child:  Row(
                                          children: <Widget>[
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Icon(
                                              Icons.maps_home_work_outlined,
                                              color: Color(0xff0B7A75),
                                              size: 35,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(5),
                                                child: DropdownButton(
                                                  value: selectedValueEsType,
                                                  items: dropdownEstab,
                                                  onChanged: (String? newEstab) {

                                                  },
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            ],
                          ),
                          
                        Row(
                          //optional
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 35,
                            ),
                            const SizedBox(
                              width: 35,
                            ),
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
                              children: <Widget>[
                                const SizedBox(
                                  width: 10,
                                ),
                                const CircleAvatar(
                                  radius: 10,
                                  backgroundImage: AssetImage(
                                      "assets/images/room_stock.jpg"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  username,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff1F2421)),
                                ),
                                const Text(
                                  " owns this place",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff1F2421)),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ), 
                            Row(
                              children: <Widget>[
                                const SizedBox(
                                  width: 9,
                                ),
                                const Icon(
                                  Icons.phone_in_talk_rounded,
                                  color: Color(0xff0B7A75),
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  response_phoneNo,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff1F2421),
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
                                  color: Color(0xff0B7A75),
                                  size: 25,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 350,
                                  child: TextFormField(
                                    controller:
                                        _newEstablishmentLocationController,
                                    decoration: InputDecoration(
                                        hintText: response_Address,
                                        labelText: 'Edit Location Details'),
                                  ),
                                ),
                              ],
                            ),
                            //Contact Info
                          
                            //Changes here
                            //Establishment Type
                            //Tenant Type
                            Row(
                              children: <Widget>[
                                const SizedBox(
                                  width: 8,
                                ),
                                const Icon(
                                  Icons.room_preferences_outlined,
                                  color: Color(0xff0B7A75),
                                  size: 20,
                                ),
                                Padding(
                                    padding: EdgeInsets.all(1),
                                    child: DropdownButton(
                                      value: selectedValueTenant,
                                      items: dropdownTenant,
                                      onChanged: (String? newTenant) {
                                        setState(() {
                                          selectedValueTenant = newTenant!;
                                        });
                                      },
                                    )),
                              ],
                            ),
                          ],
                        )])),
                        
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
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 275.0,
                                autoPlay: false,
                                autoPlayInterval: const Duration(seconds: 5),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 1000),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                pauseAutoPlayOnTouch: true,
                                aspectRatio: 2.0,
                                onPageChanged: (index, reason) {
                                  // setState(() {
                                  //   _currentIndex = index;
                                  // });
                                },
                              ),
                              items: cardList.map((card) {
                                return Builder(builder: (BuildContext context) {
                                  return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 25, 83, 95),
                                          margin: const EdgeInsets.all(12),
                                          elevation: 4,
                                          child: card));
                                });
                              }).toList(),
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
                                        fontSize: 22,
                                        fontWeight: FontWeight.normal),
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
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}