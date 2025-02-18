import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/cubit/my_user_cubit.dart';
import 'package:frontend/data_source/api_data_source.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:frontend/repositories/my_user_repository.dart';
import 'package:frontend/theme/cubit/theme_cubit.dart';
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
    logger.e(error);
    return true;
  };

  availableCameras().then((value) => Globals.cameras = value);

  await injectDependencies();

  MyUserCubit myUserCubit = MyUserCubit();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: myUserCubit),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => AuthCubit(myUserCubit: myUserCubit)..init(),
        ),
      ],
      child: const App(),
    ),
  );
}

// Helper function to inject dependencies
Future<void> injectDependencies() async {
  // Inject the data source.
  getIt.registerLazySingleton(() => ApiDataSource());

  // Inject the Repositories. Note that the type is the abstract class
  // and the injected instance is the implementation.
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<MyUserRepository>(() => MyUserRepository());
}
