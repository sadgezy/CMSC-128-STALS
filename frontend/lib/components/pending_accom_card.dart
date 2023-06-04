import 'package:flutter/material.dart';

class PendingAccomCard extends StatefulWidget {
  final String accomName;
  final String ownerName;
  final bool verified;
  final String ID;
  final VoidCallback onApproved;
  final VoidCallback onDisapproved;

  PendingAccomCard({
    Key? key,
    required this.accomName,
    required this.ownerName,
    required this.verified,
    required this.ID,
    required this.onApproved,
    required this.onDisapproved,
  }) : super(key: key);

  @override
  State<PendingAccomCard> createState() => _PendingAccomCardState();

    factory PendingAccomCard.fromJson(Map<String, dynamic> json,VoidCallback onApprovedCallback,VoidCallback onDisapprovedCallback) {
    return PendingAccomCard(
      accomName: json['name'] ?? '',
      ownerName: json['owner'] ?? '',
      verified: json['verified'] ?? false,
      ID: json['_id'] ?? '',
      onApproved: onApprovedCallback,
      onDisapproved: onDisapprovedCallback,
    );
  }
}

class _PendingAccomCardState extends State<PendingAccomCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Padding(
            padding: EdgeInsets.all(5),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  widget.accomName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Text(
                widget.ownerName,
                style: const TextStyle(fontSize: 14),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 243, 245),
                        borderRadius: BorderRadius.circular(5)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        foregroundColor: const Color(0xff19535F),
                        backgroundColor:
                            const Color.fromARGB(255, 240, 243, 245),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          size: 35,
                          color: Color(0xff19535F),
                        ),
                      ),
                      onPressed: () {widget.onApproved();},
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 243, 245),
                        borderRadius: BorderRadius.circular(5)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        foregroundColor: const Color(0xff7B2D26),
                        backgroundColor:
                            const Color.fromARGB(255, 240, 243, 245),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 35,
                        color: Color(0xff7B2D26),
                      ),
                      onPressed: () {widget.onDisapproved();},
                    ),
                  ),
                ],
              ),
            )));
  }
}
