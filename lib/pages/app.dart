import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/helpers/router.dart';
import 'package:frontend/helpers/theme.dart';
import 'package:frontend/module/theme/cubit/theme_cubit.dart';
import 'package:frontend/module/theme/cubit/theme_state.dart';
import 'package:frontend/module/user/cubit/my_user_cubit.dart';
import 'package:frontend/module/user/cubit/my_user_state.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  displayNotification(message);
}

void displayNotification(RemoteMessage message) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
        android: AndroidInitializationSettings('mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings()),
  );

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: message.data.toString(),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late final AppRouter router;
  late Brightness _currentBrightness;

  Future<void> setupInteractedMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      displayNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _handleMessage(RemoteMessage message) {
    logger.d("Handling message: ${message.data}");
  }

  Future<String?> getToken() async {
    try {
      final notificationSettings =
          await FirebaseMessaging.instance.requestPermission(provisional: true);

      // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      logger.d("APNS token: $apnsToken");
      if (apnsToken != null) {
        // APNS token is available, make FCM plugin API requests...
      }

      final fcmToken = await FirebaseMessaging.instance.getToken();
      logger.d("FCM token: $fcmToken");
      return fcmToken;
    } catch (e) {
      logger.e("Error getting FCM token: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    router = AppRouter();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _currentBrightness =
          View.of(context).platformDispatcher.platformBrightness;
    });
    setupInteractedMessage();
    getToken();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final systemBrightness =
        View.of(context).platformDispatcher.platformBrightness;

    if (systemBrightness != _currentBrightness) {
      setState(() {
        _currentBrightness = systemBrightness;
      });
      context.read<ThemeCubit>().setTheme(
            systemBrightness == Brightness.dark
                ? ThemeState.dark
                : ThemeState.light,
          );
    }
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyUserCubit, MyUserState>(
      listener: (context, state) {
        router.router.refresh();
      },
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return CupertinoApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router.router,
            theme: state == ThemeState.light ? cupertinoLight : cupertinoDark,
          );
        },
      ),
    );
  }
}
