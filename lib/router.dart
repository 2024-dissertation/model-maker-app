import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/home_page/views/home_page.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/register/views/register_page.dart';
import 'package:frontend/splash_screen/views/splash_screen.dart';
import 'package:frontend/unauthorized/views/unauthorized_page.dart';
import 'package:frontend/login/views/login_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
// GoRouter configuration
  final router = GoRouter(
    navigatorKey: Globals.navigatorKey,
    initialLocation: '/unauthorized',
    routes: [
      GoRoute(
        path: '/splash-screen',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/unauthorized',
        builder: (context, state) => const UnauthorizedPage(),
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'register',
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    redirect: (context, state) {
      logger.d(state.matchedLocation);
      if ((context.read<AuthCubit>().state == AuthState.initial ||
              context.read<AuthCubit>().state == AuthState.signedOut) &&
          state.matchedLocation.startsWith('/unauthorized') == false) {
        return '/unauthorized';
      }

      if (context.read<AuthCubit>().state == AuthState.loading) {
        return '/splash-screen';
      }

      if (context.read<AuthCubit>().state == AuthState.signedIn) {
        return '/home';
      }

      return null;
    },
  );
}
