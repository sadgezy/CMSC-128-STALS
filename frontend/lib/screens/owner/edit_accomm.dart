import 'package:stals_frontend/components/rating.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../UI_parameters.dart' as UIParameter;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:toggle_switch/toggle_switch.dart';

import '../../classes.dart';

class EditAccomm extends StatefulWidget {
  const EditAccomm({super.key});
  @override
  _EditAccommState createState() => _EditAccommState();
}

/*
Edit Accom: Basically the same as Accom page but
: with textfieldforms for title/information/descripts/etc.. text boxes basically
: remove/add Highlight features

*/

//These checkurl is a check mark png if its available
// noturl is a not avaiable png
//not yet implemented to change so i'll comment out the image
const _checkurl = 'https://img.icons8.com/?size=512&id=11695&format=png';
const _noturl = 'https://img.icons8.com/?size=512&id=TfRrgMHDWJk3&format=png';

//data information:
class Item1 extends StatelessWidget {
  const Item1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.3,
                1
              ],
              colors: [
                Color(0xffff4000),
                Color(0xffffcc66),
              ]),
          // image: DecorationImage(
          //     fit: BoxFit.scaleDown,
          //     scale: 0.5,
          //     alignment: Alignment.center,
          //     image: NetworkImage(_checkurl)),
        ),
        child: Column(
          children: [
            SizedBox(
                width: 1000,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.king_bed_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 25,
                          width: 250,
                          child: TextFormField(
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: EdgeInsets.all(2),
                                labelText: 'Max Capacity',
                                labelStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 25,
                          width: 250,
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: EdgeInsets.all(5),
                                labelText: 'Min-Price ',
                                labelStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                          width: 250,
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: EdgeInsets.all(5),
                                labelText: 'Max-Price ',
                                labelStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text('Is this Room Available?',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(
                          width: 20,
                        ),
                        ToggleSwitch(
                          minWidth: 90.0,
                          cornerRadius: 20.0,
                          activeBgColors: [
                            [Colors.green[800]!],
                            [Colors.red[800]!]
                          ],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          initialLabelIndex: 1,
                          totalSwitches: 2,
                          labels: const ['Yes', 'No'],
                          radiusStyle: true,
                          onToggle: (index) {},
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ));
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 1],
            colors: [Color(0xff5f2c82), Color(0xff49a09d)]),
        // image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     scale: 0.5,
        //     alignment: Alignment.center,
        //     //couldnt use the image asset for some reason
        //     image: NetworkImage(_noturl))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(fontSize: 12, color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(2),
                  labelText: 'Max Capacity',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(5),
                  labelText: 'Min-Price ',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(5),
                  labelText: 'Max-Price ',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 5),
          const Text('Is this Room Available?',
              style: TextStyle(color: Colors.white)),
          const SizedBox(
            width: 20,
          ),
          ToggleSwitch(
            minWidth: 90.0,
            cornerRadius: 20.0,
            activeBgColors: [
              [Colors.green[800]!],
              [Colors.red[800]!]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            initialLabelIndex: 1,
            totalSwitches: 2,
            labels: const ['Yes', 'No'],
            radiusStyle: true,
            onToggle: (index) {},
          ),
        ],
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffff4000),
              Color(0xffffcc66),
            ]),
        // image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     scale: 0.5,
        //     alignment: Alignment.center,
        //     image: NetworkImage(_checkurl))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(fontSize: 12, color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(2),
                  labelText: 'Max Capacity',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(5),
                  labelText: 'Min-Price ',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(5),
                  labelText: 'Max-Price ',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 5),
          const Text('Is this Room Available?',
              style: TextStyle(color: Colors.white)),
          const SizedBox(
            width: 20,
          ),
          ToggleSwitch(
            minWidth: 90.0,
            cornerRadius: 20.0,
            activeBgColors: [
              [Colors.green[800]!],
              [Colors.red[800]!]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            initialLabelIndex: 1,
            totalSwitches: 2,
            labels: const ['Yes', 'No'],
            radiusStyle: true,
            onToggle: (index) {},
          ),
        ],
      ),
    );
  }
}

class Item4 extends StatelessWidget {
  const Item4({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // image: DecorationImage(
          //     fit: BoxFit.scaleDown,
          //     scale: 0.5,
          //     alignment: Alignment.center,
          //     image: NetworkImage(_checkurl))
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(fontSize: 12, color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(2),
                  labelText: 'Max Capacity',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(5),
                  labelText: 'Min-Price ',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(5),
                  labelText: 'Max-Price ',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 5),
          const Text('Is this Room Available?',
              style: TextStyle(color: Colors.white)),
          const SizedBox(
            width: 20,
          ),
          ToggleSwitch(
            minWidth: 90.0,
            cornerRadius: 20.0,
            activeBgColors: [
              [Colors.green[800]!],
              [Colors.red[800]!]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            initialLabelIndex: 1,
            totalSwitches: 2,
            labels: const ['Yes', 'No'],
            radiusStyle: true,
            onToggle: (index) {},
          ),
        ],
      ),
    );
  }
}

class Item5 extends StatelessWidget {
  const Item5({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color.fromARGB(255, 210, 80, 184),
              Color.fromARGB(255, 226, 203, 100)
            ]),
        // image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     scale: 0.5,
        //     alignment: Alignment.center,
        //     image: NetworkImage(_noturl))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(fontSize: 12, color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(2),
                  labelText: 'Max Capacity',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
                width: 75,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Min-Price ',
                      labelStyle: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(
                height: 25,
                width: 75,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Max-Price ',
                      labelStyle: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text('Is this Room Available?',
              style: TextStyle(color: Colors.white)),
          const SizedBox(
            width: 20,
          ),
          ToggleSwitch(
            minWidth: 90.0,
            cornerRadius: 20.0,
            activeBgColors: [
              [Colors.green[800]!],
              [Colors.red[800]!]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            initialLabelIndex: 1,
            totalSwitches: 2,
            labels: const ['Yes', 'No'],
            radiusStyle: true,
            onToggle: (index) {},
          ),
        ],
      ),
    );
  }
}

class Item6 extends StatelessWidget {
  const Item6({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color.fromARGB(255, 71, 151, 194),
              Color.fromARGB(255, 72, 210, 157)
            ]),
        // image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     scale: 0.5,
        //     alignment: Alignment.center,
        //     image: NetworkImage(_checkurl))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(fontSize: 12, color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(2),
                  labelText: 'Max Capacity',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
                width: 75,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Min-Price ',
                      labelStyle: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(
                height: 25,
                width: 75,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Max-Price ',
                      labelStyle: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text('Is this Room Available?',
              style: TextStyle(color: Colors.white)),
          const SizedBox(
            width: 20,
          ),
          ToggleSwitch(
            minWidth: 90.0,
            cornerRadius: 20.0,
            activeBgColors: [
              [Colors.green[800]!],
              [Colors.red[800]!]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            initialLabelIndex: 1,
            totalSwitches: 2,
            labels: const ['Yes', 'No'],
            radiusStyle: true,
            onToggle: (index) {},
          ),
        ],
      ),
    );
  }
}

class Item7 extends StatelessWidget {
  const Item7({Key? key}) : super(key: key);

  get onToggleButton => null;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color.fromARGB(255, 125, 85, 217),
              Color.fromARGB(255, 88, 111, 57)
            ]),
        // image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     scale: 0.5,
        //     alignment: Alignment.center,
        //     image: NetworkImage(_checkurl))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.king_bed_outlined,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 25,
            width: 150,
            child: TextFormField(
              style: const TextStyle(fontSize: 12, color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.all(2),
                  labelText: 'Max Capacity',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
                width: 75,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Min-Price ',
                      labelStyle: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(
                height: 25,
                width: 75,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Max-Price ',
                      labelStyle: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text('Is this Room Available?',
              style: TextStyle(color: Colors.white)),
          const SizedBox(
            width: 20,
          ),
          ToggleSwitch(
            minWidth: 90.0,
            cornerRadius: 20.0,
            activeBgColors: [
              [Colors.green[800]!],
              [Colors.red[800]!]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            initialLabelIndex: 1,
            totalSwitches: 2,
            labels: const ['Yes', 'No'],
            radiusStyle: true,
            onToggle: (index) {},
          ),
        ],
      ),
    );
  }
}

class Item extends StatefulWidget {
  const Item(
      {Key? key,
      required this.id,
      required this.availability,
      required this.priceLower,
      required this.priceUpper,
      required this.capacity,
      required this.index})
      : super(key: key);
  final String id;
  final int priceLower;
  final int priceUpper;
  final bool availability;
  final int capacity;
  final int index;

  @override
  State<Item> createState() => _ItemState();
}

// hintText: "${widget.capacity}",
// hintText: "${widget.priceLower} -  ${widget.priceUpper}",
// hintText: "${widget.priceUpper}",

class _ItemState extends State<Item> {
  String available = "";
  late Color color1;
  late Color color2;
  bool isAvailable = false;

  final TextEditingController maxTenantsController = TextEditingController();
  final TextEditingController priceLowerController = TextEditingController();
  final TextEditingController priceUpperController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController availability = TextEditingController();

  bool isEditing = false; // Track editing state
  bool switchValue = false;

  @override
  void initState() {
    super.initState();
    // Initialize switchValue based on widget.availability
    switchValue = widget.availability;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index % 4 == 0) {
      color1 = const Color(0xffff4000);
      color2 = const Color(0xffffcc66);
    } else if (widget.index % 4 == 1) {
      color1 = const Color(0xff5f2c82);
      color2 = const Color(0xff49a09d);
    } else if (widget.index % 4 == 2) {
      color1 = const Color.fromARGB(255, 17, 149, 21);
      color2 = const Color.fromARGB(255, 85, 94, 120);
    } else {
      color1 = Color.fromARGB(255, 32, 27, 26);
      color2 = Color.fromARGB(255, 232, 154, 53);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.3, 1],
          colors: [color1, color2],
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.king_bed_outlined,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 75,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 50,
                  ),
                  Text(
                    "${widget.index + 1}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 650.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "Max Capacity",
                    hintText: widget.capacity.toString(),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  ), // Enable/disable editing based on isEditing flag
                  controller: maxTenantsController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.priceLower == widget.priceUpper)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 650.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: "Price",
                      hintText: widget.priceLower.toString(),
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                    ), // Enable/disable editing based on isEditing flag
                    controller: priceController,
                    
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 300.0),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: "Price Lower",
                            hintText: widget.priceLower.toString(),
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 12.0),
                          ), // Enable/disable editing based on isEditing flag
                          controller: priceLowerController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 300.0),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: "Price Upper",
                            hintText: widget.priceUpper.toString(),
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 12.0),
                          ), // Enable/disable editing based on isEditing flag
                          controller: priceUpperController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Available",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Switch(
                      value: switchValue,
                      onChanged: (value) {
                        setState(() {
                          switchValue = value;
                        });
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.white.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () async {
                String url =
                    "http://127.0.0.1:8000/edit-room/" + widget.id + "/";
                if (widget.priceLower == widget.priceUpper) {
                  final Map<String, dynamic> requestBody = {
                    "availability": isAvailable,
                    "price_lower": priceController.text,
                    "price_upper": priceController.text,
                    "capacity": maxTenantsController.text,
                  };
                  final headers = {
                    'Content-Type': 'application/json',
                  };
                  final response = await http.put(Uri.parse(url),
                      headers: headers, body: json.encode(requestBody));
                } else {
                  final Map<String, dynamic> requestBody = {
                    "availability": isAvailable,
                    "price_lower": priceLowerController.text,
                    "price_upper": priceUpperController.text,
                    "capacity": maxTenantsController.text,
                  };
                  final headers = {
                    'Content-Type': 'application/json',
                  };
                  final response = await http.put(Uri.parse(url),
                      headers: headers, body: json.encode(requestBody));
                }
                Navigator.pushNamed(context, '/view_owned_accomms');
              },
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditAccommState extends State<EditAccomm> {
  double rating = 4.0;
  int _index = 1;
  bool favorite = false;
  bool showEditAccommError = false;
  int _currentIndex = 0;
  Future<void>? _accommodationsFuture;
  TextEditingController _controller = TextEditingController();
  TextEditingController _newEstablishmentNameController =
      TextEditingController();
  TextEditingController _newEstablishmentLocationController =
      TextEditingController();
  TextEditingController _newEstablishmentDescriptionController =
      TextEditingController();
  List cardList = [
    // const Item1(),
    // const Item2(),
    // const Item3(),
    // const Item4(),
    // const Item5(),
    // const Item6(),
    // const Item7()
  ];
  bool isLoading = true;

  var responseData;
  List<String> user = [];
  String user_id = '';
  String email = '';
  String username = '';
  String user_type = '';
  String response_Address = "";
  String response_Owner = "";
  String response_phoneNo = "";
  String response_Name = "";
  String owner_id = "";
  String id = "";
  String response_Description = "";

  @override
  void initState() {
    super.initState();
    // _accommodationsFuture = fetchData();
    // _userInfoFuture = fetchOwnedAccommodations();
  }

  Future<void> fetchData() async {
    // controller: emailController;
    List<dynamic> user =
        Provider.of<UserProvider>(context, listen: false).userInfo;
    user_id = user[0];
    email = user[1];
    username = user[2];
    user_type = user[3];

    // print(id);
    // print(email);
    // print(username);
    // print(user_type);
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      // Do something with the passed data
      final card_id = arguments as String;
      id = card_id;
      // print('Received ID: id');
    }
    String url1 = "http://127.0.0.1:8000/view-establishment/" + id + "/";
    final response = await http.get(Uri.parse(url1));
    responseData = json.decode(response.body);
    response_Name = responseData['name'];
    response_Address = responseData['location_exact'];
    owner_id = responseData['owner'];
    response_Description = responseData['description'];

    String url2 =
        "http://127.0.0.1:8000/get-one-user-using-id/" + owner_id + "/";
    final response2 = await http.get(Uri.parse(url2));
    var responseData2 = json.decode(response2.body);
    response_phoneNo = responseData2['phone_no'];
    // print(owner_id);
    // print("http://127.0.0.1:8000/get-one-user-using-id/" + owner_id + "/");

    String url3 = "http://127.0.0.1:8000/search-room/";
    final response3 = await json.decode((await http.post(Uri.parse(url3),
            body: {"establishment_id": id, "user_type": user_type}))
        .body);

    for (int i = 0; i < response3.length; i++) {
      cardList.add(Item(
          id: response3[i]["_id"],
          availability: response3[i]["availability"],
          priceLower: response3[i]["price_lower"],
          priceUpper: response3[i]["price_upper"],
          capacity: response3[i]["capacity"],
          index: i));
    }

    // await Future.delayed(Duration(seconds: 1));

    // setState(() {
    //   isLoading = false;
    //  });
  }

  String userInput = "NA";

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  // onToggleButton(int index) {
  //   setState(() {
  //     if (index == 0) {

  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<UserProvider>().isOwner) {
      //Navigator.pop(context);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });

      return const CircularProgressIndicator();
    }
    fetchData();
    return Scaffold(
        //App bar start
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
          title: const Text(
            "Cancel Edit",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        //end of Appbar

        //Main Content for body start

        /*
        Row content Arrangement: 
        > Image
        > Apt. name - Star rating
        > Apt. Location/ Owner name and contact no.
        > Keycards/box of Rooms
          >Available or not
          >Price
          >Max occu.
          >type of room
        >Detailed Info of Apt
        >Highlighted features of Apt./Room
        >Reviews
          >Name of reviewee
          >Date
          >Review content

        */
        
        body: FutureBuilder(
            future:
                fetchData(), // Replace fetchData with your actual future function
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While the data is being fetched, show a loading indicator
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // If there's an error, display an error message
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                        height: 2000,
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Stack(alignment: Alignment.topRight, children: [
                                  SizedBox(
                                    height: 280,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.asset(
                                      'assets/images/room_stock.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        //on button pushed it saves the editted details and routes back the owned accoms page
                                        //setState(() {});
                                        if (_newEstablishmentNameController.text == "") {
                                          _newEstablishmentNameController.text = responseData['name'];
                                        }
                                        if (_newEstablishmentLocationController.text == "") {
                                          _newEstablishmentLocationController.text = responseData['location_exact'];
                                        }
                                        if (_newEstablishmentDescriptionController.text == "") {
                                          _newEstablishmentDescriptionController.text = responseData['description'];
                                        };
                                        String url =
                                            "http://127.0.0.1:8000/edit-establishment/" +
                                                id +
                                                "/";
                                        final Map<String, dynamic> requestBody =
                                            {
                                          "owner": owner_id,
                                          "name":
                                              _newEstablishmentNameController
                                                  .text,
                                          "location_exact":
                                              _newEstablishmentLocationController
                                                  .text,
                                          "location_approx":
                                              responseData['location_approx'],
                                          "establishment_type": responseData[
                                              'establishment_type'],
                                          "tenant_type":
                                              responseData['tenant_type'],
                                          "utilities": [],
                                          "description":
                                              _newEstablishmentDescriptionController
                                                  .text,
                                          "photos": [],
                                          "proof_type":
                                              responseData['proof_type'],
                                          "proof_number":
                                              responseData['proof_number'],
                                          "loc_picture":
                                              responseData['loc_picture'],
                                          "proof_picture":
                                              responseData['loc_picture'],
                                          "reviews": responseData['reviews'],
                                          "verified": responseData['verified'],
                                          "archived": responseData['archived'],
                                          "accommodations":
                                              responseData['accommodations']
                                        };
                                        final headers = {
                                          'Content-Type': 'application/json',
                                        };
                                        final response = await http.put(
                                            Uri.parse(url),
                                            headers: headers,
                                            body: json.encode(requestBody));
                                        // final decodedResponse = json.decode(response.body);
                                        // Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/view_owned_accomms');
                                        
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color.fromARGB(
                                              255, 25, 83, 95)),
                                      child: const Icon(
                                        Icons.save_as,
                                        size: 20,
                                      ))
                                ])
                              ]),
                          const SizedBox(
                            height: 10,
                          ),

                          //Apartment Details
                          //Reviews

                          Row(
                            //optional
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 35,
                              ),
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: TextFormField(
                                  controller: _newEstablishmentNameController,
                                  decoration: InputDecoration(
                                      hintText: response_Name,
                                      //label text should be the value before editting
                                      labelText: 'Edit Establishment Name'),
                                ),
                              ),
                              const SizedBox(
                                width: 35,
                              ),
                              Column(children: [
                                StarRating(
                                  rating: rating,
                                  onRatingChanged: (rating) =>
                                      setState(() => this.rating = rating),
                                  color: Colors.black,
                                ),
                                const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "100+ reviews",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: Colors.black,
                          ),

                          //Contact Information Box
                          Column(
                            children: [
                              const SizedBox(
                                height: 3,
                              ),
                              //Profile icon and name of owner
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //Profile of Owner
                                  const CircleAvatar(
                                    radius: 15,
                                    backgroundImage: AssetImage(
                                        "assets/images/room_stock.jpg"),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: Text(
                                      username,
                                      style: const TextStyle(
                                          fontSize:
                                              UIParameter.FONT_BODY_SIZE + 12,
                                          fontFamily: UIParameter.FONT_REGULAR),
                                    ),
                                  ),
                                ],
                              ),
                              //Location Details
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.location_pin,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: TextFormField(
                                      controller:
                                          _newEstablishmentLocationController,
                                      decoration: InputDecoration(
                                          hintText: response_Address,
                                          labelText: 'Edit Location Details'),
                                    ),
                                  ),
                                ],
                              ),
                              //Contact Info
                              Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  const Icon(
                                    Icons.phone_in_talk_rounded,
                                    color: Colors.blue,
                                    size: 33,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 200,
                                    child: Text(
                                      response_phoneNo,
                                      style: const TextStyle(
                                          fontSize:
                                              UIParameter.FONT_BODY_SIZE + 12,
                                          fontFamily: UIParameter.FONT_REGULAR),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          //end of Owner Information

                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: Colors.black,
                          ),

                          //Cards information
                          //Alternative Cards
                          Column(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: 275.0,
                                  autoPlay: false,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 1000),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  pauseAutoPlayOnTouch: true,
                                  aspectRatio: 2.0,
                                  onPageChanged: (index, reason) {
                                    // setState(() {
                                    //   _currentIndex = index;
                                    // });
                                  },
                                ),
                                items: cardList.map((card) {
                                  return Builder(
                                      builder: (BuildContext context) {
                                    return SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.30,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Card(
                                            color: const Color.fromARGB(
                                                255, 25, 83, 95),
                                            margin: const EdgeInsets.all(12),
                                            elevation: 4,
                                            child: card));
                                  });
                                }).toList(),
                              ),
                            ],
                          ),
                          //End of Cards

                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: Colors.black,
                          ),

                          //Description
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 4,
                                width: 25,
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  const FittedBox(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "About Name",
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                    width: 5,
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 600,
                                    child: TextFormField(
                                      maxLines: 5,
                                      controller:
                                          _newEstablishmentDescriptionController,
                                      decoration: InputDecoration(
                                          hintText: response_Description,
                                          labelText: 'Edit Description'),
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ),
                          //end of Description
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: Colors.black,
                          ),

                          //Highlights
                          const FittedBox(
                            fit: BoxFit.fill,
                            child: Text(
                              "Highlights",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.normal),
                            ),
                          ),
                          const SizedBox(
                              height: 2000,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.pets,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "Pets Allowed",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.bathtub_outlined,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "Own Bathroom",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.restaurant_menu,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "Cooking Allowed",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.wifi,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "With Internet Connection",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.ac_unit,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "Air - Conditioned Room",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.bedtime_off,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "No Curfew",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.electric_meter_outlined,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "Own Meter",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.bed_sharp,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "Furnished",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.desk,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "Semi Furnished",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.drive_eta_outlined,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "Parking Space",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.local_laundry_service_outlined,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "Laundry Allowed",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.nights_stay_outlined,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "Overnight Visitors Allowed",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.directions_walk,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "Visitors Allowed",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.video_camera_front_outlined,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "CCTV in the Area",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          //End of Highlights
                        ]))
                  ]),
                );
              }
            }));
  }
}
