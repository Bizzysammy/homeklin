import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profilesetting extends StatefulWidget {
  const Profilesetting({Key? key}) : super(key: key);

  @override
  State<Profilesetting> createState() => _ProfilesettingState();
}

class _ProfilesettingState extends State<Profilesetting> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  User? _user;
  String? _userName;
  String? _userEmail;
  File? _imageFile;
  String? _newPassword;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _loadUserData();
    _loadProfileImage(); // Load the profile image initially
  }


  Future<void> _loadUserData() async {
    final DocumentSnapshot userDoc =
    await _firestore.collection('Customers').doc(_user!.uid).get();

    setState(() {
      _userName = userDoc['name'];
      _userEmail = _user!.email;
    });
  }

  Future<void> _loadProfileImage() async {
    final userDoc = await _firestore.collection('Customers').doc(_user!.uid).get();
    final profileImageUrl = userDoc['profile_photo'];

    setState(() {
      imageUrl = profileImageUrl;
    });
  }

  Future<void> _updateProfile() async {
    try {
      if (_userName != null) {
        await _firestore
            .collection('Customers')
            .doc(_user!.uid)
            .update({'name': _userName});
      }
      if (_imageFile != null) {
        final String fileName = 'profile_${_user!.uid}.jpg';
        final Reference storageRef = _storage.ref().child(fileName);
        await storageRef.putFile(_imageFile!);
        final String newImageUrl = await storageRef.getDownloadURL();
        await _firestore
            .collection('Customers')
            .doc(_user!.uid)
            .update({'profile_photo': newImageUrl});

        // Update the imageUrl variable and trigger a rebuild
        setState(() {
          imageUrl = newImageUrl;
        });
      }
      if (_newPassword != null) {
        await _user!.updatePassword(_newPassword!);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }



  Future<void> _gallery() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _camera() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.camera, // Change to ImageSource.camera
      imageQuality: 50,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C54),
        title: const Text('Profile Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Profile Picture"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.photo_camera),
                            title: const Text("Take a Photo"),
                            onTap: () {
                              Navigator.of(context).pop(); // Close the dialog
                              _camera();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo),
                            title: const Text("Choose from Gallery"),
                            onTap: () {
                              Navigator.of(context).pop(); // Close the dialog
                              _gallery();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!) // Use NetworkImage if imageUrl is not null
                    : const AssetImage('assets/logo.jpg') as ImageProvider,// Use AssetImage and cast it to ImageProvider
              ),
            ),



            const SizedBox(height: 16),
            TextFormField(
              initialValue: _userName ?? '',
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
              ),
              onChanged: (value) {
                setState(() {
                  _userName = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _userEmail ?? '',
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              onChanged: (value) {
                setState(() {
                  _userEmail = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter a new password',
              ),
              onChanged: (value) {
                setState(() {
                  _newPassword = value;
                });
              },
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }
}
