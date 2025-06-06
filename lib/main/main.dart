import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/helpers/locator.dart';
import 'package:frontend/module/analytics/cubit/analytics_cubit.dart';
import 'package:frontend/module/collections/cubit/collection_cubit.dart';
import 'package:frontend/module/home/cubit/home_cubit.dart';
import 'package:frontend/pages/app.dart';
import 'package:frontend/module/user/cubit/my_user_cubit.dart';
import 'package:frontend/config/firebase_options.dart';
import 'package:frontend/helpers/globals.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/theme/cubit/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

late FirebaseAnalytics analytics;

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  analytics = FirebaseAnalytics.instance;

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e(error, stackTrace: stack);
    return true;
  };

  availableCameras().then((value) => Globals.cameras = value);

  injectDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MyUserCubit()..init(),
        ),
        BlocProvider(create: (_) => AnalyticsCubit()..getAnalytics()),
        BlocProvider(create: (_) => CollectionCubit()..fetchCollections()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => HomeCubit()..fetchTasks()),
      ],
      child: const App(),
    ),
  );
}
