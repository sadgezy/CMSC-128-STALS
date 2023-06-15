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
import 'package:stals_frontend/screens/owner/add_room.dart';
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

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
      color1 = const Color.fromARGB(255, 32, 27, 26);
      color2 = const Color.fromARGB(255, 232, 154, 53);
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
  List reviewList = [];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  var responseData = "";
  var responseData2 = "";
  String response_Name = "";
  String response_Address = "";
  bool? response_archived;
  bool? response_verified;
  bool? response_rejected;
  String response_estab_type = "";
  String response_Tenant_type = "";
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
  List selectedReason = [];
  bool verified = false;

  String _idType = '';
  bool showAccommTypeError = false;
  bool showAccommImageError = false;
  bool showProofUploadError = false;
  XFile? _idImage;
  PlatformFile? _imageFile;
  PlatformFile? _imageFile2;
  bool uploadedImage = false;
  String base64Image1 = '';
  String base64Image2 = '';

  final TextEditingController idnoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    reviewList = [];
    Future<void> fetchData() async {
      // controller: emailController;
      List<dynamic> user =
          Provider.of<UserProvider>(context, listen: false).userInfo;
      user_id = user[0];
      email = user[1];
      username = user[2];
      user_type = user[3];
      verified = user[4];

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
      response_archived = responseData["archived"];
      response_verified = responseData["verified"];
      response_rejected = responseData["rejected"];
      response_estab_type = responseData["establishment_type"];
      response_Tenant_type = responseData["tenant_type"];
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

      String url4 = "http://127.0.0.1:8000/review-details/";
      final response4 = await json.decode(
          (await http.post(Uri.parse(url4), body: {"establishment_id": id}))
              .body);

      for (int i = 0; i < response4.length; i++) {
        reviewList.add(response4[i]);
      }
    }

    Widget buildUserTypeIcon() {
      if (user_type == "user") {
        return const Icon(
          Icons.bookmark_outline,
          size: 20,
        );
      } else if (user_type == "owner") {
        return const Icon(
          Icons.edit,
          size: 20,
        );
      } else if (user_type == "owner") {
        return const Icon(
          Icons.edit,
          size: 20,
        );
      } else {
        return const Icon(
          Icons.bookmark,
          size: 20,
        );
      }
    }

    const proofUploadError = Padding(
      padding: EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 16,
        child: Text(
          "Please provide proof of your business",
          style: TextStyle(color: Color(0xff7B2D26)),
        ),
      ),
    );

    void _chooseImage(int image) async {
      //ImagePicker picker = ImagePicker();
      //XFile? image = await picker.pickImage(source: ImageSource.gallery);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          withData: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png']);

      if (result != null) {
        var bytes = result.files.first.bytes;
        bytes ??= File(result.files.single.path!).readAsBytesSync();
        double fileSize = (bytes.lengthInBytes / (1024 * 1024));
        //print(bytes.lengthInBytes);
        //print(fileSize);
        if (fileSize > 1) {
          setState(() {
            _imageFile = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image too large'),
            ),
          );
        } else {
          if (image == 1) {
            setState(() {
              _imageFile = result.files.first;
              setState(() => showAccommImageError = false);
            });
            String extn = result.files.first.name.split('.').last;
            if (extn == 'png' || extn == 'PNG') {
              base64Image1 =
                  "data:image/png;base64," + base64Encode(bytes!.toList());
            } else {
              base64Image1 =
                  "data:image/jpeg;base64," + base64Encode(bytes!.toList());
            }
          } else {
            setState(() {
              _imageFile2 = result.files.first;
              setState(() => showProofUploadError = false);
            });
            String extn = result.files.first.name.split('.').last;
            if (extn == 'png' || extn == 'PNG') {
              base64Image2 =
                  "data:image/png;base64," + base64Encode(bytes!.toList());
            } else {
              base64Image2 =
                  "data:image/jpeg;base64," + base64Encode(bytes!.toList());
            }
          }
          //print(result.files.first.name);
          //print("img_pan : $base64Image");
          //setState(() {});
          //var imageFile = Image.network(image.path);
          //html.File(image.path.codeUnits, image.path);
          //print(imageFile.name);

          //_idImage = image as XFile?;
          //final bytes = File(imageFile.name).readAsBytesSync();
          //String base64Image =  "data:image/png;base64,"+base64Encode(bytes);

          //print(base64Image);
        }
      } else {
        setState(() {
          _imageFile = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected'),
          ),
        );
      }
    }

    return Scaffold(
        backgroundColor: Color(0xffF0F3F5),
        //App bar start
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
          title: Text(
            "Return to Homepage",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xffF0F3F5),
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
                return const Center(child: CircularProgressIndicator());
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
                                    if (user_type == 'owner')
                                      ElevatedButton(
                                        onPressed: () {
                                          // Action for the first icon button
                                          Navigator.pushNamed(
                                              context, '/owned/accomm/edit',
                                              arguments: id);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          primary: Colors.white,
                                          onPrimary: const Color.fromARGB(
                                              255, 25, 83, 95),
                                        ),
                                        child:
                                            buildUserTypeIcon(), // First icon
                                      ),
                                    // if (user_type == 'owner')
                                    //   ElevatedButton(
                                    //     onPressed: () {
                                    //       // Action for the second icon button
                                    //       Navigator.pushNamed(
                                    //           context, '/view_owned_accomms',
                                    //           arguments: id);
                                    //     },
                                    //     style: ElevatedButton.styleFrom(
                                    //       shape: CircleBorder(),
                                    //       primary: Colors.white,
                                    //       onPrimary: Color.fromARGB(255, 25, 83, 95),
                                    //     ),
                                    //     child: buildUserTypeIcon(), // Second icon
                                    //   ),
                                    if (user_type == 'owner' ||
                                        user_type == 'admin')
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Action for the third icon button
                                          String url =
                                              "http://127.0.0.1:8000/delete-establishment/" +
                                                  id +
                                                  "/";
                                          final response =
                                              await http.delete(Uri.parse(url));
                                          if (user_type == 'owner') {
                                            Navigator.pushNamed(
                                                context, '/view_owned_accomms');
                                          }

                                          if (user_type == 'admin') {
                                            Navigator.pushNamed(
                                                context, '/admin/view_accomms');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          primary: Colors.white,
                                          onPrimary: const Color.fromARGB(
                                              255, 25, 83, 95),
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          size: 20,
                                        ), // Third icon
                                      ),
                                    // if (user_type == 'owner' || user_type == 'admin')
                                    if (user_type == 'admin')
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Action for the third icon button
                                          if (response_archived == true) {
                                            String url =
                                                "http://127.0.0.1:8000/unarchive-establishment/" +
                                                    id +
                                                    "/";
                                            final response =
                                                await http.put(Uri.parse(url));
                                          } else {
                                            String url =
                                                "http://127.0.0.1:8000/archive-establishment/" +
                                                    id +
                                                    "/";
                                            final response =
                                                await http.put(Uri.parse(url));
                                          }

                                          if (user_type == 'owner') {
                                            Navigator.pushNamed(
                                                context, '/view_owned_accomms');
                                          }

                                          if (user_type == 'admin') {
                                            Navigator.pushNamed(
                                                context, '/admin/view_accomms');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          primary: Colors.white,
                                          onPrimary: const Color.fromARGB(
                                              255, 25, 83, 95),
                                        ),
                                        child: response_archived == false
                                            ? const Icon(
                                                Icons.archive,
                                                size: 20,
                                              )
                                            : const Icon(Icons.restore,
                                                size: 20),
                                      ),
                                    if (user_type == 'owner')
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Action for the fourth icon button
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AddRoom(
                                                    estabId: id,
                                                    estabName: response_Name);
                                              });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          primary: Colors.white,
                                          onPrimary: const Color.fromARGB(
                                              255, 25, 83, 95),
                                        ),
                                        child: const Icon(
                                          Icons.add_home,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              //optional
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        response_Name,
                                        style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                        response_estab_type[0].toUpperCase() +
                                            response_estab_type.substring(1),
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //spacing and divider line
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //Owner Name
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
                                        response2_ownerName,
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
                                      // FittedBox(
                                      //   fit: BoxFit.fill,
                                      //   child: Text(
                                      //     response2_ownerName,
                                      //     style: const TextStyle(
                                      //         fontSize: 15,
                                      //         fontWeight: FontWeight.normal),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
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
                                        response2_phone_no,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff1F2421)),
                                      )
                                      // FittedBox(
                                      //   fit: BoxFit.fill,
                                      //   child: Text(
                                      //     response2_phone_no,
                                      //     style: const TextStyle(
                                      //         fontSize: 15,
                                      //         fontWeight: FontWeight.normal),
                                      //   ),
                                      // ),
                                    ],
                                  ),

                                  //Location Details
                                  Row(
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.location_pin,
                                        color: Color(0xff0B7A75),
                                        size: 25,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          response_Address,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff1F2421)),
                                        ),
                                      )
                                      // FittedBox(
                                      //   fit: BoxFit.fill,
                                      //   child: Text(
                                      //     response_Address,
                                      //     style: const TextStyle(
                                      //         fontSize: 15,
                                      //         fontWeight: FontWeight.normal),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  //Contact Info
                                  Row(
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.group,
                                        color: Color(0xff0B7A75),
                                        size: 25,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          response_Tenant_type,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff1F2421)),
                                        ),
                                      )
                                      // FittedBox(
                                      //   fit: BoxFit.fill,
                                      //   child: Text(
                                      //     response_Address,
                                      //     style: const TextStyle(
                                      //         fontSize: 15,
                                      //         fontWeight: FontWeight.normal),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                 

                                  if (user_type == "user" ||
                                      user_type == "guest")
                                    Row(
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // print(user_type);
                                                if (user_type == "guest") {
                                                  return const AlertDialog(
                                                      content: Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                        "Sign in to file a report!"),
                                                  ));
                                                }
                                                if (!verified) {
                                                  return const AlertDialog(
                                                      content: Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                        "Be verified to file a report!"),
                                                  ));
                                                }
                                                return AlertDialog(
                                                  scrollable: true,
                                                  title: const Text(
                                                      "Report Listing"),
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Form(
                                                      child: Column(
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        5),
                                                            child: Text(
                                                                "Select Reason"),
                                                          ),
                                                          ReportListing(
                                                            tags:
                                                                tagsController,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: SizedBox(
                                                              width: 200,
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    reportController,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13),
                                                                decoration:
                                                                    const InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  hintText:
                                                                      "Report Description",
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                ),
                                                                maxLines: 5,
                                                                minLines: 5,
                                                              ),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              // print(
                                                              //     tagsController
                                                              //         .text);
                                                              switch (
                                                                  tagsController
                                                                      .text) {
                                                                case "1":
                                                                  selectedReason =
                                                                      [
                                                                    "Inactive Owner"
                                                                  ];
                                                                  break;
                                                                case "2":
                                                                  selectedReason =
                                                                      [
                                                                    "Inaccurate Details"
                                                                  ];
                                                                  break;
                                                                case "3":
                                                                  selectedReason =
                                                                      [
                                                                    "Fraudulent Listing"
                                                                  ];
                                                                  break;
                                                                case "4":
                                                                  selectedReason =
                                                                      [
                                                                    "Offensive Content"
                                                                  ];
                                                                  break;
                                                                case "5":
                                                                  selectedReason =
                                                                      [
                                                                    "Other Reason"
                                                                  ];
                                                                  break;
                                                              }
                                                              print(selectedReason.toString());
                                                              if(selectedReason.toString() != "[]"){
                                                                  String url5 =
                                                                  "http://127.0.0.1:8000/report-establishment/";
                                                              final response5 = await json.decode(
                                                                  (await http.post(Uri.parse(url5),
                                                                    body: {
                                                                    "establishment_id": id,
                                                                    "user_id":user_id,
                                                                    "tags":"'${selectedReason.toString()}'",
                                                                    "description": reportController.text
                                                                  }))
                                                                      .body);
                                                              
                                                              reportController
                                                                  .clear();
                                                              Navigator.pop(
                                                                  context);
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text("You have reported this accommodation. Thank you for helping us!")));
                                                              }
                                                              else{
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    // print(user_type);
                                                                    return const AlertDialog(
                                                                        content: Padding(
                                                                      padding: EdgeInsets.all(8),
                                                                      child: Text(
                                                                          "Please select a reason for reporting"),
                                                                    ));
                                                                  },
                                                                );
                                                              } 
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        UIParams
                                                                            .MAROON),
                                                            child: const Text(
                                                              "Report",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.flag_outlined,
                                              size: 20),
                                          label:
                                              const Text("Report this listing"),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xff7B2D26),
                                          ),
                                        ),
                                        TextButton.icon(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // print(user_type);
                                                if (user_type == "guest") {
                                                  return const AlertDialog(
                                                      content: Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                        "Sign in to post a review!"),
                                                  ));
                                                }
                                                if (!verified) {
                                                  return const AlertDialog(
                                                      content: Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                        "Be verified to post a review!"),
                                                  ));
                                                }
                                                return Review(
                                                    accommName: response_Name,
                                                    estabId: id,
                                                    username: username,
                                                    userId: user_id);
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.rate_review,
                                              size: 20),
                                          label: const Text("Write a review"),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xff7B2D26),
                                          ),
                                        )
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //CARD Carousel for ROOM Capacity/Type/Price/Availability
                      //Cards Information/Data are on items1-4()
                      //starting from lines 45-223
                      if (cardList.isNotEmpty)
                        Column(
                          children: [
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
                                  _currentIndex = index;
                                  // print(index);
                                },
                              ),
                              items: cardList.map((card) {
                                return Builder(builder: (BuildContext context) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      color: Colors.blueAccent,
                                      child: card,
                                    ),
                                  );
                                });
                              }).toList(),
                            ),
                          ],
                        ),
                      //End of Cards
                      if (cardList.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: Divider(
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(children: [
                          //Description
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About $response_Name",
                                maxLines: 1,
                                style: const TextStyle(
                                    color: Color(0xff1F2421),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              // SizedBox(
                              //   height:
                              //       MediaQuery.of(context).size.height / 60,
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: SizedBox(
                                  width: 450,
                                  child: Text(description,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.justify),
                                ),
                              ),
                            ],
                          ),
                          //end of Description
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),

                          if (response_verified == true)
                            //View Reviews
                            Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Reviews",
                                        style: TextStyle(
                                          color: Color(0xff1F2421),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              60,
                                    ),
                                    if (reviewList.isNotEmpty)
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        child: ListView.builder(
                                            itemCount: reviewList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Column(children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Text(
                                                          reviewList[index]
                                                              ["username"],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Text(
                                                          reviewList[index][
                                                                      "date_submitted"]
                                                                  .substring(
                                                                      0, 10) +
                                                              " " +
                                                              reviewList[index][
                                                                      "date_submitted"]
                                                                  .substring(
                                                                      11, 19),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Flexible(
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                            reviewList[index]
                                                                ["body"]),
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                              );
                                            }),
                                      ),
                                    if (reviewList.isEmpty)
                                      Text("No reviews yet. Add one!"),
                                  ],
                                ),
                              ),
                            ),
                          //end of View Reviews
                        ]),
                      ),

                      if (response_verified == false &&
                          response_rejected == false)
                        const Column(
                          children: [
                            Text("STATUS: Verification pending...",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      if (response_verified == false &&
                          response_rejected == true)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                          child: Column(
                            children: [
                              const Text(
                                  "STATUS: Verification rejected. Please send new proof.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Proof Type"),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    DropdownButtonFormField(
                                      isExpanded: true,
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'Business Permit',
                                          child: Text('Business Permit'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'BIR',
                                          child: Text('BIR'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Proof of Land Ownership',
                                          child:
                                              Text('Proof of Land Ownership'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Building Permit',
                                          child: Text('Building Permit'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Others',
                                          child: Text('Others'),
                                        ),
                                      ],
                                      onChanged: (value) => _idType = value!,
                                      validator: ((value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Please select a proof type';
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Column(
                                  children: [
                                    const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("ID Number")),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: idnoController,
                                      validator: ((value) {
                                        if (value != null &&
                                            value.trim().isEmpty) {
                                          return "ID Number required";
                                        }
                                      }),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                25, 10, 10, 10),
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18)),
                                            borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 175, 31, 18),
                                              width: 2,
                                            )),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 175, 31, 18),
                                              width: 1,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              if (_imageFile2 != null)
                                Image.memory(
                                  Uint8List.fromList(_imageFile2!.bytes!),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: _idImage != null
                                      ? Image.file(_idImage as File)
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(150, 50),
                                            maximumSize: const Size(150, 50),
                                            elevation: 0,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 25, 83, 95),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            _chooseImage(2);
                                          },
                                          child: const Text("Upload image")),
                                ),
                              ),
                              const Text(
                                'Only photos below 1MB are allowed.',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 25, 83, 95),
                                ),
                              ),
                              showProofUploadError
                                  ? proofUploadError
                                  : const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () async {
                                  if (user_type == "owner") {
                                    if (base64Image2 == '') {
                                      setState(
                                          () => showProofUploadError = true);
                                    } else {
                                      // print("Add accommodation complete.");

                                      String url2 =
                                          "http://127.0.0.1:8000/add-new-proof-establishment/";
                                      final response2 = await json.decode(
                                          (await http
                                                  .post(Uri.parse(url2), body: {
                                        "_id": id,
                                        "proof_type": _idType,
                                        "proof_number": idnoController.text,
                                        "proof_picture": base64Image2,
                                      }))
                                              .body);

                                      Navigator.pop(context);
                                    }
                                  } else {
                                    print("Not an owner!");
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: const Color(0xff0B7A75),
                                  minimumSize: const Size(100, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Submit",
                                    style: TextStyle(fontSize: 17)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }
            },
          ),
        ))));
  }
}
