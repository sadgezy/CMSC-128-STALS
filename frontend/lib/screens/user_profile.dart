import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../components/verification_banner.dart';

class UserProfile extends StatefulWidget {
  final String userId;

  UserProfile({required this.userId});

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  String username = '';
  String fullname = '';
  String email = '';
  String phone = '';
  String proofType = '';
  String proofNum = '';
  String proofPic = '';

  String _idType = 'Select a proof type'; //proofType
  String _idNumber = ''; //proofNum
  XFile? _idImage;
  PlatformFile? _imageFile;
  bool uploadedImage = false;
  String base64Image = ''; //proofPic
  bool showImageUploadError = false;

  GlobalKey<FormState> _editNameFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _resubmitIdFormKey = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController mnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController suffixController = TextEditingController();
  TextEditingController idNumController = TextEditingController();

  bool isVerified = false;
  bool isRejected = false;
  String verificationStatus = '';
  bool rejected = false;
  String id = '';

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    final response = await http
        .get(Uri.parse("http://127.0.0.1:8000/get-one-user-using-id/$userId/"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> resubmitVerificationData(
      Map<String, dynamic> updatedData, String userId) async {
    String url = 'http://127.0.0.1:8000/resubmit-verification-data/$userId/';
    final response = await http.put(
      Uri.parse(url),
      body: updatedData,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to resubmit verification data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    Widget buildInfo(String label, String info) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xff1F2421)),
              ),
              const Spacer(),
              Text(info),
            ],
          ),
        ],
      );
    }

    void checkVerification() {
      if (isVerified && !isRejected) {
        verificationStatus = "accepted";
      } else if (!isVerified && isRejected) {
        verificationStatus = "rejected";
      } else if (!isVerified && !isRejected) {
        verificationStatus = "pending";
      }
    }

    void _chooseImage() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          withData: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png']);

      if (result != null) {
        var bytes = result.files.first.bytes;
        bytes ??= File(result.files.single.path!).readAsBytesSync();
        double fileSize = (bytes.lengthInBytes / (1024 * 1024));
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
          setState(() {
            _imageFile = result.files.first;
            showImageUploadError = false;
            uploadedImage = true;
          });
          String extn = result.files.first.name.split('.').last;
          if (extn == 'png' || extn == 'PNG') {
            base64Image =
                "data:image/png;base64," + base64Encode(bytes!.toList());
          } else {
            base64Image =
                "data:image/jpeg;base64," + base64Encode(bytes!.toList());
          }
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
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
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
            if (_resubmitIdFormKey.currentState!.validate()) {
              if (base64Image == '') {
                setState(() {
                  showImageUploadError = true;
                });
              } else {
                setState(() {
                  proofType = _idType;
                  proofNum = _idNumber;
                  proofPic = base64Image;
                  verificationStatus = "pending";
                });
                // print("verification status: ${verificationStatus}"); //must be pending after resubmission
                // Send the updated verification data to the backend
                Map<String, dynamic> updatedData = {
                  'userId': widget.userId,
                  'id_type': _idType,
                  'id_number': _idNumber,
                  'id_picture': base64Image,
                };

                resubmitVerificationData(updatedData, widget.userId).then((_) {
                  // Handle successful resubmission
                  // print('Verification data resubmitted successfully');
                }).catchError((error) {
                  // Handle error
                  print('Failed to resubmit verification data: $error');
                });

                setState(() {});
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
          child: const Text("Resubmit", style: TextStyle(fontSize: 17)),
        ),
      ]),
    );

    Widget backButton = Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
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
      ]),
    );

    const imageUploadError = Padding(
      padding: EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 16,
        child: Text(
          "Please upload an image.",
          style: TextStyle(color: Color(0xff7B2D26)),
        ),
      ),
    );

    Widget buildVerification() {
      switch (verificationStatus) {
        case "rejected":
          return Form(
            key: _resubmitIdFormKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Proof Type"),
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField(
                      value: _idType,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'Select a proof type',
                          child: Text('Select a proof type'),
                        ),
                        DropdownMenuItem(
                          value: 'UMID',
                          child: Text('UMID'),
                        ),
                        DropdownMenuItem(
                          value: 'Employee',
                          child: Text('Employee’s ID'),
                        ),
                        DropdownMenuItem(
                          value: 'Drivers',
                          child: Text('Driver’s License'),
                        ),
                        DropdownMenuItem(
                          value: 'PRC',
                          child: Text(
                              'Professional Regulation Commission (PRC) ID'),
                        ),
                        DropdownMenuItem(
                          value: 'Passport',
                          child: Text('Passport'),
                        ),
                        DropdownMenuItem(
                          value: 'Senior',
                          child: Text('Senior Citizen ID'),
                        ),
                        DropdownMenuItem(
                          value: 'SSS',
                          child: Text('SSS ID'),
                        ),
                        DropdownMenuItem(
                          value: 'Voters',
                          child: Text('Voter’s ID'),
                        ),
                        DropdownMenuItem(
                          value: 'PhilID',
                          child: Text(
                              'Philippine Identification (PhilID / ePhilID)'),
                        ),
                        DropdownMenuItem(
                          value: 'NBI',
                          child: Text('NBI Clearance'),
                        ),
                        DropdownMenuItem(
                          value: 'IBP',
                          child: Text(
                              'Integrated Bar of the Philippines (IBP) ID'),
                        ),
                        DropdownMenuItem(
                          value: 'PWD',
                          child: Text('Person’s With Disability (PWD) ID'),
                        ),
                        DropdownMenuItem(
                          value: 'Barangay',
                          child: Text('Barangay ID'),
                        ),
                        DropdownMenuItem(
                          value: 'Postal',
                          child: Text('Philippine Postal ID'),
                        ),
                        DropdownMenuItem(
                          value: 'Phil-health',
                          child: Text('Phil-health ID'),
                        ),
                        DropdownMenuItem(
                          value: 'School',
                          child: Text('School ID'),
                        ),
                      ],
                      validator: ((value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please select a proof type';
                        }

                        if (value == "Select a proof type") {
                          return 'Please select a proof type';
                        }
                      }),
                      onChanged: (value) {
                        setState(() {
                          _idType = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    const Align(
                        alignment: Alignment.topLeft, child: Text("ID Number")),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: idNumController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(25, 10, 10, 10),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none)),
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
                      onChanged: (value) => _idNumber = value,
                      validator: ((value) {
                        if (value != null && value.trim().isEmpty) {
                          return "Please enter an ID Number";
                        }
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_imageFile != null)
                  Image.memory(
                    Uint8List.fromList(_imageFile!.bytes!),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 10),
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
                              _chooseImage();
                            },
                            child: const Text("Upload image")),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Only photos below 1MB are allowed.',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 25, 83, 95),
                  ),
                ),
                showImageUploadError
                    ? imageUploadError
                    : const SizedBox(height: 16),
                const SizedBox(height: 10),
                // DONT REMOVE. IMPORTANT FOR TESTING
                // if (uploadedImage)
                //   Column(
                //     children: [
                //       Text(
                //           "If you see this picture, this was from the database!"),
                //       Image.memory(
                //           Uri.parse(base64Image).data!.contentAsBytes())
                //     ],
                //   ),
                const SizedBox(height: 70),
              ],
            ),
          );
        case "pending":
          return Container();
        case "accepted":
          return Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildInfo("ID Type", proofType),
                            buildInfo("ID Number", proofNum),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: proofPic != ''
                                  ? Image.memory(Uri.parse(proofPic)
                                      .data!
                                      .contentAsBytes())
                                  : Container(),
                            )
                          ])),
                ),
              ],
            ),
          );

        default:
          return Container();
      }
    }

    return Scaffold(
      backgroundColor: Color(0xffF0F3F5),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(widget.userId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          // print(snapshot.data!);
          // Map<String, dynamic> userData = snapshot.data!;            // NOTE: this was causing the bug
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> userData = snapshot.data!;

            // Assign the values from the fetched data to the respective variables
            fullname =
                "${userData['first_name']} ${userData['middle_initial']} ${userData['last_name']} ${userData['suffix']}";
            // "${response['first_name']} ${response['middle_initial']} ${response['last_name']} ${response['suffix']}"
            username = userData['username'] ?? "";
            email = userData['email'] ?? "";
            phone = userData['phone_no'] ?? "";
            proofType = userData['id_type'] ?? "";
            proofNum = userData['id_number'] ?? "";
            isVerified = userData['verified'] ?? false;
            isRejected = userData['rejected'] ?? false;
            proofPic = userData['id_picture'] ?? "";
            checkVerification();
            // print("verification status: ${verificationStatus}");

            // Return the original body with the updated data
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: new BoxConstraints(maxWidth: 550.0),
                  child: Column(
                    children: [
                      VerificationBanner(
                          verificationStatus: verificationStatus),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.04),
                            Center(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(fullname,
                                          style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff1F2421))),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 30),
                                    child: Text(username),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text("Account Details",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 31, 36, 33))),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildInfo("Full Name", fullname),
                                    buildInfo("Username", username),
                                    buildInfo("E-mail Address", email),
                                    buildInfo("Phone Number", phone),
                                    buildInfo("Verification Status",
                                        verificationStatus.toUpperCase())
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // const Divider(height: 1),
                            const SizedBox(
                              height: 20,
                            ),
                            verificationStatus != "pending"
                                ? const Text("Identity Verification",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 31, 36, 33)))
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            buildVerification(),
                            verificationStatus == "rejected"
                                ? navigationButtons
                                : backButton
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
