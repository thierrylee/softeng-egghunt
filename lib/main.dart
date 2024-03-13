import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:softeng_egghunt/app_router.dart';
import 'package:softeng_egghunt/landing_page/landing_page.dart';
import 'package:softeng_egghunt/theme_factory.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initFirebase();
  runApp(const EggHuntApp());
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
}

class EggHuntApp extends StatelessWidget {
  const EggHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRouter.handleRoute,
      darkTheme: ThemeFactory.buildDarkTheme(),
      theme: ThemeFactory.buildLightTheme(),
      themeMode: ThemeMode.system,
      title: "SoftEng EggHunt",
      home: const LandingPage(),
    );
  }
}
