import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_network/app.dart';
import 'package:the_network/firebase_options.dart';

void main() async {
// Todo: Add Widgets Binding
  WidgetsFlutterBinding.ensureInitialized();

// Todo: Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp( const MyApp(),);
}

void configureFirestore() {
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}

// Future<void> addTemplateDataToFirestore() async {
//   // Initialize Firebase
//   await Firebase.initializeApp();
//
//   // Reference to Firestore
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   // Template data
//   List<Map<String, dynamic>> universities = [
//     {
//       'name': 'University A',
//       'departments': ['Department 1', 'Department 2', 'Department 3'],
//     },
//     {
//       'name': 'University B',
//       'departments': ['Department 4', 'Department 5'],
//     },
//     {
//       'name': 'University C',
//       'departments': ['Department 6', 'Department 7', 'Department 8', 'Department 9'],
//     },
//   ];
//
//   // Add template data to Firestore
//   for (var university in universities) {
//     await firestore.collection('universities').add(university);
//   }
//
//   print('Template data added to Firestore');
// }