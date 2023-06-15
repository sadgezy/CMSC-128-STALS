import 'package:flutter/material.dart';
import '../../../UI_parameters.dart' as UIParameter;
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddRoom extends StatefulWidget {
  final String estabId;
  final String estabName;
  const AddRoom({Key? key, required this.estabId, required this.estabName})
      : super(key: key);

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  String reviewContent = "";
  // current value of the TextField.
  final minController = TextEditingController();
  final maxController = TextEditingController();
  final capacityController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    minController.dispose();
    maxController.dispose();
    capacityController.dispose();
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add room to ${widget.estabName}'),
          backgroundColor: UIParameter.LIGHT_TEAL,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
        ),
        body: SizedBox(
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
                      "",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                        fontFamily: UIParameter.FONT_REGULAR,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: UIParameter.LIGHT_TEAL)),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: minController,
                          cursorColor: Colors.green,
                          style: TextStyle(
                            fontSize: UIParameter.FONT_HEADING_SIZE,
                            color: Colors.grey[800],
                            fontFamily: UIParameter.FONT_REGULAR,
                          ),
                          decoration: const InputDecoration(
                              hintText: "Minimum Price",
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: UIParameter.LIGHT_TEAL)),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: maxController,
                          cursorColor: Colors.green,
                          style: TextStyle(
                            fontSize: UIParameter.FONT_HEADING_SIZE,
                            color: Colors.grey[800],
                            fontFamily: UIParameter.FONT_REGULAR,
                          ),
                          decoration: const InputDecoration(
                              hintText: "Maximum Price",
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: UIParameter.LIGHT_TEAL)),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: capacityController,
                          cursorColor: Colors.green,
                          style: TextStyle(
                            fontSize: UIParameter.FONT_HEADING_SIZE,
                            color: Colors.grey[800],
                            fontFamily: UIParameter.FONT_REGULAR,
                          ),
                          decoration: const InputDecoration(
                              hintText: "Capacity", border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // FUNCTION TO DO WHEN PRESSED/CLICKED
                          String url = "http://127.0.0.1:8000/add-room/";
                          final response = await json
                              .decode((await http.post(Uri.parse(url), body: {
                            "establishment_id": widget.estabId,
                            "price_lower": minController.text,
                            "price_upper": maxController.text,
                            "capacity": capacityController.text
                          }))
                                  .body);
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
                          "Confirm",
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
