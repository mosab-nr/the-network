import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_network/app.dart';
import 'package:the_network/firebase_options.dart';

void main() async {
// Todo: Add Widgets Binding
  WidgetsFlutterBinding.ensureInitialized();

// Todo: Init local Storage

// Todo: Await Native Splash

// Todo: Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// Todo: Initialize Authentication

  runApp( const MyApp(),);
}

void configureFirestore() {
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}
