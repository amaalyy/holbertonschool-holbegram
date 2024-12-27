// ignore_for_file: use_key_in_widget_constructors

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './methods/post_storage.dart';
import '../home.dart';

class AddImage extends StatefulWidget {
  @override
  _AddImagePageState createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _image;
  String? _caption;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        _image = await pickedFile.readAsBytes();
        setState(() {});
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _uploadPost() async {
    if (_image != null && _caption != null && _caption!.isNotEmpty) {
      String uid = 'user_uid';
      String username = 'user_username';
      String profImage = 'profile_image_url';

      PostStorage postStorage = PostStorage();
      String result = await postStorage.uploadPost(
        _caption!,
        uid,
        username,
        profImage,
        _image!,
      );

      if (result == "Ok") {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false,
        );
      } else {
        print("Error uploading post: $result");
      }
    } else {
      print("Please select an image and enter a caption.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _uploadPost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _caption = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter caption...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            _image != null
                ? Image.memory(_image!)
                : const Text('No image selected.'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Gallery'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: const Text('Camera'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
