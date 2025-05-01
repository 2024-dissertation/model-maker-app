import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/module/auth/cubit/auth_cubit.dart';
import 'package:frontend/ui/modals/about_modal.dart';
import 'package:frontend/ui/modals/version_modal.dart';
import 'package:frontend/ui/themed/themed_list_item.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';

import '../ui/prefix_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const CupertinoSliverNavigationBar(
                largeTitle: Text(
                  'Settings',
                ),
              ),
              SliverFillRemaining(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.md),
                  child: Column(
                    spacing: AppPadding.sm,
                    children: [
                      ThemedListItem(
                        onTap: () => context.push('/authed/settings/profile'),
                        title: const PrefixWidget(
                          icon: CupertinoIcons.person_2_fill,
                          title: 'Edit Details',
                          color: CupertinoColors.systemOrange,
                        ),
                        trailing: const Icon(CupertinoIcons.forward),
                        dismissableKey: 'profile',
                      ),
                      ThemedListItem(
                        onTap: () {
                          showCupertinoSheet(
                              context: context,
                              useNestedNavigation: true,
                              pageBuilder: (BuildContext context) =>
                                  AboutModal());
                        },
                        title: const PrefixWidget(
                          icon: CupertinoIcons.info,
                          title: 'About',
                          color: CupertinoColors.systemGrey,
                        ),
                        trailing: const Icon(CupertinoIcons.forward),
                        dismissableKey: 'profile',
                      ),
                      ThemedListItem(
                        onTap: () {
                          showCupertinoSheet(
                              context: context,
                              useNestedNavigation: true,
                              pageBuilder: (BuildContext context) =>
                                  VersionModal());
                        },
                        title: const PrefixWidget(
                          icon: CupertinoIcons.number,
                          title: 'App Version',
                          color: CupertinoColors.systemGrey,
                        ),
                        trailing: const Icon(CupertinoIcons.forward),
                        dismissableKey: 'version',
                      ),
                      // ThemedListItem(
                      //   onTap: () => context.push('/authed/settings/urls'),
                      //   title: const PrefixWidget(
                      //     icon: CupertinoIcons.wifi,
                      //     title: 'Change Server',
                      //     color: CupertinoColors.systemOrange,
                      //   ),
                      //   trailing: const Icon(CupertinoIcons.forward),
                      //   dismissableKey: 'server',
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 25,
            right: 25,
            bottom: 100,
            child: CupertinoButton.filled(
              child: const ThemedText("Log Out", color: TextColor.inverse),
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
