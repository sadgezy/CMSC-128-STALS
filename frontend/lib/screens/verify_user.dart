import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String _idType = '';
  String _idNumber = '';
  XFile? _idImage;

  @override
  Widget build(BuildContext context) {
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
            Container(
              width: 200.0,
              height: 200.0,
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
              onPressed: () {
                // TODO: Submit the verification form.
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                    color: Color.fromARGB(255, 196, 94, 250), width: 2),
              ),
              child: const Text('Submit'),
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
    ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _idImage = image as XFile?;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image selected'),
        ),
      );
    }
  }
}
