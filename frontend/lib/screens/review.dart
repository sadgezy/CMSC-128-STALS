import 'package:flutter/material.dart';
import '../../../UI_parameters.dart' as UIParameter;
import 'dart:convert';
import 'package:http/http.dart' as http;

class Review extends StatefulWidget {
  final String accommName;
  final String estabId;
  final String username;
  final String userId;
  const Review(
      {Key? key,
      required this.accommName,
      required this.estabId,
      required this.username,
      required this.userId})
      : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  String reviewContent = "";
  // current value of the TextField.
  final reviewController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("Estab ID: ${widget.estabId}");
    // print("User ID: ${widget.userId}");
    // print("Username: ${widget.username}");
    // get the height and width of the device
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String accomName = widget.accommName;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Leave a Review'),
          backgroundColor: UIParameter.LIGHT_TEAL,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Center(
                child: ConstrainedBox(
                    constraints: new BoxConstraints(maxWidth: 550.0),
                    child: SizedBox(
                      height: screenHeight - 100,
                      width: screenWidth,
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsetsDirectional.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                                child: Text(
                                  accomName,
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w600,
                                    fontFamily: UIParameter.FONT_REGULAR,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: UIParameter.LIGHT_TEAL)),
                                child: TextField(
                                  maxLength: 500,
                                  maxLines: 7,
                                  controller: reviewController,
                                  cursorColor: Colors.green,
                                  style: TextStyle(
                                    fontSize: UIParameter.FONT_HEADING_SIZE,
                                    color: Colors.grey[800],
                                    fontFamily: UIParameter.FONT_REGULAR,
                                  ),
                                  decoration: const InputDecoration(
                                      hintText: "Describe your experience!",
                                      border: InputBorder.none),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      // FUNCTION TO DO WHEN PRESSED/CLICKED
                                      String url =
                                          "http://127.0.0.1:8000/review-establishment/";
                                      final response = await json.decode(
                                          (await http
                                                  .post(Uri.parse(url), body: {
                                        "user_id": widget.userId,
                                        "establishment_id": widget.estabId,
                                        "username": widget.username,
                                        "body": reviewController.text
                                      }))
                                              .body);

                                      // TODO: make snackbar display only when response is successful
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "You have successfully left a review!")));
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/accomm',
                                          arguments: widget.estabId);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: UIParameter.MAROON,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: UIParameter.FONT_REGULAR,
                                      ),
                                    ),
                                    child: const Text(
                                      "Submit",
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )))));
  }
}
