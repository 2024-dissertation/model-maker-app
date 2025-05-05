import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/module/user/cubit/my_user_cubit.dart';
import 'package:frontend/module/user/cubit/my_user_state.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionModal extends StatefulWidget {
  const VersionModal({super.key});

  @override
  State<VersionModal> createState() => _VersionModalState();
}

class _VersionModalState extends State<VersionModal> {
  bool loading = true;

  late String appName;
  late String packageName;
  late String version;
  late String buildNumber;

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      loading = false;
    });
  }

  @override
  initState() {
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        largeTitle: Text('Version Info'),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppPadding.md),
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppPadding.lg + 4),
              if (loading)
                const Center(child: CircularProgressIndicator())
              else ...[
                _buildVersionInfoRow("App Name", appName),
                _buildVersionInfoRow("Package Name", packageName),
                _buildVersionInfoRow("Version", version),
                _buildVersionInfoRow("Build Number", buildNumber),
                _buildVersionInfoRow(
                    "UserId",
                    (context.read<MyUserCubit>().state as MyUserLoaded)
                        .myUser
                        .id
                        .toString()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfoRow(String name, String value) {
    return ThemedCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ThemedText(name),
          ThemedText(
            value,
            weight: FontWeight.w600,
          )
        ],
      ),
    );
  }
}
