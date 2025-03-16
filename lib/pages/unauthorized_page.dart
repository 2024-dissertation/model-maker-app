import 'package:flutter/cupertino.dart';
import 'package:frontend/module/auth/repository/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../main/main.dart';

class UnauthorizedPage extends StatelessWidget {
  const UnauthorizedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRepository _authRepository = getIt();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Welcome'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            spacing: 8,
            children: [
              const Text("Sign in to continue"),
              SignInButton(
                Buttons.email,
                onPressed: () => context.go('/unauthorized/login'),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              SignInButton(
                Buttons.apple,
                onPressed: () => _authRepository.signInWithApple(),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              SignInButton(
                Buttons.google,
                onPressed: () => _authRepository.signInWithGoogle(),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
