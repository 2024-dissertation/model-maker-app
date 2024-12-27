import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:frontend/router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository();
    _authCubit = AuthCubit(authenticationRepository: _authenticationRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: _authenticationRepository),
        ],
        child: CupertinoApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        ),
      ),
    );
  }
}
