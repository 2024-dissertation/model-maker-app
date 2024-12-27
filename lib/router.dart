import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/home_page/views/app_layout.dart';
import 'package:frontend/home_page/views/home_page.dart';
import 'package:frontend/home_page/views/profile_page.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/register/views/register_page.dart';
import 'package:frontend/scanner_page/page/scanner_page.dart';
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
      StatefulShellRoute(
        builder: (context, state, child) {
          return child;
        },
        // https://gist.github.com/tolo/b26bd0ccb89a5fa2e57ec715f8963f2a
        navigatorContainerBuilder: (
          context,
          StatefulNavigationShell navigationShell,
          List<Widget> children,
        ) =>
            AppLayout(
          navigationShell: navigationShell,
          children: children,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/authed/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/authed/new',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/authed/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
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

      if (context.read<AuthCubit>().state == AuthState.signedIn &&
          state.matchedLocation.startsWith('/authed') == false) {
        return '/authed/home';
      }

      return null;
    },
  );
}
