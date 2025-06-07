import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/views/app_layout.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/user/cubit/my_user_cubit.dart';
import 'package:frontend/helpers/globals.dart';
import 'package:frontend/module/user/cubit/my_user_state.dart';
import 'package:frontend/pages/analytics_page.dart';
import 'package:frontend/pages/collection_list_page.dart';
import 'package:frontend/pages/collection_page.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/pages/scanner_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/settings_page.dart';
import 'package:frontend/pages/splash_screen.dart';
import 'package:frontend/pages/onboarding/unauthorized_page.dart';
import 'package:frontend/pages/url_selector_page.dart';
import 'package:frontend/pages/view_images.dart';
import 'package:frontend/pages/view_messages.dart';
import 'package:frontend/pages/view_task.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          // Show splash screen only during initial load
          final userState = context.watch<MyUserCubit>().state;
          if (userState is MyUserInitial || userState is MyUserLoading) {
            return const SplashScreen();
          }
          // Redirect to appropriate page based on auth state
          return userState.isAuthenticated
              ? HomePage()
              : const UnauthorizedPage();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute(
        builder: (context, state, child) {
          return child;
        },
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
                builder: (context, state) => HomePage(),
                routes: [
                  GoRoute(
                    path: 'task/:id',
                    builder: (context, state) {
                      final taskId = state.pathParameters['id'];
                      return ViewTask(taskId: int.parse("$taskId"));
                    },
                    routes: [
                      GoRoute(
                        path: 'messages',
                        builder: (context, state) {
                          final taskId = state.pathParameters['id'];
                          return TaskMessagePage(taskId: int.parse("$taskId"));
                        },
                      ),
                      GoRoute(
                        path: 'images',
                        builder: (context, state) {
                          final taskId = state.pathParameters['id'];
                          return ViewTaskImages(taskId: int.parse("$taskId"));
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
                path: '/authed/analytics',
                builder: (context, state) => const AnalyticsPage(),
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
                  path: '/authed/collection',
                  builder: (context, state) => const CollectionPage(),
                  routes: [
                    GoRoute(
                      path: '/:id',
                      builder: (context, state) {
                        final id = state.pathParameters['id'];
                        return CollectionListPage(
                            collectionId: int.parse("$id"));
                      },
                    ),
                  ]),
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
                  GoRoute(
                    path: 'urls',
                    builder: (context, state) {
                      return const UrlSelectorPage();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final userState = context.read<MyUserCubit>().state;

      // Don't redirect during initial load or loading state
      if (userState is MyUserInitial || userState is MyUserLoading) {
        return null;
      }

      // Handle authentication redirects
      final isAuthenticated = userState.isAuthenticated;
      final isGoingToAuth = state.matchedLocation.startsWith('/authed');
      final isGoingToLogin = state.matchedLocation == '/login';

      // If user is not authenticated and trying to access auth routes
      if (!isAuthenticated && isGoingToAuth) {
        return '/';
      }

      // If user is authenticated and trying to access login
      if (isAuthenticated && isGoingToLogin) {
        return '/authed/home';
      }

      // If user is authenticated and at root, go to home
      if (isAuthenticated && state.matchedLocation == '/') {
        return '/authed/home';
      }

      return null;
    },
  );
}
