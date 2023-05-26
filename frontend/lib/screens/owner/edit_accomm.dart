import 'package:flutter/material.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
// import 'package:stals_frontend/providers/token_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class EditAccomm extends StatefulWidget {
  const EditAccomm({super.key});
  @override
  _EditAccommState createState() => _EditAccommState();
}

class _EditAccommState extends State<EditAccomm> {
  int activestep = 0;
  int stepcount = 2;

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController houseNoController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const accommTypeError = Text(
      "Please select an accommodation type.",
      style: TextStyle(color: Color(0xff7B2D26)),
    );

    const guestTypeError = Text(
      "Please select a guest type.",
      style: TextStyle(color: Color(0xff7B2D26)),
    );

    Widget navigationButtons = Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 50),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ElevatedButton(
              onPressed: () {
                if (activestep > 0) {
                  setState(() {
                    activestep--;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xff7B2D26),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Back", style: TextStyle(fontSize: 17)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  activestep++;
                });
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xff0B7A75),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Next", style: TextStyle(fontSize: 17)),
            ),
          ]),
        ),
      ),
    );

    Widget step0() {
      return (Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            const Text(
              "Where are you located?",
              style: TextStyle(fontSize: 27, color: Color(0xff1F2421)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: _formKey1,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: TextFormField(
                        controller: houseNoController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xff1F2421),
                                  width: 1,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 15, 170, 163),
                                  width: 2,
                                )),
                            hintText: "House No., Unit No., etc."),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: TextFormField(
                        controller: streetController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xff1F2421),
                                  width: 1,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 15, 170, 163),
                                  width: 2,
                                )),
                            hintText: "Street"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xff1F2421),
                                  width: 1,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 15, 170, 163),
                                  width: 2,
                                )),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 2,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 1,
                                )),
                            hintText: "City"),
                        validator: ((value) {
                          if (value != null && value.trim().isEmpty) {
                            return "City required";
                          }
                          return null;
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 160,
                              child: TextFormField(
                                controller: provinceController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xff1F2421),
                                          width: 1,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 15, 170, 163),
                                          width: 2,
                                        )),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 175, 31, 18),
                                          width: 2,
                                        )),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 175, 31, 18),
                                          width: 1,
                                        )),
                                    hintText: "Province"),
                                validator: ((value) {
                                  if (value != null && value.trim().isEmpty) {
                                    return "Province required";
                                  }
                                  return null;
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 140,
                              child: TextFormField(
                                controller: zipcodeController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xff1F2421),
                                          width: 1,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 15, 170, 163),
                                          width: 2,
                                        )),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 175, 31, 18),
                                          width: 2,
                                        )),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 175, 31, 18),
                                          width: 1,
                                        )),
                                    hintText: "Zip Code"),
                                validator: ((value) {
                                  if (value != null && value.trim().isEmpty) {
                                    return "Zip Code required";
                                  }
                                  return null;
                                }),
                              ),
                            )
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: TextFormField(
                        controller: countryController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xff1F2421),
                                  width: 1,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 15, 170, 163),
                                  width: 2,
                                )),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 2,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 1,
                                )),
                            hintText: "Country"),
                        validator: ((value) {
                          if (value != null && value.trim().isEmpty) {
                            return "Country required";
                          }
                          return null;
                        }),
                      ),
                    ),
                  ]),
                )),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 50),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (activestep > 0) {
                              setState(() {
                                activestep--;
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff7B2D26),
                            minimumSize: const Size(100, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Back",
                              style: TextStyle(fontSize: 17)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (activestep < stepcount) {
                              if (activestep == 2) {
                                if (_formKey1.currentState!.validate()) {
                                  setState(() {
                                    activestep++;
                                  });
                                }
                              } else {
                                setState(() {
                                  activestep++;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff0B7A75),
                            minimumSize: const Size(100, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Next",
                              style: TextStyle(fontSize: 17)),
                        ),
                      ]),
                ),
              ),
            )
          ]));
    }

    Widget step1() {
      return (Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            const Text(
              "Tell us about your place",
              style: TextStyle(fontSize: 27, color: Color(0xff1F2421)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                    key: _formKey2,
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text("Name"),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: nameController,
                                validator: ((value) {
                                  if (value != null && value.trim().isEmpty) {
                                    return "Name required";
                                  }
                                  return null;
                                }),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xff1F2421),
                                        width: 1,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 15, 170, 163),
                                        width: 2,
                                      )),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 175, 31, 18),
                                        width: 2,
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 175, 31, 18),
                                        width: 1,
                                      )),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text("Description")),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 200,
                              child: TextFormField(
                                controller: descriptionController,
                                minLines: 5,
                                maxLines: 5,
                                validator: ((value) {
                                  if (value != null && value.trim().isEmpty) {
                                    return "Description required";
                                  }
                                  return null;
                                }),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xff1F2421),
                                        width: 1,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 15, 170, 163),
                                        width: 2,
                                      )),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 175, 31, 18),
                                        width: 2,
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 175, 31, 18),
                                        width: 1,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]))),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 50),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              activestep--;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff7B2D26),
                            minimumSize: const Size(100, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Back",
                              style: TextStyle(fontSize: 17)),
                        ),
                        ElevatedButton(
                          // fixed muna ang mga inputs
                          onPressed: () async {
                            if (_formKey2.currentState!.validate()) {
                               print("edit accommodation complete.");
                                  String url = "http://127.0.0.1:8000/edit-establishment/6437f190fe3f89a27b315961/";
                                    final Map<String, dynamic> requestBody = {
                                      "owner": "6437f190fe3f89a27b315961",
                                      "name": nameController.text,
                                      "location_exact": houseNoController.text + " " + streetController.text + " " + cityController.text + " " + provinceController.text + " " + countryController.text,
                                      "location_approx": "Maybe inside Campus",
                                      "establishment_type": "Dorm",
                                      "tenant_type": "Student",
                                      "utilities": [],
                                      "description": descriptionController.text,
                                      "photos": [],
                                      "proof_type": "None",
                                      "proof_number": "None",
                                      "proof_picture": "https://drive.google.com/file/d/1ZI80TYmed8EXDfkgDtmyukYICwgPQUYf/view?usp=sharing", // this field is required to have a url
                                      "reviews": [],
                                      "verified": false,
                                      "archived": false,
                                      "accommodations": []
                                    };
                                final headers = {
                                  'Content-Type': 'application/json',
                                };  
                                final response = await http.put(Uri.parse(url), headers: headers, body: json.encode(requestBody));
                                // final decodedResponse = json.decode(response.body);
                                // Navigator.pop(context);
                                }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff0B7A75),
                            minimumSize: const Size(100, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Submit",
                              style: TextStyle(fontSize: 17)),
                        ),
                      ]),
                ),
              ),
            )
          ]));
    }

    Widget getStep() {
      switch (activestep) {
        case 0:
          return step0();
        case 1:
          return step1();
        default:
          return Container();
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(child: getStep()),
    );
  }
}
