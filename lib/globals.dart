import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Globals {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String baseUrl = "http://soup.soup-dissertation.katapult.cloud:3001";
  static List<CameraDescription> cameras = [];
}
