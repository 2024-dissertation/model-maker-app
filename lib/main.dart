import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/home_page/views/home_page.dart';
import 'package:frontend/scanner_page/cubit/scanner_cubit.dart';
import 'package:frontend/scanner_page/page/scanner_page.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        HomePage.routeName: (BuildContext context) {
          return const HomePage();
        },
        ScannerPage.routeName: (BuildContext context) {
          return BlocProvider<ScannerCubit>(
            create: (_) => ScannerCubit(),
            child: ScannerPage(cameras: cameras),
          );
        }
      },
    );
  }
}
