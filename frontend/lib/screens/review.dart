import 'package:flutter/material.dart';
import '../../../UI_parameters.dart' as UIParameter;

class Review extends StatefulWidget {
  final String accommName;
  const Review({
    Key? key,
    required this.accommName,
  }) : super(key: key);

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
    // get the height and width of the device
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String accomName = widget.accommName;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Write a Review'),
          backgroundColor: UIParameter.LIGHT_TEAL,
          elevation: 0,
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
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: UIParameter.LIGHT_TEAL)),
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
                          hintText: "Describe your experience",
                          border: InputBorder.none),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // FUNCTION TO DO WHEN PRESSED/CLICKED
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
        ));
  }
}
