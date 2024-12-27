import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter router;

  @override
  void initState() {
    super.initState();
    router = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        logger.d("Refreshed");
        router.router.refresh();
      },
      child: CupertinoApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router.router,
      ),
    );
  }
}
