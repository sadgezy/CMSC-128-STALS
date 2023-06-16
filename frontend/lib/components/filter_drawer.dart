import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../UI_parameters.dart' as UIParameter;
import '../classes.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({super.key, required this.filter, required this.callback});
  final Function(Filter) callback;
  final Filter filter;
  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  // variables that will hold the values of the filter that the user will choose

  double? rating;
  String? establishmentType;
  String? tenantType;
  final locationTextController = TextEditingController();
  final minPriceTextController = TextEditingController();
  final maxPriceTextController = TextEditingController();

  @override
  void initState() {
    rating = widget.filter.getRating();
    establishmentType = widget.filter.getEstablishmentType();
    tenantType = widget.filter.getTenantType();
    if (widget.filter.getLocation() != null) {
      locationTextController.text = widget.filter.getLocation();
    }
    if (widget.filter.getMinPrice() != null) {
      minPriceTextController.text = widget.filter.getMinPrice().toString();
    }
    if (widget.filter.getMaxPrice() != null) {
      maxPriceTextController.text = widget.filter.getMaxPrice().toString();
    }
  }

  // List of choices for rating, tenant types, and establishment types
  List<double> ratingChoices = [1, 2, 3, 4, 5];
  List<String> tenantChoices = [
    'Students',
    'Teachers',
    'Professionals',
    'Everyone'
  ];
  List<String> establishmentChoices = [
    'House',
    'Dormitory',
    'Apartment',
    'Transient',
    'Hotel'
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    locationTextController.dispose();
    maxPriceTextController.dispose();
    minPriceTextController.dispose();
    super.dispose();
  }

  // just a horizontal line that divides the filter choices
  Widget _customDivider() {
    return const Divider(
      height: 20,
      thickness: 1.25,
      color: Color.fromRGBO(0, 0, 0, 0.25),
    );
  }

  // builds the radio button groups for rating, tenant type, and establishment type
  Widget _buildRadios(String radioTitle, List<dynamic> choices) {
    dynamic groupVal;
    switch (radioTitle) {
      case "Rating":
        {
          groupVal = rating;
        }
        break;
      case "Establishment Type":
        {
          groupVal = establishmentType;
        }
        break;
      case "Tenant Type":
        {
          groupVal = tenantType;
        }
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            radioTitle,
            style: const TextStyle(
                fontFamily: UIParameter.FONT_REGULAR,
                fontSize: UIParameter.FONT_HEADING_SIZE),
          ),
        ),
        Column(
          children: [
            for (int i = 0; i < choices.length; i++)
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    //width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: RadioListTile(
                        activeColor: UIParameter.LIGHT_TEAL,
                        title: Text(
                          choices[i].toString(),
                          style: const TextStyle(
                              fontFamily: UIParameter.FONT_REGULAR,
                              fontSize: UIParameter.FONT_BODY_SIZE),
                        ),
                        // so the user can choose to select one or select none
                        toggleable: true,
                        value: choices[i],
                        groupValue: groupVal,
                        onChanged: (newVal) => setState(() {
                              switch (radioTitle) {
                                case "Rating":
                                  {
                                    rating = (newVal);
                                  }
                                  break;
                                case "Establishment Type":
                                  {
                                    establishmentType = newVal;
                                  }
                                  break;
                                case "Tenant Type":
                                  {
                                    tenantType = newVal;
                                  }
                                  break;
                              }
                            })),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
          ],
        )
      ],
    );
  }

  // builds the textboxes for location, min price, and max price
  Widget _buildTextBoxes(
      String displayText, TextEditingController controller, String input_type) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //width: MediaQuery.of(context).size.width * widthMultiplier,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType:
            input_type == 'number' ? TextInputType.number : TextInputType.text,
        cursorColor: UIParameter.LIGHT_TEAL,
        style: const TextStyle(
            fontSize: UIParameter.FONT_BODY_SIZE,
            fontFamily: UIParameter.FONT_REGULAR),
        decoration: InputDecoration(
          isDense: true,
          hintText: displayText,
          hintMaxLines: 1,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width * 0.25;
    const double drawerWidthMin = 200;
    return Drawer(
        // if screen is small, drawer width stays at 200
        // else if screen is large, draer takes up 25% of screen width
        width: drawerWidth < drawerWidthMin ? drawerWidthMin : drawerWidth,
        backgroundColor: UIParameter.WHITE,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  color: UIParameter.MAROON,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Filters",
                        style: TextStyle(
                            color: UIParameter.WHITE,
                            fontFamily: UIParameter.FONT_REGULAR,
                            fontSize: UIParameter.FONT_HEADING_SIZE),
                      )
                    ],
                  )),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Location",
                  style: TextStyle(
                      fontFamily: UIParameter.FONT_REGULAR,
                      fontSize: UIParameter.FONT_HEADING_SIZE),
                ),
              ),
              _buildTextBoxes("Enter Location", locationTextController, 'text'),
              _customDivider(),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Price Range",
                  style: TextStyle(
                      fontFamily: UIParameter.FONT_REGULAR,
                      fontSize: UIParameter.FONT_HEADING_SIZE),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text("MIN",
                        style: TextStyle(
                            fontFamily: UIParameter.FONT_REGULAR,
                            fontWeight: FontWeight.bold,
                            color: UIParameter.MAROON,
                            fontSize: UIParameter.FONT_BODY_SIZE)),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 150,
                    ),
                    child: _buildTextBoxes(
                        "Php", minPriceTextController, 'number'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text("MAX",
                        style: TextStyle(
                            fontFamily: UIParameter.FONT_REGULAR,
                            fontWeight: FontWeight.bold,
                            color: UIParameter.LIGHT_TEAL,
                            fontSize: UIParameter.FONT_BODY_SIZE)),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 150,
                    ),
                    child: _buildTextBoxes(
                        "Php", maxPriceTextController, 'number'),
                  ),
                ],
              ),
              _customDivider(),
              _buildRadios("Establishment Type", establishmentChoices),
              _customDivider(),
              _buildRadios("Tenant Type", tenantChoices),
              _customDivider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            rating = null;
                            tenantType = null;
                            establishmentType = null;
                            locationTextController.text = '';
                            minPriceTextController.text = '';
                            maxPriceTextController.text = '';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UIParameter.MAROON,
                          textStyle: const TextStyle(
                              fontSize: UIParameter.FONT_BODY_SIZE,
                              fontFamily: UIParameter.FONT_REGULAR),
                        ),
                        child: const Text('Reset')),
                    ElevatedButton(
                        onPressed: () {
                          // print for debug
                          //log("rating: ${rating}\ntenant: ${tenant_type}\nestab: ${establishment_type}\nloc: ${LocationTextController.text}\nmin: ${MinPriceTextController.text}\nmax: ${MaxPriceTextController.text}");

                          // create a new Filter object and pass the inputs or selections of the user
                          // when user has no input or selection, the value will be null
                          Filter newFilter = Filter(
                              rating?.toDouble(),
                              locationTextController.text == ''
                                  ? null
                                  : locationTextController.text,
                              establishmentType,
                              tenantType,
                              minPriceTextController.text == ''
                                  ? null
                                  : double.parse(minPriceTextController.text),
                              maxPriceTextController.text == ''
                                  ? null
                                  : double.parse(maxPriceTextController.text));
                          // callback to pass the Filter object containing the users inputs or selections back to homepage
                          widget.callback(newFilter);
                          Scaffold.of(context).closeEndDrawer();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UIParameter.LIGHT_TEAL,
                          textStyle: const TextStyle(
                              fontSize: UIParameter.FONT_BODY_SIZE,
                              fontFamily: UIParameter.FONT_REGULAR),
                        ),
                        child: const Text('Apply')),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }
}
