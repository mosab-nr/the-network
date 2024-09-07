import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:the_network/app.dart';
import 'package:the_network/firebase_options.dart';

void main() async {
// Todo: Add Widgets Binding
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

// Todo: Init local Storage

// Todo: Await Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

// Todo: Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// Todo: Initialize Authentication

  runApp(const MyApp());

}

void configureFirestore() {
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}
