import 'package:flutter/material.dart';
import 'package:stals_frontend/UI_parameters.dart' as UIParams;

class ReportListing extends StatefulWidget {
  final TextEditingController tags;
  const ReportListing({super.key, required this.tags});

  @override
  State<ReportListing> createState() => _ReportListingState();
}

class _ReportListingState extends State<ReportListing> {
  int value = 0;
  Widget CustomRadioButton(String text, int index) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
          height: 50,
          width: 200,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                value = index;
              });
              widget.tags.text = index.toString();
            },
            child: Text(
              text,
              style: TextStyle(
                color: (value == index) ? UIParams.MAROON : Colors.black,
              ),
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              side: BorderSide(
                  color: (value == index) ? UIParams.MAROON : Colors.black,
                  width: 2),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomRadioButton("Inactive Owner", 1),
        CustomRadioButton("Inaccurate Details", 2),
        CustomRadioButton("Fraudulent Listing", 3),
        CustomRadioButton("Offensive Content", 4),
        CustomRadioButton("Other Reason", 5),
      ],
    );
  }
}
