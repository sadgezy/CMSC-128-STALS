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

  const AccomCard({Key? key, required this.details}) : super(key: key);
  final AccomCardDetails details;

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
  Future<bool> checkIfAccommodationIsFavorite(String id, String email) async {
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

    return Future.value(decodedResponse.contains(id));
  }



  Future<void> getUserInfo() async {
    user = Provider.of<UserProvider>(context, listen: false).userInfo;
    id = user[0];
    email = user[1];
    username = user[2];
    user_type = user[3];
  }

  @override
  Widget build(BuildContext context) {
    getUserInfo();
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
                      blurRadius: 3,
                      offset: Offset(3, 5))
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
                            width: (MediaQuery.of(context).size.width - 40) / 2,
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
                                    Image.memory(
                                      Uri.parse(widget.details.getImage())
                                          .data!
                                          .contentAsBytes(),
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
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            height: (MediaQuery.of(context).size.width / 3),
                            child: ClipRRect(
                                // round the left edges of the image to match the card
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                                child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Image.memory(
                                        Uri.parse(widget.details.getImage())
                                            .data!
                                            .contentAsBytes()))),
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
                                  fontSize: (MediaQuery.of(context).size.width *
                                      0.05),
                                  fontFamily: UIParameter.FONT_REGULAR,
                                  // w600 is semibold
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Text(
                              widget.details.getDescription(),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  fontFamily: UIParameter.FONT_REGULAR),
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
                            isAdmin || user_type == "owner"
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              isFavorite = !isFavorite;
                                            });
                                            addAccommodationToFavorites(
                                                widget.details.getID());
                                          },
                                          // OLD FAVORITE ICON
                                          // check if part of favorite accomms
                                          // child: isFavorite
                                          //     ? Icon(
                                          //         Icons.favorite,
                                          //         color: UIParameter.MAROON,
                                          //         size: MediaQuery.of(context)
                                          //                 .size
                                          //                 .width *
                                          //             0.05,
                                          //       )
                                          //     : Icon(
                                          //         Icons
                                          //             .favorite_outline_rounded,
                                          //         color: Colors.grey,
                                          //         size: MediaQuery.of(context)
                                          //                 .size
                                          //                 .width *
                                          //             0.05,
                                          //       ))

                                          // ISSUE: FUTURE BUILDER IS STILL NOT WORKING
                                          child: FutureBuilder(
                                            future: checkIfAccommodationIsFavorite(widget.details.getID(), email),
                                            builder: (context, snapshot) {
                                              print("$isFavorite " + snapshot.data.toString());
                                              if (snapshot.hasData) {
                                                if (snapshot.data!) {
                                                  return Icon(
                                                    Icons.favorite,
                                                    color: UIParameter.MAROON,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                  );
                                                } else {
                                                  return Icon(
                                                    Icons
                                                        .favorite_outline_rounded,
                                                    color: Colors.grey,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                  );
                                                }
                                              } else {
                                                return Icon(
                                                  Icons
                                                      .favorite_outline_rounded,
                                                  color: Colors.grey,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                );
                                              }
                                            },
                                            )),
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
    }
}
