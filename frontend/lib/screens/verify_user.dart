import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
// import 'dart:html' as html;
import 'package:http/http.dart' as http;
import '../models/signup_arguments.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String _idType = '';
  String _idNumber = '';
  XFile? _idImage;
  PlatformFile? _imageFile;
  bool uploadedImage = false;
  String base64Image = '';
  bool showImageUploadError = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SignupArguments;
    final double height = MediaQuery.of(context).size.height;

    Future<void> _showDialog(BuildContext context, String message) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Signup Status'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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

    Widget navigationButtons =
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
          if (_formKey.currentState!.validate()) {
            if (base64Image == '') {
              setState(() => showImageUploadError = true);
            } else {
              // TODO: Submit the verification form.
              final response;
              if (args.suffix == null) {
                String url = "http://127.0.0.1:8000/signup/";
                response = await http.post(Uri.parse(url), body: {
                  'first_name': args.firstName,
                  'last_name': args.lastName,
                  'middle_initial': args.middleName,
                  'username': args.username,
                  'password': args.password,
                  'email': args.email,
                  'phone_no': args.phoneNo,
                  'user_type': args.userType,
                  'id_type': _idType,
                  'id_number': _idNumber,
                  'id_picture': base64Image
                });
              } else {
                String url = "http://127.0.0.1:8000/signup/";
                response = await http.post(Uri.parse(url), body: {
                  'first_name': args.firstName,
                  'last_name': args.lastName,
                  'middle_initial': args.middleName,
                  'suffix': args.suffix,
                  'username': args.username,
                  'password': args.password,
                  'email': args.email,
                  'phone_no': args.phoneNo,
                  'user_type': args.userType,
                  'id_type': _idType,
                  'id_number': _idNumber,
                  'id_picture': base64Image
                });
              }

              // print(response.statusCode);
              if (response.statusCode == 201) {
                //200 is successful but 201 means successful AND created
                // Signup successful
                var responseBody = json.decode(response.body);
                base64Image = responseBody['data']['id_picture'];
                uploadedImage = true;
                setState(() {});

                await _showDialog(context, 'Signup complete, please login');
                // Navigate to the login screen
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                // Signup failed, display an error message
                await _showDialog(context, 'Error: Signup failed');
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
        child: const Text("Submit", style: TextStyle(fontSize: 17)),
      ),
    ]);

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
        body: SingleChildScrollView(
            child: Center(
          child: ConstrainedBox(
            constraints: new BoxConstraints(maxWidth: 550.0),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: height * 0.04),
                    const Text(
                      "Become a verified user!",
                      style: TextStyle(
                          fontSize: 28,
                          // fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 31, 36, 33)),
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Proof Type"),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField(
                          items: const [
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
                          }),
                          onChanged: (value) {
                            _idType = value!;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text("ID Number")),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
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
                    // MaterialButton(
                    //   onPressed: () async {
                    //     // TODO: Submit the verification form.
                    //     final response;
                    //     if (args.suffix == null) {
                    //       String url = "http://127.0.0.1:8000/signup/";
                    //       response =
                    //           await json.decode((await http.post(Uri.parse(url), body: {
                    //         'first_name': args.firstName,
                    //         'last_name': args.lastName,
                    //         'middle_initial': args.middleName,
                    //         'username': args.username,
                    //         'password': args.password,
                    //         'email': args.email,
                    //         'phone_no': args.phoneNo,
                    //         'user_type': args.userType,
                    //         'id_type': _idType,
                    //         'id_number': _idNumber,
                    //         'id_picture': base64Image
                    //       }))
                    //               .body);
                    //     } else {
                    //       String url = "http://127.0.0.1:8000/signup/";
                    //       response =
                    //           await json.decode((await http.post(Uri.parse(url), body: {
                    //         'first_name': args.firstName,
                    //         'last_name': args.lastName,
                    //         'middle_initial': args.middleName,
                    //         'suffix': args.suffix,
                    //         'username': args.username,
                    //         'password': args.password,
                    //         'email': args.email,
                    //         'phone_no': args.phoneNo,
                    //         'user_type': args.userType,
                    //         'id_type': _idType,
                    //         'id_number': _idNumber,
                    //         'id_picture': base64Image
                    //       }))
                    //               .body);
                    //     }
                    //     //print(response);
                    //     base64Image = response['data']['id_picture'];
                    //     //print(base64Image);
                    //     uploadedImage = true;
                    //     setState(() {});
                    //   },
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20),
                    //     side: const BorderSide(
                    //         color: Color.fromARGB(255, 196, 94, 250), width: 2),
                    //   ),
                    //   child: const Text('Submit'),
                    // ),
                    // DONT REMOVE. IMPORTANT FOR TESTING
                    if (uploadedImage)
                      // Column(
                      //   children: [
                      //     Text(
                      //         "If you see this picture, this was from the database!"),
                      //     Image.memory(
                      //         Uri.parse(base64Image).data!.contentAsBytes())
                      //   ],
                      // ),
                      const SizedBox(height: 70),
                    navigationButtons
                  ],
                ),
              ),
            ),
          ),
        )));
  }

  @override
  void initState() {
    super.initState();
    //_chooseImage();
  }

  void _chooseImage() async {
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
        setState(() {
          _imageFile = result.files.first;
          showImageUploadError = false;
        });
        String extn = result.files.first.name.split('.').last;
        if (extn == 'png' || extn == 'PNG') {
          base64Image =
              "data:image/png;base64," + base64Encode(bytes!.toList());
        } else {
          base64Image =
              "data:image/jpeg;base64," + base64Encode(bytes!.toList());
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

        // print(base64Image);
      }
    } else {
      setState(() {
        _imageFile = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image selected!'),
        ),
      );
    }
  }
}
