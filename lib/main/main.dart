import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/helpers/locator.dart';
import 'package:frontend/module/analytics/cubit/analytics_cubit.dart';
import 'package:frontend/module/collections/cubit/collection_cubit.dart';
import 'package:frontend/pages/app.dart';
import 'package:frontend/module/auth/cubit/auth_cubit.dart';
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

  FlutterError.onError = (details) => logger.d;

  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e(error, stackTrace: stack);
    return true;
  };

  availableCameras().then((value) => Globals.cameras = value);

  injectDependencies();

  MyUserCubit myUserCubit = MyUserCubit();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: myUserCubit),
        BlocProvider(create: (_) => AnalyticsCubit()),
        BlocProvider(create: (_) => CollectionCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => AuthCubit(myUserCubit: myUserCubit)..init(),
        ),
      ],
      child: const App(),
    ),
  );
}
