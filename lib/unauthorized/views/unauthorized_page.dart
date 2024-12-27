import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class UnauthorizedPage extends StatelessWidget {
  const UnauthorizedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              CupertinoButton.filled(
                child: const Text('Login'),
                onPressed: () {
                  context.go('/unauthorized/login');
                },
              ),
              CupertinoButton.filled(
                child: const Text('Register'),
                onPressed: () {
                  context.go('/unauthorized/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
