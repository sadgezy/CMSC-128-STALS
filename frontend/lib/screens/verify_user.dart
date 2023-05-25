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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SignupArguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
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
                  child: Text('Professional Regulation Commission (PRC) ID'),
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
                  child: Text('Philippine Identification (PhilID / ePhilID)'),
                ),
                DropdownMenuItem(
                  value: 'NBI',
                  child: Text('NBI Clearance'),
                ),
                DropdownMenuItem(
                  value: 'IBP',
                  child: Text('Integrated Bar of the Philippines (IBP) ID'),
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
              onChanged: (value) => _idType = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'ID Number',
              ),
              onChanged: (value) => _idNumber = value,
            ),
            if (_imageFile != null)
             
              Image.memory(
                Uint8List.fromList(_imageFile!.bytes!),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            Container(
              width: 200.0,
              height: 40.0,
              color: Colors.grey,
              child: _idImage != null
                  ? Image.file(_idImage as File)
                  : IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _chooseImage();
                      },
                    ),
            ),
            const Text(
              'Only photos 4mb and below are allowed.',
              style: TextStyle(color: Colors.red),
            ),
            MaterialButton(
              onPressed: () async {
                // TODO: Submit the verification form.
                final response;
                if (args.suffix == null) {
                  String url = "http://127.0.0.1:8000/signup/";
                  response = await json.decode((await http
                          .post(Uri.parse(url), body: {
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
                  }))
                      .body);
                }
                else {
                  String url = "http://127.0.0.1:8000/signup/";
                  response = await json.decode((await http
                          .post(Uri.parse(url), body: {
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
                  }))
                      .body);
                }

                //print(response);
                base64Image = response['data']['id_picture'];
                //print(base64Image);
                uploadedImage = true;
                setState(() {
                  
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                    color: Color.fromARGB(255, 196, 94, 250), width: 2),
              ),
              child: const Text('Submit'),
            ),
            // DONT REMOVE. IMPORTANT FOR TESTING
            if (uploadedImage) Column(
              children: [
                Text("If you see this picture, this was from the database!"),
                Image.memory(Uri.parse(base64Image).data!.contentAsBytes())
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _chooseImage();
  }

  void _chooseImage() async {
    //ImagePicker picker = ImagePicker();
    //XFile? image = await picker.pickImage(source: ImageSource.gallery);
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png']);

    if (result != null) {
      setState(() {
        _imageFile = result.files.first;
      });

      final bytes = result.files.first.bytes;
      String extn = result.files.first.name.split('.').last;
      if (extn == 'png' || extn == 'PNG') {
        base64Image = "data:image/png;base64," + base64Encode(bytes!.toList());
      } else {
        base64Image = "data:image/jpeg;base64," + base64Encode(bytes!.toList());
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
    } else {
      _imageFile = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image selected'),
        ),
      );
    }
  }
}
