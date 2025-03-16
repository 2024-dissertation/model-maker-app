import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Globals {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String baseUrl = "https://5a5e-185-152-1-1.ngrok-free.app/";
  static List<CameraDescription> cameras = [];
}
// static String baseUrl = "http://soup.soup-dissertation.katapult.cloud:3001";
