import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/router.dart';
import 'package:frontend/theme.dart';
import 'package:frontend/theme/cubit/theme_cubit.dart';
import 'package:frontend/theme/cubit/theme_state.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late final AppRouter router;
  late Brightness _currentBrightness;

  @override
  void initState() {
    router = AppRouter();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _currentBrightness =
          View.of(context).platformDispatcher.platformBrightness;
    });
    super.initState();
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
    return BlocListener<AuthCubit, AuthState>(
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
