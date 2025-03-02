import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/module/auth/cubit/auth_cubit.dart';
import 'package:go_router/go_router.dart';

import '../ui/prefix_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Settings'),
            ),
            SliverFillRemaining(
              child: Column(
                children: [
                  CupertinoFormSection.insetGrouped(
                    backgroundColor: Colors.transparent,
                    header: const Text("Profile"),
                    children: [
                      CupertinoListTile(
                        onTap: () => context.push('/authed/settings/profile'),
                        title: const PrefixWidget(
                          icon: CupertinoIcons.person_2_fill,
                          title: 'Edit Details',
                          color: CupertinoColors.systemOrange,
                        ),
                        trailing: const Icon(CupertinoIcons.forward),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    backgroundColor: Colors.transparent,
                    children: [
                      CupertinoListTile(
                        onTap: () => context.read<AuthCubit>().signOut(),
                        title: const PrefixWidget(
                          icon: CupertinoIcons.fullscreen_exit,
                          title: 'Log out',
                          color: CupertinoColors.systemRed,
                        ),
                        trailing: const Icon(CupertinoIcons.forward),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // CupertinoButton.filled(
            //   child: const Text("ID Token"),
            //   onPressed: () {
            //     context.read<AuthCubit>().getIdToken().then(logger.d);
            //   },
            // ),
            // CupertinoButton.filled(
            //   child: const Text("Log Out"),
            //   onPressed: () {
            //     context.read<AuthCubit>().signOut();
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
