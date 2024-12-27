import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/scanner_page/page/scanner_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home Route'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              CupertinoButton.filled(
                child: const Text("Enter"),
                onPressed: () {
                  Navigator.of(context).pushNamed(ScannerPage.routeName);
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
