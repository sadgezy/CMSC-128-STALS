import 'package:flutter/material.dart';
import '../../classes.dart';
import '../../UI_parameters.dart' as UIParameter;
// COMPONENTS
import '../../components/accom_card.dart';
import '../../components/search_bar.dart' as sb;
// import '../pdf/invoice.dart';
// import '../pdf/pdf_model.dart';
// import '../pdf/pdf_view.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  /*
  DUMMY OBJECTS
  <Object will come from database fetch later or from calling screen>
  */
  var accom = AccomCardDetails("jk23fvgw23", "Centtro Residences",
      "Example Description", "assets/images/room_stock.jpg", 3, false, true);

  var accom2 = AccomCardDetails(
      'test1234',
      'Casa Del Mar',
      'Casa Del Mar is located at Sapphire street.',
      "assets/images/room_stock.jpg",
      5,
      false,
      true);

  //DUMMY FOR PDF
  // List<PDFData> dummyData = [
  //   PDFData(
  //       "PDF 1",
  //       "assets/images/room_stock.jpg",
  //       "Within Campus",
  //       "11 L Street",
  //       "Dormitory",
  //       "Ceat Students.",
  //       "0000000",
  //       "gg@wp.com",
  //       "mabango"),
  //   PDFData(
  //       "PDF 2",
  //       "assets/images/room_stock.jpg",
  //       "Beyond Junction",
  //       "B7 L23 Jade St.",
  //       "House",
  //       "Working",
  //       "0000000",
  //       "gg@wp.com",
  //       "toilet"),
  // ];
  late List<AccomCardDetails> favorites = [accom, accom2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Favorites'),
          backgroundColor: UIParameter.MAROON,
          elevation: 0,
          actions: <Widget>[
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.save_alt),
                  color: UIParameter.WHITE,
                  onPressed: () async {
                  //   final service = PdfDocumentService();
                  //   final data = await service.createInvoice(dummyData);
                  //   var fpath = await service.savePdfFile("example", data);
                  //   // TODO: Fix;  Try moving the code above to pdf_view
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => PDFViewScreen(path: fpath)));
                  },
                );
              },
            )
          ]),
      body: SingleChildScrollView(
        child: Container(
          // get the height and width of the device
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          color: UIParameter.WHITE,
          child: ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return AccomCard(
                details: favorites[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
