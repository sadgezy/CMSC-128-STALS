import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../UI_parameters.dart' as UIParameter;
import '../classes.dart';
import 'dart:typed_data';
import 'dart:ui';

import 'package:provider/provider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccomCard extends StatefulWidget {
  /* Accom Card will accept an object that will contain
    - Accom ID
    - Accom name
    - Accom description
    - Accom rating
  */

  const AccomCard({Key? key, required this.details, required this.isFavorite, required this.func}) : super(key: key);
  final AccomCardDetails details;
  final bool isFavorite;
  final VoidCallback func;

  @override
  State<AccomCard> createState() => _AccomCardState();
}

class _AccomCardState extends State<AccomCard> {
  // TO-DO: the calling screen/component should get these details from DB and pass it to accom_card as an argument
  // temporary holders to determine if user is admin
  var isAdmin = false;
  // temporary holders to determine if post is part of user's favorite, or part of admin's archived accomms
  bool isFavorite = false;
  bool loading = true;
  bool checked = false;
  bool currFavorite = false;
  bool appliedBool = false;

  List<dynamic> user = [];
  String id = '';
  String email = '';
  String username = '';
  String user_type = '';

  Future<void> addAccommodationToFavorites(String id) async {
    String url = "http://127.0.0.1:8000/add-room-to-user-favorites/";
    final Map<String, dynamic> requestBody = {
      "email": email,
      "ticket_id": id,
    };
    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(requestBody),
    );
    final decodedResponse = json.decode(response.body);
    // Handle the decoded response or perform any necessary operations
  }

  // check if accommodation is part of user's favorites
  Future<void> checkIfAccommodationIsFavorite(String id, String email) async {
    String url = "http://127.0.0.1:8000/view-all-user-favorites/";
    final Map<String, dynamic> requestBody = {
      "email": email
    };
    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(requestBody),
    );
    
    var decodedResponse = json.decode(response.body);

    decodedResponse = decodedResponse.replaceAll("[", "");
    decodedResponse = decodedResponse.replaceAll("]", "");
    decodedResponse = decodedResponse.replaceAll("'", "");
    decodedResponse = decodedResponse.split(",");
    
    // check if id is in the list of user's favorites
    if (decodedResponse.contains(id)) {
      isFavorite = true;
    }
    else {
      isFavorite = false;
    }
    setState(() {
      loading = false;
      checked = true;
    });
  }



  Future<void> getUserInfo() async {
    user = Provider.of<UserProvider>(context, listen: false).userInfo;
    id = user[0];
    email = user[1];
    username = user[2];
    user_type = user[3];
  }

  Future<String> getImage() async {
    String url = "http://127.0.0.1:8000/get-loc-picture/";
    final response = await json.decode((await http.post(Uri.parse(url), body: {
      '_id': widget.details.getID(),
    }))
        .body);
    return response["loc_picture"];
  }

  @override
  Widget build(BuildContext context) {
    getUserInfo();
    Future<String> imageStr = getImage();
    if (!appliedBool) {
      currFavorite = widget.isFavorite;
      appliedBool = true;  
    }
    
    
    return FutureBuilder(
      future: imageStr,
      builder: (context, snapshot) {
        
        // if (user_type == "user" && !checked) {
        //   checkIfAccommodationIsFavorite(widget.details.getID(), email);
        // }
        // else {
        //   loading = false;
        // }
        // if (loading) return CircularProgressIndicator();

        return ConstrainedBox(
            constraints: new BoxConstraints(maxWidth: 550),
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: (MediaQuery.of(context).size.width - 40),
                  height: (MediaQuery.of(context).size.width / 3),
                  decoration: BoxDecoration(
                    color: widget.details.archived
                        ? const Color.fromARGB(255, 211, 211, 211)
                        : Colors.white,
                    borderRadius: UIParameter.CARD_BORDER_RADIUS,
                    // ignore: prefer_const_literals_to_create_immutables
                    boxShadow: [
                      // box shadow to get elevation effect
                      const BoxShadow(
                          color: Color.fromARGB(255, 200, 200, 200),
                          blurRadius: 2,
                          offset: Offset(2, 4))
                    ],
                  ),
                  // InkWell so card has onTap property
                  child: InkWell(
                    onTap: () {
                      // For now, redirect to sign up page.
                      // if (widget.details.ID is in the list of the signed in user's owned accomms) {
                      //   Navigator.pushNamed(context, '/owned/accomm');
                      // } else {
                      Navigator.pushNamed(context, '/accomm',
                          arguments: widget.details.getID());
                      // }
                    },
                    child: Row(
                      children: [
                        // 2 Sized boxes to split the card in half
                        // left side for image
                        // right side for name, description, and rating
                        widget.details.archived
                            ? SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width - 40) /
                                        2,
                                height: (MediaQuery.of(context).size.width / 3),
                                child: ClipRRect(
                                  // round the left edges of the image to match the card
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            if (snapshot.hasError) Text('Error = ${snapshot.error}'),
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting)
                                              SizedBox(
                                                width: (300),
                                                height: (200),
                                                child: Center(child: CircularProgressIndicator())),
                                            if (snapshot.connectionState !=
                                                ConnectionState.waiting)
                                              Image.memory(
                                                Uri.parse(snapshot.data!)
                                                    .data!
                                                    .contentAsBytes(),
                                              )
                                          ],
                                        ),
                                        BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10,
                                              sigmaY:
                                                  10), // Adjust the sigma values for desired blur strength
                                          child: Container(
                                            color: Colors.black.withOpacity(
                                                0), // Adjust the opacity for desired blur intensity
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width - 40) /
                                        2,
                                height: (MediaQuery.of(context).size.width / 3),
                                child: ClipRRect(
                                    // round the left edges of the image to match the card
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15)),
                                    child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Column(
                                          children: [
                                            if (snapshot.hasError) Text('Error = ${snapshot.error}'),
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting)
                                              SizedBox(
                                                width: (300),
                                                height: (200),
                                                child: Center(child: CircularProgressIndicator())),
                                            if (snapshot.connectionState !=
                                                ConnectionState.waiting)
                                              Image.memory(
                                                Uri.parse(snapshot.data!)
                                                    .data!
                                                    .contentAsBytes(),
                                              )
                                          ],
                                        ))),
                              ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 40) / 2,
                          height: (MediaQuery.of(context).size.width / 3),
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.details.getName(),
                                  style: TextStyle(
                                      fontSize:
                                          (MediaQuery.of(context).size.width *
                                              0.05),
                                      fontFamily: UIParameter.FONT_REGULAR,
                                      // w600 is semibold
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.details.getDescription(),
                                    style: TextStyle(
                                        overflow: TextOverflow.fade,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.027,
                                        fontFamily: UIParameter.FONT_REGULAR),
                                  ),
                                ),
                                widget.details.archived
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .red, // Choose a color that stands out
                                          borderRadius: BorderRadius.circular(
                                              8.0), // Adjust the border radius as per your preference
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                            horizontal:
                                                8.0), // Adjust padding as per your preference
                                        child: const Text(
                                          'ARCHIVED',
                                          style: TextStyle(
                                            color: Colors
                                                .white, // Choose a contrasting text color
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                // if admin only display rating
                                user_type == "admin" || user_type == "owner" || user_type == "guest"
                                    ? Container()
                                    // ? RatingBar.builder(
                                    //     minRating: 0,
                                    //     maxRating: 5,
                                    //     initialRating: widget.details.getRating(),
                                    //     direction: Axis.horizontal,
                                    //     allowHalfRating: false,

                                    //     // ignore gestures to make rating un-editable
                                    //     ignoreGestures: true,
                                    //     onRatingUpdate: (rating) {
                                    //       /* CANNOT RATE HERE */
                                    //     },
                                    //     itemSize: 18,
                                    //     itemBuilder: (BuildContext context, int index) =>
                                    //         const Icon(
                                    //           Icons.star,
                                    //           color: Colors.amber,
                                    //         ))
                                    // else add favorite icon
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // RatingBar.builder(
                                          //     minRating: 0,
                                          //     maxRating: 5,
                                          //     initialRating: widget.details.getRating(),
                                          //     direction: Axis.horizontal,
                                          //     allowHalfRating: false,

                                          //     // ignore gestures to make rating un-editable
                                          //     ignoreGestures: true,
                                          //     onRatingUpdate: (rating) {
                                          //       /* CANNOT RATE HERE */
                                          //     },
                                          //     itemSize: 18,
                                          //     itemBuilder:
                                          //         (BuildContext context, int index) =>
                                          //             const Icon(
                                          //               Icons.star,
                                          //               color: Colors.amber,
                                          //             )),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isFavorite = !isFavorite;
                                                  currFavorite = !currFavorite;
                                                });
                                                addAccommodationToFavorites(
                                                    widget.details.getID());
                                                widget.func();
                                                //print(currFavorite);
                                              },
                                              // check if part of favorite accomms
                                              child: currFavorite
                                                  ? Icon(
                                                      Icons.favorite,
                                                      color: UIParameter.MAROON,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .favorite_outline_rounded,
                                                      color: Colors.grey,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                    ))
                                        ],
                                      )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )));
      },
    );
  }
}
