// ignore_for_file: use_super_parameters

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './auth/methods/user_storage.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    Key? key,
    required this.email,
    required this.password,
    required this.username,
  }) : super(key: key);

  @override
  AddPictureState createState() => AddPictureState();
}

class AddPictureState extends State<AddPicture> {
  Uint8List? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _image = imageBytes;
        });
      }
    } catch (e) {
      _showSnackBar("Error picking image: $e");
    }
  }

  // Function to upload image
  Future<void> _uploadImage() async {
    if (_image == null) {
      _showSnackBar("Please select an image to upload.");
      return;
    }

    try {
      _showSnackBar("Image uploaded successfully!");
    } catch (e) {
      _showSnackBar("Error uploading image: $e");
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Picture"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.memory(
                    _image!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : const Placeholder(
                    fallbackHeight: 150,
                    fallbackWidth: 150,
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Select Image"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text("Upload Image"),
            ),
          ],
        ),
      ),
    );
  }
}
