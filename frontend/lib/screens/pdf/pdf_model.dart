class Room {
  int price;
  int capacity;
  bool available;

  Room (
    this.price,
    this.capacity,
    this.available
  );
}

class PDFData {
  String estabName;
  String image;
  String approxLoc;
  String exactLoc;
  String estabType;
  String tenantType;
  String ownerContact;
  String ownerEmail;
  String utilities;
  // List<Room> rooms;

  PDFData(
    this.estabName,
    this.image,
    this.approxLoc,
    this.exactLoc,
    this.estabType,
    this.tenantType,
    this.ownerContact,
    this.ownerEmail,
    this.utilities,
    // this.rooms
  );  
}

