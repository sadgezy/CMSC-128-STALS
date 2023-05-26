import 'package:flutter/material.dart';
import '../../classes.dart';
import '../../UI_parameters.dart' as UIParameter;
// COMPONENTS
import '../../components/accom_card.dart';
import '../../components/search_bar.dart' as sb;

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
      "Example Description", "assets/images/room_stock.jpg", 3,true, false);
  var accom2 = AccomCardDetails(
      'test1234',
      'Casa Del Mar',
      'Casa Del Mar is located at Sapphire street.',
      "assets/images/room_stock.jpg",
      5,true,false);

  late List<AccomCardDetails> favorites = [accom, accom2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: UIParameter.MAROON,
        elevation: 0,
      ),
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
