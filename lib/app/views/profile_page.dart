import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/logger.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Profile Page'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              CupertinoButton.filled(
                child: const Text("ID Token"),
                onPressed: () {
                  context.read<AuthCubit>().getIdToken().then(logger.d);
                },
              ),
              CupertinoButton.filled(
                child: const Text("Log Out"),
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
