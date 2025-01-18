import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/prefix_widget.dart';

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
              child: CupertinoFormSection.insetGrouped(
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
