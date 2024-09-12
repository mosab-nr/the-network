import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import '../../singleton/shared_pref_manager.dart';

class SummariesScreen extends StatefulWidget {
  const SummariesScreen({super.key});

  @override
  State<SummariesScreen> createState() => _SummariesScreenState();
}

class _SummariesScreenState extends State<SummariesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<File> _selectedFiles = [];
  bool _isUploading = false;
  bool _isSelecting = false;
  bool _isLoading = false;
  double _uploadProgress = 0.0;
  List<Map<String, dynamic>> _uploadedFiles = [];
  String? name;

  @override
  void initState() {
    super.initState();
    _loadUploadedFiles();
    _loadUserNameFromSharedPref();
  }

  Future<void> _loadUserNameFromSharedPref() async {
    await SharedPrefManager().init();
    setState(() {
      name = SharedPrefManager().getUserName();
    });
  }

  Future<void> _selectFile() async {
    setState(() {
      _isSelecting = true;
    });

    if (await _requestPermission(Permission.storage)) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx'],
      );

      if (result != null) {
        setState(() {
          _selectedFiles
              .addAll(result.paths.map((path) => File(path!)).toList());
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم رفض الإذن للوصول إلى التخزين')),
      );
    }

    setState(() {
      _isSelecting = false;
    });
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    final user = _auth.currentUser;
    if (user != null) {
      final userName = name ?? 'unknown_user';
      final storageRef =
          _storage.ref().child('users').child(userName).child('summaries');
      final ListResult existingFiles = await storageRef.listAll();

      List<File> filesToUpload = [];

      for (var file in _selectedFiles) {
        final fileName = path.basename(file.path);
        final fileExists =
            existingFiles.items.any((item) => item.name == fileName);

        if (fileExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('الملف $fileName موجود بالفعل في التخزين')),
          );
        } else {
          filesToUpload.add(file);
        }
      }

      setState(() {
        _selectedFiles = filesToUpload;
      });

      for (var file in filesToUpload) {
        final fileName = path.basename(file.path);
        final uploadTask = storageRef.child(fileName).putFile(file);

        int fileIndex = _selectedFiles.indexOf(file);
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress =
              (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          if (mounted) {
            setState(() {
              _uploadedFiles[fileIndex]['progress'] = progress;
            });
          }
        });

        try {
          await uploadTask;
          final downloadUrl = await storageRef.child(fileName).getDownloadURL();
          if (mounted) {
            setState(() {
              _uploadedFiles[fileIndex]['url'] = downloadUrl;
            });
          }
        } catch (error) {
          print('Error uploading file: $error');
        }
      }
    }

    if (mounted) {
      setState(() {
        _isUploading = false;
        _selectedFiles.clear();
      });
      await _loadUploadedFiles(); // Refresh the list of uploaded files
    }
  }

  Future<void> _loadUploadedFiles() async {
    setState(() {
      _isLoading = true;
    });

    final storageRef = _storage.ref().child('users');
    final ListResult usersResult = await storageRef.listAll();

    for (var userRef in usersResult.prefixes) {
      final summariesRef = userRef.child('summaries');
      final ListResult summariesResult = await summariesRef.listAll();

      for (var ref in summariesResult.items) {
        final downloadUrl = await ref.getDownloadURL();
        setState(() {
          _uploadedFiles.add({
            'name': ref.name,
            'url': downloadUrl,
          });
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _downloadFile(String url, String fileName, int index) async {
    try {
      Dio dio = Dio();
      String savePath = '/storage/emulated/0/Download/The Network/$fileName';

      // Check if the file already exists
      if (File(savePath).existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('الملف موجود بالفعل في $savePath')),
        );
        return;
      }

      await dio.download(url, savePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          double progress = (received / total) * 100;
          setState(() {
            _uploadedFiles[index]['progress'] = progress.toInt();
          });
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تنزيل الملف إلى $savePath')),
      );
    } catch (e) {
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تنزيل الملف')),
      );
    }
  }

  void _deleteFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('CURRENT USER : ${_auth.currentUser?.displayName}');
    return Column(
      children: [
        // Upper Section
        Expanded(
          flex: 1,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _selectFile,
                        child: Text('اختر ملف من الجهاز'),
                      ),
                      ElevatedButton(
                        onPressed: _uploadFiles,
                        child: Text('رفع الملفات المختارة'),
                      ),
                    ],
                  ),
                  if (_isSelecting)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8.0),
                          Text('جارٍ تحديد الملفات...'),
                        ],
                      ),
                    ),
                  if (_selectedFiles.isNotEmpty && !_isSelecting)
                    Expanded(
                      child: ListView.builder(
                        itemCount: _selectedFiles.length,
                        itemBuilder: (context, index) {
                          String fileName =
                              _selectedFiles[index].path.split('/').last;
                          String fileExtension = path.extension(fileName);
                          IconData fileIcon;

                          if (fileExtension == '.pdf') {
                            fileIcon = Icons.picture_as_pdf;
                          } else if (fileExtension == '.doc' ||
                              fileExtension == '.docx') {
                            fileIcon = Icons.description;
                          } else {
                            fileIcon = Icons.insert_drive_file;
                          }

                          return ListTile(
                            leading: Icon(fileIcon),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(fileName),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteFile(index),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        // Lower Section
        Expanded(
          flex: 3,
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16.0),
                      Text('جارٍ تحميل الملفات...'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _uploadedFiles.length,
                  itemBuilder: (context, index) {
                    String fileName = _uploadedFiles[index]['name']!;
                    String fileExtension = path.extension(fileName);
                    IconData fileIcon;

                    if (fileExtension == '.pdf') {
                      fileIcon = Icons.picture_as_pdf;
                    } else if (fileExtension == '.doc' ||
                        fileExtension == '.docx') {
                      fileIcon = Icons.description;
                    } else {
                      fileIcon = Icons.insert_drive_file;
                    }

                    return ListTile(
                      leading: Icon(fileIcon),
                      title: Text(fileName),
                      subtitle: _uploadedFiles[index]['progress'] != null
                          ? LinearProgressIndicator(
                              value: _uploadedFiles[index]['progress'] / 100,
                            )
                          : null,
                      onTap: () {
                        _downloadFile(
                            _uploadedFiles[index]['url']!, fileName, index);
                      },
                    );
                  },
                ),
        )
      ],
    );
  }
}
