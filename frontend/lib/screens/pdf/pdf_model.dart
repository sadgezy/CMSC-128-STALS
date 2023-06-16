import 'package:http/http.dart' as http;
import 'dart:convert';

class Room {
  String priceLower;
  String priceUpper;
  String capacity;
  bool available;

  Room(this.priceLower, this.priceUpper, this.capacity, this.available);
}

class PDFData {
  String estabName;
  String image;
  String description;
  // String approxLoc;
  String exactLoc;
  String estabType;
  String tenantType;
  String ownerName;
  String ownerContact;
  String ownerEmail;
  String utilities;
  List<Room> rooms;

  PDFData(
      this.estabName,
      this.image,
      // this.approxLoc,
      this.description,
      this.exactLoc,
      this.estabType,
      this.tenantType,
      this.ownerName,
      this.ownerContact,
      this.ownerEmail,
      this.utilities,
      this.rooms);
}

Future<PDFData> createPDFData(String estabID) async {
  String url1 = "http://127.0.0.1:8000/view-establishment/" + estabID + "/";
  final response = await http.get(Uri.parse(url1));
  var responseData = json.decode(response.body);

  String estabName = responseData["name"];
  String image = responseData["loc_picture"];
  String description = responseData["description"];
  String exactLoc = responseData["location_exact"];
  String estabType = responseData["establishment_type"];
  String tenantType = responseData["tenant_type"];
  String utilities = responseData["utilities"];

  // for (String s in responseData["utilities"]) {
  //   utilities = utilities + s;
  // }

  String url2 = "http://127.0.0.1:8000/get-one-user-using-id/" +
      responseData["owner"] +
      "/";
  final response2 = await http.get(Uri.parse(url2));
  var responseData2 = json.decode(response2.body);

  String ownerName = responseData2['first_name'];
  String ownerContact = responseData2['phone_no'];
  String ownerEmail = responseData2['email'];

  String url3 = "http://127.0.0.1:8000/search-room/";
  final response3 = await json.decode((await http.post(Uri.parse(url3),
          body: {"establishment_id": estabID, "user_type": "user"}))
      .body);

  List<Room> R = [];

  for (int i = 0; i < response3.length; i++) {
    if (response3[i]["availability"]) {
      R.insert(
          0,
          Room(
              response3[i]["price_lower"].toString(),
              response3[i]["price_upper"].toString(),
              response3[i]["capacity"].toString(),
              response3[i]["availability"]));
    } else {
      R.add(Room(
          response3[i]["price_lower"].toString(),
          response3[i]["price_upper"].toString(),
          response3[i]["capacity"].toString(),
          response3[i]["availability"]));
    }
  }

  return PDFData(estabName, image, exactLoc, description, estabType, tenantType,
      ownerName, ownerContact, ownerEmail, utilities, R);
}
