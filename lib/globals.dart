import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Globals {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String baseUrl =
      "https://950d-86-19-111-199.ngrok-free.app"; // "http://localhost:3333";
  static List<CameraDescription> cameras = [];
}
