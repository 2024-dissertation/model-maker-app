import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/auth/repository/auth_repository.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/ui/modals/modal_sheet.dart';
import 'package:frontend/ui/themed/themed_text.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key, required this.onBack});

  final VoidCallback onBack;
  final AuthRepository _authRepository = getIt();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ThemedText(
                      "Create an account",
                      style: TextType.title,
                    ),
                    const SizedBox(height: 8),
                    ThemedText(
                      "Allows us to keep backups of your scans and syncs them across your devices.",
                      color: TextColor.muted,
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                _SignInButton(
                  icon: CupertinoIcons.envelope_fill,
                  label: 'Continue with Email',
                  backgroundColor: CupertinoColors.systemGrey5,
                  textColor: CupertinoColors.label,
                  onPressed: () => showModalSheet(
                    context: context,
                    child: const LoginPage(),
                  ),
                ),
                const SizedBox(height: 16),
                _SignInButton(
                  icon: CupertinoIcons.device_phone_portrait,
                  label: 'Continue with Apple',
                  backgroundColor: CupertinoColors.black,
                  textColor: CupertinoColors.white,
                  onPressed: () => _authRepository.signInWithApple(),
                ),
                const SizedBox(height: 16),
                _SignInButton(
                  icon: CupertinoIcons.person_crop_circle_badge_minus,
                  label: 'Continue as Guest',
                  backgroundColor: CupertinoColors.systemGrey6,
                  textColor: CupertinoColors.label,
                  onPressed: () => _authRepository.signInAnonymously(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: CupertinoColors.systemGrey4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ThemedText(
                          "or",
                          color: TextColor.muted,
                          style: TextType.body,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: CupertinoColors.systemGrey4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onBack,
                  child: ThemedText(
                    "Go Back",
                    color: TextColor.muted,
                    style: TextType.body,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: backgroundColor == CupertinoColors.systemGrey6
              ? Border.all(
                  color: CupertinoColors.systemGrey4,
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
