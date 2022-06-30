import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotelist_fe_mobile/screens/splash_screen.dart';

void main() {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HoteList',
      home: SplashScreen(),
    );
  }
}
