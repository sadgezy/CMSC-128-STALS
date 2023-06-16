// code copied from: https://github.com/abuanwar072/Welcome-Login-Signup-Page-Flutter/blob/master/lib/components/rounded_button.dart
import 'package:flutter/material.dart';
import '../UI_parameters.dart' as UIParameter;

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  const CustomSearchBar({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: TextField(
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          cursorColor: UIParameter.LIGHT_TEAL,
          style: const TextStyle(
              fontSize: 18, fontFamily: UIParameter.FONT_REGULAR),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintMaxLines: 1,
            border: InputBorder.none,
          ),
        ));
  }
}
