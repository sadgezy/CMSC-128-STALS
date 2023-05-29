import 'package:flutter/material.dart';
import '../../UI_parameters.dart' as UIParameter;

class PendingUserCard extends StatefulWidget {
  final String name;
  // TODO: image
  const PendingUserCard({super.key, required this.name});

  @override
  State<PendingUserCard> createState() => _PendingUserCardState();
}

class _PendingUserCardState extends State<PendingUserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: UIParameter.WHITE,
            borderRadius: UIParameter.CARD_BORDER_RADIUS),
        width: (MediaQuery.of(context).size.width),
        height: 58,
        child: Row(children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width - 40) / 7,
            child: const Icon(Icons.person_pin_sharp,
                size: 34, color: Colors.black87),
          ),
          SizedBox(
              width: (MediaQuery.of(context).size.width - 40) * 2 / 7,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.name,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: UIParameter.FONT_HEADING_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR,
                                fontWeight: FontWeight.w600))),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tap to know more",
                            style: TextStyle(
                                fontSize: UIParameter.FONT_BODY_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR)))
                  ],
                ),
              )),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 40) * 4 / 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: UIParameter.DARK_TEAL,
                        borderRadius: UIParameter.CARD_BORDER_RADIUS),
                    width: 71.17,
                    height: 21,
                    child: Align(
                        child: Text("APPROVE",
                            style: TextStyle(
                                color: UIParameter.WHITE,
                                fontSize: UIParameter.FONT_BODY_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR,
                                fontWeight: FontWeight.w600)))),
                const SizedBox(width: 10),
                Container(
                    decoration: BoxDecoration(
                        color: UIParameter.MAROON,
                        borderRadius: UIParameter.CARD_BORDER_RADIUS),
                    width: 71.17,
                    height: 21,
                    child: Align(
                        child: Text("DELETE",
                            style: TextStyle(
                                color: UIParameter.WHITE,
                                fontSize: UIParameter.FONT_BODY_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR,
                                fontWeight: FontWeight.w600)))),
                const SizedBox(width: 10)
              ],
            ),
          ),
        ]));
  }
}

class VerifiedUserCard extends StatefulWidget {
  final String name;
  // TODO: image
  const VerifiedUserCard({super.key, required this.name});

  @override
  State<VerifiedUserCard> createState() => _VerifiedUserCardState();
}

class _VerifiedUserCardState extends State<VerifiedUserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: UIParameter.WHITE,
            borderRadius: UIParameter.CARD_BORDER_RADIUS),
        width: (MediaQuery.of(context).size.width),
        height: 58,
        child: Row(children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width - 40) / 7,
            child: const Icon(Icons.person_pin_sharp,
                size: 34, color: Colors.black87),
          ),
          SizedBox(
              width: (MediaQuery.of(context).size.width - 40) * 4 / 7,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.name,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: UIParameter.FONT_HEADING_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR,
                                fontWeight: FontWeight.w600))),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tap to know more",
                            style: TextStyle(
                                fontSize: UIParameter.FONT_BODY_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR)))
                  ],
                ),
              )),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 40) * 2 / 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: UIParameter.MAROON,
                        borderRadius: UIParameter.CARD_BORDER_RADIUS),
                    width: 71.17,
                    height: 21,
                    child: Align(
                        child: Text("ARCHIVE",
                            style: TextStyle(
                                color: UIParameter.WHITE,
                                fontSize: UIParameter.FONT_BODY_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR,
                                fontWeight: FontWeight.w600)))),
                const SizedBox(width: 10)
              ],
            ),
          ),
        ]));
  }
}

class ArchiveUserCard extends StatefulWidget {
  final String name;
  // TODO: image
  const ArchiveUserCard({super.key, required this.name});

  @override
  State<ArchiveUserCard> createState() => _ArchiveUserCardState();
}

class _ArchiveUserCardState extends State<ArchiveUserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: UIParameter.WHITE,
            borderRadius: UIParameter.CARD_BORDER_RADIUS),
        width: (MediaQuery.of(context).size.width),
        height: 58,
        child: Row(children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width - 40) / 7,
            child: const Icon(Icons.person_pin_sharp,
                size: 34, color: Colors.black87),
          ),
          SizedBox(
              width: (MediaQuery.of(context).size.width - 40) * 2 / 7,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.name,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: UIParameter.FONT_HEADING_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR,
                                fontWeight: FontWeight.w600))),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tap to know more",
                            style: TextStyle(
                                fontSize: UIParameter.FONT_BODY_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR)))
                  ],
                ),
              )),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 40) * 4 / 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: UIParameter.DARK_TEAL,
                        borderRadius: UIParameter.CARD_BORDER_RADIUS),
                    width: 71.17,
                    height: 21,
                    child: Align(
                        child: Text("RESTORE",
                            style: TextStyle(
                                color: UIParameter.WHITE,
                                fontSize: UIParameter.FONT_BODY_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR,
                                fontWeight: FontWeight.w600)))),
                const SizedBox(width: 10),
                Container(
                    decoration: BoxDecoration(
                        color: UIParameter.MAROON,
                        borderRadius: UIParameter.CARD_BORDER_RADIUS),
                    width: 71.17,
                    height: 21,
                    child: Align(
                        child: Text("DELETE",
                            style: TextStyle(
                                color: UIParameter.WHITE,
                                fontSize: UIParameter.FONT_BODY_SIZE,
                                fontFamily: UIParameter.FONT_REGULAR,
                                fontWeight: FontWeight.w600)))),
                const SizedBox(width: 10)
              ],
            ),
          ),
        ]));
  }
}
