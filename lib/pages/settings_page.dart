import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/module/auth/cubit/auth_cubit.dart';
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
                largeTitle: Text('Settings'),
              ),
              SliverFillRemaining(
                child: CupertinoListSection(
                  children: [
                    CupertinoFormSection.insetGrouped(
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
                      header: const Text("About"),
                      children: [
                        CupertinoListTile(
                          // onTap: () => context.push('/authed/settings/profile'),
                          title: const PrefixWidget(
                            icon: CupertinoIcons.info,
                            title: 'About',
                            color: CupertinoColors.systemGrey,
                          ),
                          trailing: const Icon(CupertinoIcons.forward),
                        ),
                        CupertinoListTile(
                          // onTap: () => context.push('/authed/settings/profile'),
                          title: const PrefixWidget(
                            icon: CupertinoIcons.number,
                            title: 'App Version',
                            color: CupertinoColors.systemGrey,
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
            ],
          ),
          Positioned(
            left: 25,
            right: 25,
            bottom: 100,
            child: CupertinoButton.filled(
              child: const Text("Log Out"),
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
