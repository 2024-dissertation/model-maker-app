import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Globals {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // static String baseUrl = "http://stuvm250403.dcs.shef.ac.uk:3333/";
  static String baseUrl = "http://localhost:3333/";
  static List<CameraDescription> cameras = [];
}
// static String baseUrl = "http://soup.soup-dissertation.katapult.cloud:3001";
