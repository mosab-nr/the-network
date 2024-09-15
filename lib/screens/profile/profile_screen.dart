import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();

  String? _profileImageUrl;
  String _gender = 'ذكر';
  DateTime? _dob;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _dobController.text =
    _dob != null ? _dob!.toLocal().toString().split(' ')[0] : '';
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _bioController.text = data['bio'] ?? '';
        _gender = data['gender'] ?? 'ذكر';
        _locationController.text = data['location'] ?? '';
        _dob = (data['dob'] as Timestamp?)?.toDate();
        _profileImageUrl = data['profileImageUrl'];
        _dobController.text =
        _dob != null ? _dob!.toLocal().toString().split(' ')[0] : '';
        _universityController.text = data['university'] ?? '';
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': _nameController.text,
          'email': _emailController.text,
          'bio': _bioController.text,
          'gender': _gender,
          'location': _locationController.text,
          'dob': _dob != null ? Timestamp.fromDate(_dob!) : null,
          'profileImageUrl': _profileImageUrl,
          'university': _universityController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ المعلومات بنجاح')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      var status = androidInfo.version.sdkInt <= 32
          ? await Permission.storage.request()
          : await Permission.photos.request();

      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          setState(() {
            _isUploading = true;
          });

          final user = _auth.currentUser;
          if (user != null) {
            final file = File(pickedFile.path);
            final userName = _nameController.text;
            final storageRef = _storage
                .ref()
                .child('users')
                .child(userName)
                .child('profile_image.jpg');
            final uploadTask = storageRef.putFile(file);

            uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
              setState(() {
                _uploadProgress =
                    (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
              });
            });

            await uploadTask.whenComplete(() async {
              final downloadUrl = await storageRef.getDownloadURL();
              setState(() {
                _profileImageUrl = downloadUrl;
                _isUploading = false;
              });
              log('Profile image uploaded successfully: $downloadUrl');
            }).catchError((error) {
              setState(() {
                _isUploading = false;
              });
              log('Error uploading profile image: $error');
            });
          }
        } else {
          log('No image selected');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied to access photos')),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
        _dobController.text = _dob!.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الملف الشخصي'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : const AssetImage(
                                'assets/images/profileplaceholder.jpg')
                            as ImageProvider,
                            child: ClipOval(
                              child: _profileImageUrl != null
                                  ? Image.network(
                                _profileImageUrl!,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              )
                                  : Image.asset(
                                'assets/logos/thenetwrok.jpg',
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          if (_isUploading)
                            CircularProgressIndicator(
                              value: _uploadProgress / 100,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          if (_isUploading)
                            Text(
                              '${_uploadProgress.toStringAsFixed(0)}%',
                              style: const TextStyle(color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _nameController,
                      decoration:
                      const InputDecoration(labelText: 'الإسم الكامل'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'من فضلك أدخل الإسم الكامل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      decoration:
                      const InputDecoration(labelText: 'البريد الإلكتروني'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'من فضلك أدخل البريد الإلكتروني';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(labelText: 'نبذة عني'),
                      maxLines: 3,
                      maxLength: 100,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 16.0),
                    const Text('الجنس'),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('ذكر'),
                            value: 'ذكر',
                            groupValue: _gender,
                            onChanged: (String? value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('أنثى'),
                            value: 'أنثى',
                            groupValue: _gender,
                            onChanged: (String? value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _locationController,
                      decoration:
                      const InputDecoration(labelText: 'من أين أنت'),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _dobController,
                      decoration:
                      const InputDecoration(labelText: 'تاريخ الميلاد'),
                      readOnly: true,
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _universityController,
                      decoration: const InputDecoration(
                          labelText: 'الجامعة التي تدرس فيها'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _saveUserData,
                      child: const Text('حفظ المعلومات'),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}