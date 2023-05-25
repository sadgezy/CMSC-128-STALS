import 'package:stals_frontend/components/rating.dart';
import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/token_provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccommPage extends StatefulWidget {
  const AccommPage({super.key});
  @override
  _AccommPageState createState() => _AccommPageState();
}


class _AccommPageState extends State<AccommPage> {
  double rating = 4.0;
  int _index = 1;
  bool favorite = false;
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
  
  @override
  Widget build(BuildContext context) {
      final arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments != null) {
      // Do something with the passed data
        final card_id = arguments as String;
        id = card_id;
        // print('Received ID: id');
      }
      Future<void> fetchData() async {
            // controller: emailController;
            // List<String> user =
            //     Provider.of<UserProvider>(context, listen: false).userInfo;
            // String id = user[0];
            // String email = user[1];
            // String username = user[2];
            // String user_type = user[3];

            // print(id);
            // print(email);
            // print(username);
            // print(user_type);
            

            String url1 = "http://127.0.0.1:8000/view-establishment/" + id + "";
            final response = await http.get(Uri.parse(url1));
            var responseData = json.decode(response.body);

            owner_id = responseData['owner'];
            // print(owner_id);
            // print("http://127.0.0.1:8000/get-one-user-using-id/" + owner_id + "/");
            String url2 = "http://127.0.0.1:8000/get-one-user-using-id/" + owner_id + "/";
            final response2 = await http.get(Uri.parse(url2));
            var responseData2 = json.decode(response2.body);

            response_Name = responseData['name'];
            response_Address = responseData['location_exact'];
            response2_firstname = responseData2['first_name'];

            response2_lastname = responseData2['last_name'];
            response2_ownerName = response2_firstname + " " + response2_lastname;
            response2_phone_no = responseData2['phone_no'];

            
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
          title: const Text(
            "All Accommodations",
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

        body: FutureBuilder(
          future: fetchData(), // Replace fetchData with your actual future function
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the data is being fetched, show a loading indicator
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If there's an error, display an error message
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            else { 
              return SingleChildScrollView(
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            height: 280,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              'assets/images/room_stock.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  favorite = !favorite;
                                  // add function to add accommodation to favorites
                                });
                              },
                              child: (favorite)
                                  ? Icon(
                                      Icons.bookmark_outline,
                                      size: 20,
                                    )
                                  : Icon(Icons.bookmark, size: 20),
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Color.fromARGB(255, 25, 83, 95))),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    //optional
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 35,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          response_Name,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                            style:
                                TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                    ],
                  ),
                  //Will be updated
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
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
                              response2_ownerName ?? "", 
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
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),

                  //CARD for ROOM Capacity/Type/Price
                  //On-going
                  //can't scroll for some reason
                  SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                          itemCount: 5,
                          pageSnapping: true,
                          itemBuilder: (context, pagePosition) {
                            return Scaffold(
                              body: Center(
                                  child: SizedBox(
                                height: 50,
                                child: PageView.builder(
                                  itemCount: 5,
                                  controller: PageController(viewportFraction: 0.7),
                                  onPageChanged: (int index) =>
                                      setState(() => _index = index),
                                  itemBuilder: (_, i) {
                                    return Transform.scale(
                                      scale: i == _index ? 1 : 0.9,
                                      child: Card(
                                        elevation: 6,
                                        child: Center(
                                            child: Text(
                                          "Card ${i + 1}",
                                          style: const TextStyle(fontSize: 20),
                                        )),
                                      ),
                                    );
                                  },
                                ),
                              )),
                            );
                          })),

                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                ],
                ),
              );
              }
            },
            ),
          );
        }
      }



/*



        class AcomCarousel extends _AccommPageState {
  int _index = 1;
  @override
  Widget build(BuildContext context) {
    return 
        Scaffold(
          appBar: AppBar(),
          body: Center(
              child: SizedBox(
            height: 50,
            child: PageView.builder(
              itemCount: 5,
              controller: PageController(viewportFraction: 0.7),
              onPageChanged: (int index) => setState(() => _index = index),
              itemBuilder: (_, i) {
                return Transform.scale(
                  scale: i == _index ? 1 : 0.9,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: Text(
                      "Card ${i + 1}",
                      style: const TextStyle(fontSize: 32),
                    )),
                  ),
                );
              },
            ),
          )),
        );
  }
}


                    body: Center(
                        child: SizedBox(
                      height: 50,
                      child: PageView.builder(
                        itemCount: 5,
                        controller: PageController(viewportFraction: 0.7),
                        onPageChanged: (int index) =>
                            setState(() => _index = index),
                        itemBuilder: (_, i) {
                          return Transform.scale(
                            scale: i == _index ? 1 : 0.9,
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                  child: Text(
                                "Card ${i + 1}",
                                style: const TextStyle(fontSize: 32),
                              )),
                            ),
                          );
                        },
                      ),
                    )),
Container(
                    
                    margin: const EdgeInsets.all(2),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          "Card 1",
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  );
*/