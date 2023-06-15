import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:stals_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
// import 'package:stals_frontend/providers/token_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:stals_frontend/screens/owner/view_manage_accomms.dart';

class AddAccommPage extends StatefulWidget {
  const AddAccommPage({super.key});
  @override
  _AddAccommPageState createState() => _AddAccommPageState();
}

class _AddAccommPageState extends State<AddAccommPage> {
  int activestep = 0;
  int stepcount = 3;
  String accommType = "";
  String guestType = "";
  String _idType = '';
  String _idNumber = '';
  bool showGuestTypeError = false;
  bool showAccommTypeError = false;
  bool showAccommImageError = false;
  bool showProofUploadError = false;
  XFile? _idImage;
  PlatformFile? _imageFile;
  PlatformFile? _imageFile2;
  bool uploadedImage = false;
  String base64Image1 = '';
  String base64Image2 = '';

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
  final TextEditingController idnoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (!context.watch<UserProvider>().isOwner) {
      //Navigator.pop(context);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });

      return const CircularProgressIndicator();
    }
    double height = MediaQuery.of(context).size.height;
    List<dynamic> user =
        Provider.of<UserProvider>(context, listen: false).userInfo;
    String id = user[0];
    String email = user[1];
    String username = user[2];
    String user_type = user[3];

    const accommTypeError = SizedBox(
      height: 16,
      child: Text(
        "Please select an accommodation type.",
        style: TextStyle(color: Color(0xff7B2D26)),
      ),
    );

    const guestTypeError = SizedBox(
      height: 16,
      child: Text(
        "Please select a guest type.",
        style: TextStyle(color: Color(0xff7B2D26)),
      ),
    );

    const accommImageError = Padding(
      padding: EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 16,
        child: Text(
          "Please upload an image of your accommodation",
          style: TextStyle(color: Color(0xff7B2D26)),
        ),
      ),
    );

    const proofUploadError = Padding(
      padding: EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 16,
        child: Text(
          "Please provide proof of your business",
          style: TextStyle(color: Color(0xff7B2D26)),
        ),
      ),
    );

    // Future chooseImage() async {
    //   ImagePicker picker = ImagePicker();
    //   final image = await picker.pickImage(source: ImageSource.gallery);

    //   if (image != null) {
    //     setState(() {
    //       _idImage = image as XFile?;
    //       imageFile = File(_idImage!.path);
    //     });
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('No image selected'),
    //       ),
    //     );
    //   }
    // }
    // Future<String?> _chooseImage(File? imageFile) async {
    //   if (imageFile != null) {
    //     var bytes = imageFile.readAsBytesSync();
    //     double fileSize = (bytes.lengthInBytes / (1024 * 1024));
    //     if (fileSize > 1) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text('Image too large'),
    //         ),
    //       );
    //       return null;
    //     } else {
    //       String base64Image;
    //       String extn = imageFile.path.split('.').last;
    //       if (extn == 'png' || extn == 'PNG') {
    //         base64Image =
    //             "data:image/png;base64," + base64Encode(bytes.toList());
    //       } else {
    //         base64Image =
    //             "data:image/jpeg;base64," + base64Encode(bytes.toList());
    //       }

    //       return base64Image;
    //     }
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('No image selected'),
    //       ),
    //     );
    //     return null;
    //   }
    // }

    void _chooseImage(int image) async {
      //ImagePicker picker = ImagePicker();
      //XFile? image = await picker.pickImage(source: ImageSource.gallery);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          withData: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png']);

      if (result != null) {
        var bytes = result.files.first.bytes;
        bytes ??= File(result.files.single.path!).readAsBytesSync();
        double fileSize = (bytes.lengthInBytes / (1024 * 1024));
        //print(bytes.lengthInBytes);
        //print(fileSize);
        if (fileSize > 1) {
          setState(() {
            _imageFile = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image too large'),
            ),
          );
        } else {
          if (image == 1) {
            setState(() {
              _imageFile = result.files.first;
              setState(() => showAccommImageError = false);
            });
            String extn = result.files.first.name.split('.').last;
            if (extn == 'png' || extn == 'PNG') {
              base64Image1 =
                  "data:image/png;base64," + base64Encode(bytes!.toList());
            } else {
              base64Image1 =
                  "data:image/jpeg;base64," + base64Encode(bytes!.toList());
            }
          } else {
            setState(() {
              _imageFile2 = result.files.first;
              setState(() => showProofUploadError = false);
            });
            String extn = result.files.first.name.split('.').last;
            if (extn == 'png' || extn == 'PNG') {
              base64Image2 =
                  "data:image/png;base64," + base64Encode(bytes!.toList());
            } else {
              base64Image2 =
                  "data:image/jpeg;base64," + base64Encode(bytes!.toList());
            }
          }
          //print(result.files.first.name);
          //print("img_pan : $base64Image");
          //setState(() {});
          //var imageFile = Image.network(image.path);
          //html.File(image.path.codeUnits, image.path);
          //print(imageFile.name);

          //_idImage = image as XFile?;
          //final bytes = File(imageFile.name).readAsBytesSync();
          //String base64Image =  "data:image/png;base64,"+base64Encode(bytes);

          //print(base64Image);
        }
      } else {
        setState(() {
          _imageFile = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected'),
          ),
        );
      }
    }

    Widget navigationButtons = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ElevatedButton(
          onPressed: () {
            if (activestep > 0) {
              setState(() {
                activestep--;
              });
            } else if (activestep == 0) {
              //print("Add accommodation cancelled.");
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
          child: Text(activestep == 0 ? "Cancel" : "Back",
              style: const TextStyle(fontSize: 17)),
        ),
        ElevatedButton(
          onPressed: () {
            if (activestep < stepcount) {
              if (activestep == 0) {
                if (accommType == "") {
                  setState(() {
                    showAccommTypeError = true;
                  });
                  //print("Please select an accomodation type.");
                } else {
                  setState(() {
                    activestep++;
                  });
                }
              } else if (activestep == 1) {
                if (guestType == "") {
                  setState(() {
                    showGuestTypeError = true;
                  });
                  //print("Please select a guest type.");
                } else {
                  setState(() {
                    activestep++;
                  });
                }
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
          child: const Text("Next", style: TextStyle(fontSize: 17)),
        ),
      ]),
    );

    Widget step0() {
      return (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 70,
          ),
          const Text(
            "Which of these best\ndescribes your place?",
            style: TextStyle(fontSize: 27, color: Color(0xff1F2421)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 85),
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            maximumSize: const Size(300, 75),
                            minimumSize: const Size(300, 75),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                              color: (accommType == "house")
                                  ? const Color.fromARGB(255, 15, 170, 163)
                                  : const Color(0xff1F2421),
                            )),
                        onPressed: () {
                          setState(() {
                            accommType = "house";
                            showAccommTypeError = false;
                            //print("Seleced accommodation type: " + accommType);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              child: Image.asset(
                                'assets/images/home.png',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            const SizedBox(width: 30),
                            const Text("House",
                                style: TextStyle(
                                    fontSize: 23, color: Color(0xff1F2421)))
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            maximumSize: const Size(300, 75),
                            minimumSize: const Size(300, 75),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                              color: (accommType == "dormitory")
                                  ? const Color.fromARGB(255, 15, 170, 163)
                                  : const Color(0xff1F2421),
                            )),
                        onPressed: () {
                          setState(() {
                            accommType = "dormitory";
                            showAccommTypeError = false;
                            //print("Seleced accommodation type: " + accommType);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 50,
                                child: Image.asset(
                                  'assets/images/dormitory.png',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Text("Dormitory",
                                  style: TextStyle(
                                      fontSize: 23, color: Color(0xff1F2421)))
                            ],
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            maximumSize: const Size(300, 75),
                            minimumSize: const Size(300, 75),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                              color: (accommType == "apartment")
                                  ? const Color.fromARGB(255, 15, 170, 163)
                                  : const Color(0xff1F2421),
                            )),
                        onPressed: () {
                          setState(() {
                            accommType = "apartment";
                            showAccommTypeError = false;
                            //print("Seleced accommodation type: " + accommType);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              child: Image.asset(
                                'assets/images/apartment.png',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Text("Apartment",
                                style: TextStyle(
                                    fontSize: 23, color: Color(0xff1F2421)))
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            maximumSize: const Size(300, 75),
                            minimumSize: const Size(300, 75),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                              color: (accommType == "transient")
                                  ? const Color.fromARGB(255, 15, 170, 163)
                                  : const Color(0xff1F2421),
                            )),
                        onPressed: () {
                          setState(() {
                            accommType = "transient";
                            showAccommTypeError = false;
                            //print("Seleced accommodation type: " + accommType);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              child: Image.asset(
                                'assets/images/transient.png',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Text("Transient",
                                style: TextStyle(
                                    fontSize: 23, color: Color(0xff1F2421)))
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            maximumSize: const Size(300, 75),
                            minimumSize: const Size(300, 75),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                              color: (accommType == "hotel")
                                  ? const Color.fromARGB(255, 15, 170, 163)
                                  : const Color(0xff1F2421),
                            )),
                        onPressed: () {
                          setState(() {
                            accommType = "hotel";
                            showAccommTypeError = false;
                            //print("Seleted accommodation type: " + accommType);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              child: Image.asset(
                                'assets/images/hotel.png',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            const SizedBox(width: 35),
                            const Text("Hotel",
                                style: TextStyle(
                                    fontSize: 23, color: Color(0xff1F2421)))
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
          showAccommTypeError ? accommTypeError : const SizedBox(height: 16),
          const SizedBox(height: 30),
          navigationButtons
        ],
      ));
    }

    Widget step1() {
      return (Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            const Text(
              "Who can stay at\nyour place?",
              style: TextStyle(fontSize: 27, color: Color(0xff1F2421)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 75,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 85),
                child: Container(
                    color: Colors.transparent,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                maximumSize: const Size(300, 70),
                                minimumSize: const Size(300, 70),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  color: (guestType == "students")
                                      ? const Color.fromARGB(255, 15, 170, 163)
                                      : const Color(0xff1F2421),
                                )),
                            onPressed: () {
                              setState(() {
                                guestType = "students";
                                showGuestTypeError = false;
                                //print("Selected guest type: " + guestType);
                              });
                            },
                            child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text("Students",
                                    style: TextStyle(
                                        fontSize: 23,
                                        color: Color(0xff1F2421))))),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                maximumSize: const Size(300, 70),
                                minimumSize: const Size(300, 70),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  color: (guestType == "teachers")
                                      ? const Color.fromARGB(255, 15, 170, 163)
                                      : const Color(0xff1F2421),
                                )),
                            onPressed: () {
                              setState(() {
                                guestType = "teachers";
                                showGuestTypeError = false;
                                //print("Selected guest type: " + guestType);
                              });
                            },
                            child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text("Teachers",
                                    style: TextStyle(
                                        fontSize: 23,
                                        color: Color(0xff1F2421))))),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                maximumSize: const Size(300, 70),
                                minimumSize: const Size(300, 70),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  color: (guestType == "professionals")
                                      ? const Color.fromARGB(255, 15, 170, 163)
                                      : const Color(0xff1F2421),
                                )),
                            onPressed: () {
                              setState(() {
                                guestType = "professionals";
                                showGuestTypeError = false;
                                //("Selected guest type: " + guestType);
                              });
                            },
                            child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text("Professionals",
                                    style: TextStyle(
                                        fontSize: 23,
                                        color: Color(0xff1F2421))))),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                maximumSize: const Size(300, 70),
                                minimumSize: const Size(300, 70),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  color: (guestType == "anyone")
                                      ? const Color.fromARGB(255, 15, 170, 163)
                                      : const Color(0xff1F2421),
                                )),
                            onPressed: () {
                              setState(() {
                                guestType = "anyone";
                                showGuestTypeError = false;
                                // print("Selected guest type: " + guestType);
                              });
                            },
                            child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text("Anyone",
                                    style: TextStyle(
                                        fontSize: 23,
                                        color: Color(0xff1F2421))))),
                      )
                    ]))),
            showGuestTypeError ? guestTypeError : const SizedBox(height: 16),
            const SizedBox(height: 75),
            navigationButtons
          ]));
    }

    Widget step2() {
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
                            contentPadding:
                                const EdgeInsets.fromLTRB(25, 10, 10, 10),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 2,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 1,
                                )),
                            labelText: "House No., Unit No., etc."),
                        validator: ((value) {
                          if (value != null && value.trim().isEmpty) {
                            return "This field is required.";
                          }
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: TextFormField(
                        controller: streetController,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(25, 10, 10, 10),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 2,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 1,
                                )),
                            labelText: "Street"),
                        validator: ((value) {
                          if (value != null && value.trim().isEmpty) {
                            return "Street required.";
                          }
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(25, 10, 10, 10),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 2,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 1,
                                )),
                            labelText: "City"),
                        validator: ((value) {
                          if (value != null && value.trim().isEmpty) {
                            return "City required";
                          }
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                controller: provinceController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        25, 10, 10, 10),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18)),
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 175, 31, 18),
                                          width: 2,
                                        )),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 175, 31, 18),
                                          width: 1,
                                        )),
                                    labelText: "Province"),
                                validator: ((value) {
                                  if (value != null && value.trim().isEmpty) {
                                    return "Province required";
                                  }
                                }),
                              ),
                            ),
                            const Spacer(flex: 1),
                            Flexible(
                              flex: 3,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                controller: zipcodeController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        25, 10, 10, 10),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18)),
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 175, 31, 18),
                                          width: 2,
                                        )),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 175, 31, 18),
                                          width: 1,
                                        )),
                                    labelText: "Zip Code"),
                                validator: ((value) {
                                  if (value != null && value.trim().isEmpty) {
                                    return "Zip Code required";
                                  } else if (value != null &&
                                      value.length != 4) {
                                    return "Must be 4 digits long";
                                  }
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
                            contentPadding:
                                const EdgeInsets.fromLTRB(25, 10, 10, 10),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 2,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 175, 31, 18),
                                  width: 1,
                                )),
                            labelText: "Country"),
                        validator: ((value) {
                          if (value != null && value.trim().isEmpty) {
                            return "Country required";
                          }
                        }),
                      ),
                    ),
                  ]),
                )),
            const SizedBox(
              height: 166,
            ),
            Padding(
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
                      child: const Text("Next", style: TextStyle(fontSize: 17)),
                    ),
                  ]),
            )
          ]));
    }

    Widget step3() {
      return (Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 70,
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
                                }),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(25, 10, 10, 10),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(18)),
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 175, 31, 18),
                                        width: 2,
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 175, 31, 18),
                                        width: 1,
                                      )),
                                ),
                              ),
                            ],
                          )),

                      // if (_imageFile != null)
                      //   Image.memory(
                      //     Uint8List.fromList(_imageFile!.bytes!),
                      //     width: 200,
                      //     height: 200,
                      //     fit: BoxFit.cover,
                      //   ),
                      // Container(
                      //   width: 200.0,
                      //   height: 40.0,
                      //   color: Colors.grey,
                      //   child: _idImage != null
                      //       ? Image.file(_idImage as File)
                      //       : IconButton(
                      //           icon: const Icon(Icons.add),
                      //           onPressed: () {
                      //             _chooseImage();
                      //           },
                      //         ),
                      // ),
                      // const Text(
                      //   'Only photos below 1MB are allowed.',
                      //   style: TextStyle(color: Colors.red),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text("Accomodation Picture")),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Container(
                                alignment: Alignment.center,
                                child: _idImage != null
                                    ? Image.file(_idImage as File)
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(150, 50),
                                          maximumSize: const Size(150, 50),
                                          elevation: 0,
                                          backgroundColor:
                                              //const Color(0xff7B2D26),
                                              const Color.fromARGB(
                                                  255, 25, 83, 95),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          _chooseImage(1);
                                        },
                                        child: const Text("Upload image")),
                              ),
                            ),
                            showAccommImageError
                                ? accommImageError
                                : const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      if (_imageFile != null)
                        Image.memory(
                          Uint8List.fromList(_imageFile!.bytes!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(
                        height: 5,
                      ),
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
                              height: 100,
                              child: TextFormField(
                                controller: descriptionController,
                                minLines: 5,
                                maxLines: 5,
                                validator: ((value) {
                                  if (value != null && value.trim().isEmpty) {
                                    return "Description required";
                                  }
                                }),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(25, 10, 10, 10),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(18)),
                                      borderSide: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 175, 31, 18),
                                        width: 2,
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 175, 31, 18),
                                        width: 1,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Proof Type"),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownButtonFormField(
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Business Permit',
                                  child: Text('Business Permit'),
                                ),
                                DropdownMenuItem(
                                  value: 'BIR',
                                  child: Text('BIR'),
                                ),
                                DropdownMenuItem(
                                  value: 'Proof of Land Ownership',
                                  child: Text('Proof of Land Ownership'),
                                ),
                                DropdownMenuItem(
                                  value: 'Building Permit',
                                  child: Text('Building Permit'),
                                ),
                                DropdownMenuItem(
                                  value: 'Others',
                                  child: Text('Others'),
                                ),
                              ],
                              onChanged: (value) => _idType = value!,
                              validator: ((value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please select a proof type';
                                }
                              }),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text("ID Number")),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: idnoController,
                              validator: ((value) {
                                if (value != null && value.trim().isEmpty) {
                                  return "ID Number required";
                                }
                              }),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(25, 10, 10, 10),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 175, 31, 18),
                                      width: 2,
                                    )),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 175, 31, 18),
                                      width: 1,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (_imageFile2 != null)
                        Image.memory(
                          Uint8List.fromList(_imageFile2!.bytes!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Container(
                          alignment: Alignment.center,
                          child: _idImage != null
                              ? Image.file(_idImage as File)
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(150, 50),
                                    maximumSize: const Size(150, 50),
                                    elevation: 0,
                                    backgroundColor:
                                        const Color.fromARGB(255, 25, 83, 95),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    _chooseImage(2);
                                  },
                                  child: const Text("Upload image")),
                        ),
                      ),
                      const Text(
                        'Only photos below 1MB are allowed.',
                        style: TextStyle(
                          color: Color.fromARGB(255, 25, 83, 95),
                        ),
                      ),
                      showProofUploadError
                          ? proofUploadError
                          : const SizedBox(height: 16),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 7),
                      //   child: _idImage == null
                      //       ? DottedBorder(
                      //           strokeWidth: 1,
                      //           dashPattern: const [6, 6],
                      //           color: const Color(0xff1F2421),
                      //           child: Container(
                      //               height: 100,
                      //               width: double.infinity,
                      //               color: Colors.white,
                      //               child: Container(
                      //                 alignment: Alignment.center,
                      //                 child: _idImage != null
                      //                     ? Image.memory(_idImage! as Uint8List)
                      //                     : IconButton(
                      //                         icon: const Icon(Icons.add),
                      //                         onPressed: () {
                      //                           _chooseImage();
                      //                         },
                      //                       ),
                      //               )),
                      //         )
                      //       : Container(
                      //           height: 100,
                      //           width: double.infinity,
                      //           child: Image.memory(
                      //             _imageFile! as Uint8List,
                      //             fit: BoxFit.fitWidth,
                      //           )),
                      // ),
                      // Padding(
                      //     padding: const EdgeInsets.symmetric(vertical: 7),
                      //     child: _idImage == null
                      //         ? DottedBorder(
                      //             strokeWidth: 1,
                      //             dashPattern: const [6, 6],
                      //             color: const Color(0xff1F2421),
                      //             child: Container(
                      //                 height: 100,
                      //                 width: double.infinity,
                      //                 color: Colors.white,
                      //                 child: Container(
                      //                   alignment: Alignment.center,
                      //                   child: ElevatedButton(
                      //                       style: ElevatedButton.styleFrom(
                      //                         minimumSize: const Size(150, 50),
                      //                         maximumSize: const Size(150, 50),
                      //                         elevation: 0,
                      //                         backgroundColor:
                      //                             const Color(0xff7B2D26),
                      //                         shape: RoundedRectangleBorder(
                      //                           borderRadius:
                      //                               BorderRadius.circular(10),
                      //                         ),
                      //                       ),
                      //                       onPressed: () {
                      //                         chooseImage();
                      //                       },
                      //                       child: const Text("Upload image")),
                      //                 )),
                      //           )
                      //         : Container(
                      //             height: 100,
                      //             width: double.infinity,
                      //             child: Image.file(
                      //               imageFile!,
                      //               fit: BoxFit.fitWidth,
                      //             ))),
                    ]))),
            const SizedBox(
              height: 70,
            ),
            Padding(
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
                      child: const Text("Back", style: TextStyle(fontSize: 17)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (user_type == "owner") {
                          if (_formKey2.currentState!.validate()) {
                            if (base64Image1 == '') {
                              setState(() => showAccommImageError = true);
                            } else if (base64Image2 == '') {
                              setState(() => showProofUploadError = true);
                            } else {
                              // print("Add accommodation complete.");
                              String url =
                                  "http://127.0.0.1:8000/create-establishment/";
                              final Map<String, dynamic> requestBody = {
                                "owner": id,
                                "name": nameController.text,
                                "location_exact": houseNoController.text +
                                    " " +
                                    streetController.text +
                                    " " +
                                    cityController.text +
                                    " " +
                                    provinceController.text +
                                    " " +
                                    countryController.text,
                                "location_approx": "Maybe inside Campus",
                                "establishment_type": accommType,
                                "tenant_type": guestType,
                                "utilities": [],
                                "description": descriptionController.text,
                                "photos": [],
                                "proof_type": _idType,
                                "proof_number": idnoController.text,
                                "loc_picture": base64Image1,
                                "proof_picture": base64Image2,
                                "reviews": [],
                                "verified": false,
                                "archived": false,
                                "accommodations": []
                              };
                              final headers = {
                                'Content-Type': 'application/json',
                              };
                              final response = await http.post(Uri.parse(url),
                                  headers: headers,
                                  body: json.encode(requestBody));
                              final decodedResponse =
                                  json.decode(response.body);

                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ViewOwnedAccomms()));
                            }
                          }
                        } else {
                          print("Not an owner");
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
                      child:
                          const Text("Submit", style: TextStyle(fontSize: 17)),
                    ),
                  ]),
            )
          ]));
    }

    Widget getStep() {
      switch (activestep) {
        case 0:
          return step0();
        case 1:
          return step1();
        case 2:
          return step2();
        case 3:
          return step3();
        default:
          return Container();
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: Text(
          "",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xffF0F3F5),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Center(
              child: ConstrainedBox(
                  constraints: new BoxConstraints(maxWidth: 550.0),
                  child: getStep()))),
    );
  }
}
