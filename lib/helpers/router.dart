import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/views/app_layout.dart';
import 'package:frontend/module/auth/cubit/auth_cubit.dart';
import 'package:frontend/helpers/globals.dart';
import 'package:frontend/module/auth/cubit/auth_state.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/pages/scanner_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/settings_page.dart';
import 'package:frontend/pages/splash_screen.dart';
import 'package:frontend/pages/unauthorized_page.dart';
import 'package:frontend/pages/view_images.dart';
import 'package:frontend/pages/view_task.dart';
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
                routes: [
                  GoRoute(
                    path: 'tasks/:id',
                    builder: (context, state) {
                      final taskId = state.pathParameters['id'];
                      return ViewTask(taskId: int.parse("$taskId"));
                    },
                  ),
                  GoRoute(
                    path: 'task',
                    builder: (context, state) {
                      final task = state.extra as Task?;
                      return ViewTask(task: task);
                    },
                    routes: [
                      GoRoute(
                        path: 'images',
                        builder: (context, state) {
                          final task = state.extra as Task;
                          return ViewTaskImages(task: task);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/authed/new',
                builder: (context, state) => const ScannerPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/authed/settings',
                builder: (context, state) => const SettingsPage(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    builder: (context, state) => const ProfilePage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
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
