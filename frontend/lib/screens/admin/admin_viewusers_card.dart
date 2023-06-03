import 'package:flutter/material.dart';
import '../../UI_parameters.dart' as UIParameter;
import 'package:dio/dio.dart';
import 'package:stals_frontend/screens/admin/profile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stals_frontend/screens/admin/admin_view_reports.dart';


class PendingUserCard extends StatefulWidget {
  final String name;
  final String userId;
  final VoidCallback fetchUnverifiedUsers;                  
  // TODO: image
  // const PendingUserCard({super.key, required this.name});

  const PendingUserCard({Key? key, required this.name, required this.userId, required this.fetchUnverifiedUsers,}) : super(key: key);

  @override
  State<PendingUserCard> createState() => _PendingUserCardState();
}


class _PendingUserCardState extends State<PendingUserCard> {
  
  void verifyUser() async {
    try {
      
      Response response = await Dio().put('http://127.0.0.1:8000/verify-user/${widget.userId}/');

      if (response.statusCode == 200) {
        print('User approved successfully!');
        
        widget.fetchUnverifiedUsers(); 
      } else {
        print('Failed to approve user');
      }

    } catch (error) {
      print(error.toString());
    }
  }

  void deleteUser() async {
    try {
      Response response = await Dio().delete('http://127.0.0.1:8000/delete-user/${widget.userId}/');

      if (response.statusCode == 200) {
        print('User deleted successfully!');
        
        widget.fetchUnverifiedUsers(); 
      } else {
        print('Failed to delete user');
      }

    } catch (error) {
      print(error.toString());
    }
  }

  //---------------------------
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context) {
          return Profile(userId: widget.userId,);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: UIParameter.WHITE,
          borderRadius: UIParameter.CARD_BORDER_RADIUS,
        ),
        width: MediaQuery.of(context).size.width,
        height: 58,
        child: Row(
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width - 40) / 7,
              child: const Icon(Icons.person_pin_sharp, size: 34, color: Colors.black87),
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
                      child: Text(
                        widget.name,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: UIParameter.FONT_HEADING_SIZE,
                          fontFamily: UIParameter.FONT_REGULAR,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Tap to know more",
                        style: TextStyle(
                          fontSize: UIParameter.FONT_BODY_SIZE,
                          fontFamily: UIParameter.FONT_REGULAR,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width - 40) * 4 / 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
    
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UIParameter.DARK_TEAL,
                      shape: RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(UIParameter.CARD_BORDER_RADIUS),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      verifyUser();
                    },
                    child: Text(
                      "APPROVE",
                      style: TextStyle(
                        color: UIParameter.WHITE,
                        fontSize: UIParameter.FONT_BODY_SIZE,
                        fontFamily: UIParameter.FONT_REGULAR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
    
                  const SizedBox(width: 10),
    
    
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UIParameter.MAROON,
                      shape: RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(UIParameter.CARD_BORDER_RADIUS),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      deleteUser();
                    },
                    child: Text(
                      "DELETE",
                      style: TextStyle(
                        color: UIParameter.WHITE,
                        fontSize: UIParameter.FONT_BODY_SIZE,
                        fontFamily: UIParameter.FONT_REGULAR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
    
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class _PendingUserCardState extends State<PendingUserCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//             color: UIParameter.WHITE,
//             borderRadius: UIParameter.CARD_BORDER_RADIUS),
//         width: (MediaQuery.of(context).size.width),
//         height: 58,
//         child: Row(children: [
//           SizedBox(
//             width: (MediaQuery.of(context).size.width - 40) / 7,
//             child: const Icon(Icons.person_pin_sharp,
//                 size: 34, color: Colors.black87),
//           ),
//           SizedBox(
//               width: (MediaQuery.of(context).size.width - 40) * 2 / 7,
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(widget.name,
//                             softWrap: false,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                                 fontSize: UIParameter.FONT_HEADING_SIZE,
//                                 fontFamily: UIParameter.FONT_REGULAR,
//                                 fontWeight: FontWeight.w600))),
//                     const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text("Tap to know more",
//                             style: TextStyle(
//                                 fontSize: UIParameter.FONT_BODY_SIZE,
//                                 fontFamily: UIParameter.FONT_REGULAR)))
//                   ],
//                 ),
//               )),
//           SizedBox(
//             width: (MediaQuery.of(context).size.width - 40) * 4 / 7,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               //----------------------------------------------------
//               children: [
//                 Container(
//                     decoration: BoxDecoration(
//                         color: UIParameter.DARK_TEAL,
//                         borderRadius: UIParameter.CARD_BORDER_RADIUS),
//                     width: 71.17,
//                     height: 21,
//                     child: Align(
//                         child: Text("APPROVE",
//                             style: TextStyle(
//                                 color: UIParameter.WHITE,
//                                 fontSize: UIParameter.FONT_BODY_SIZE,
//                                 fontFamily: UIParameter.FONT_REGULAR,
//                                 fontWeight: FontWeight.w600)))),
//                 const SizedBox(width: 10),
//                 Container(
//                     decoration: BoxDecoration(
//                         color: UIParameter.MAROON,
//                         borderRadius: UIParameter.CARD_BORDER_RADIUS),
//                     width: 71.17,
//                     height: 21,
//                     child: Align(
//                         child: Text("DELETE",
//                             style: TextStyle(
//                                 color: UIParameter.WHITE,
//                                 fontSize: UIParameter.FONT_BODY_SIZE,
//                                 fontFamily: UIParameter.FONT_REGULAR,
//                                 fontWeight: FontWeight.w600)))),
//                 const SizedBox(width: 10)
//               ],
//               //----------------------------------------------------
//             ),
//           ),
//         ]));
//   }
// }

class VerifiedUserCard extends StatefulWidget {
  final String name;
  final String userId;
  final VoidCallback fetchVerifiedUsers;   
  // TODO: image
  
  // const VerifiedUserCard({super.key, required this.name});
  const VerifiedUserCard({Key? key, required this.name, required this.userId, required this.fetchVerifiedUsers,}) : super(key: key);

  @override
  State<VerifiedUserCard> createState() => _VerifiedUserCardState();
}

class _VerifiedUserCardState extends State<VerifiedUserCard> {

  void archiveUser() async {
    try {
      Response response = await Dio().put('http://127.0.0.1:8000/archive-user/${widget.userId}/');

      if (response.statusCode == 200) {
        print('User archived successfully!');
        
        widget.fetchVerifiedUsers(); 
      } else {
        print('Failed to archived user');
      }

    } catch (error) {
      print(error.toString());
    }
  }


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

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UIParameter.MAROON,
                    shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(UIParameter.CARD_BORDER_RADIUS),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    archiveUser();
                  },
                  child: Text(
                    "ARCHIVE",
                    style: TextStyle(
                      color: UIParameter.WHITE,
                      fontSize: UIParameter.FONT_BODY_SIZE,
                      fontFamily: UIParameter.FONT_REGULAR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                            

              ],
            ),
          ),
        ]));
  }
}

class ArchiveUserCard extends StatefulWidget {
  final String name;
  final String userId;
  final VoidCallback fetchArchivedUsers;   
  // TODO: image
  
  const ArchiveUserCard({Key? key, required this.name, required this.userId, required this.fetchArchivedUsers,}) : super(key: key);

  @override
  State<ArchiveUserCard> createState() => _ArchiveUserCardState();
}

class _ArchiveUserCardState extends State<ArchiveUserCard> {

  void resolveReport() async {
    try {
      Response response = await Dio().put('http://127.0.0.1:8000/unarchive-user/${widget.userId}/');

      if (response.statusCode == 200) {
        print('User unarchived successfully!');
        
        widget.fetchArchivedUsers(); 
      } else {
        print('Failed to unarchived user');
      }

    } catch (error) {
      print(error.toString());
    }
  }

  void deleteUser() async {
    try {
      Response response = await Dio().delete('http://127.0.0.1:8000/delete-user/${widget.userId}/');

      if (response.statusCode == 200) {
        print('User deleted successfully!');
        
        widget.fetchArchivedUsers(); 
      } else {
        print('Failed to delete user');
      }

    } catch (error) {
      print(error.toString());
    }
  }

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

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UIParameter.DARK_TEAL,
                    shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(UIParameter.CARD_BORDER_RADIUS),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    resolveReport();
                  },
                  child: Text(
                    "RESTORE",
                    style: TextStyle(
                      color: UIParameter.WHITE,
                      fontSize: UIParameter.FONT_BODY_SIZE,
                      fontFamily: UIParameter.FONT_REGULAR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 10),


                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UIParameter.MAROON,
                    shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(UIParameter.CARD_BORDER_RADIUS),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    deleteUser();
                  },
                  child: Text(
                    "DELETE",
                    style: TextStyle(
                      color: UIParameter.WHITE,
                      fontSize: UIParameter.FONT_BODY_SIZE,
                      fontFamily: UIParameter.FONT_REGULAR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 10),
              ],
            ),
          ),
        ]));
  }
}


class TicketCard extends StatefulWidget {
  final String ticketId;
  final String name;
  final bool resolved;
  final VoidCallback fetchAllTickets;
  // TODO: image
  
  const TicketCard({Key? key, required this.ticketId, required this.name, required this.resolved, required this.fetchAllTickets}) : super(key: key);

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {

  void resolveReport() async {
    try {
      String url = "http://127.0.0.1:8000/resolve-report/";
      final response2 = await json.decode((await http.post(Uri.parse(url),
              body: {"_id": widget.ticketId}))
          .body);

      // TEMP SOL. Replace if better solution is found
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(builder: (context) => new ViewReportsPage()));
      

    } catch (error) {
      print(error.toString());
    }
  }

  void deleteReport() async {
    try {
      String url = "http://127.0.0.1:8000/delete-report/";
      final response2 = await json.decode((await http.post(Uri.parse(url),
              body: {"_id": widget.ticketId}))
          .body);
        
      // TEMP SOL. Replace if better solution is found
      Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(builder: (context) => new ViewReportsPage()));

    } catch (error) {
      print(error.toString());
    }
  }

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
            child: const Icon(Icons.flag_outlined,
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
                  ],
                ),
              )),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 40) * 4 / 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!widget.resolved)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UIParameter.DARK_TEAL,
                      shape: RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(UIParameter.CARD_BORDER_RADIUS),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      resolveReport();
                      widget.fetchAllTickets();
                    },
                    child: Text(
                      "RESOLVE",
                      style: TextStyle(
                        color: UIParameter.WHITE,
                        fontSize: UIParameter.FONT_BODY_SIZE,
                        fontFamily: UIParameter.FONT_REGULAR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (widget.resolved)
                  Text("RESOLVED"),
                const SizedBox(width: 10),


                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UIParameter.MAROON,
                    shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(UIParameter.CARD_BORDER_RADIUS),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    deleteReport();
                    widget.fetchAllTickets();
                  },
                  child: Text(
                    "DELETE",
                    style: TextStyle(
                      color: UIParameter.WHITE,
                      fontSize: UIParameter.FONT_BODY_SIZE,
                      fontFamily: UIParameter.FONT_REGULAR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 10),
              ],
            ),
          ),
        ]));
  }
}