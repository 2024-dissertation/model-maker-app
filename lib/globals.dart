import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Globals {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String baseUrl = "https://f4c8-143-167-37-27.ngrok-free.app";
  static List<CameraDescription> cameras = [];
}
