import 'package:flutter/material.dart';

class VerificationBanner extends StatelessWidget {
  final String verificationStatus;

  const VerificationBanner({
    Key? key,
    required this.verificationStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.08,
      width: width,
      decoration: BoxDecoration(
        color:
            verificationStatus == "rejected" || verificationStatus == "pending"
                ? Colors.red
                : verificationStatus == "accepted"
                    ? Colors.blue
                    : Colors.green,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Center(
        child: Text(
          verificationStatus == "rejected"
              ? "Sorry, your account's verification was declined. Please resubmit your ID."
              : verificationStatus == "accepted"
                  ? "Your identity has been verified."
                  : "Your account's verification is under review. Please wait.",
          style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
