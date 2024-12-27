import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/app.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/logger.dart';

late List<CameraDescription> cameras;
late FirebaseAnalytics analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  analytics = FirebaseAnalytics.instance;

  FlutterError.onError = (details) => logger.d;

  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e(error);
    return true;
  };

  cameras = await availableCameras();

  runApp(const App());
}
