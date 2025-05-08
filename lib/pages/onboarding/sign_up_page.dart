import 'package:flutter/cupertino.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/auth/repository/auth_repository.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/ui/primary_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key, required this.onBack});

  final VoidCallback onBack;

  final AuthRepository _authRepository = getIt();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.md),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ThemedText(
                  "Create an account",
                  style: TextType.title,
                ),
                ThemedText(
                  "Allows us to keep backups of your scans and syncs them across your devices.",
                  color: TextColor.muted,
                ),
                SizedBox(height: AppPadding.md),
                SignInButton(
                  Buttons.email,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () => showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return AnimatedPadding(
                        duration: Duration(milliseconds: 0),
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16)),
                          child: Container(
                            color: CupertinoTheme.of(context)
                                .scaffoldBackgroundColor,
                            height: 500,
                            child: LoginPage(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SignInButton(
                  Buttons.appleDark,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () => _authRepository.signInWithApple(),
                ),
                SignInButton(
                  Buttons.anonymous,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () => _authRepository.signInAnonymously(),
                ),
                // SignInButton(
                //   Buttons.googleDark,
                //   onPressed: () => _authRepository.signInWithGoogle(),
                // ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: PrimaryCard.medium(
              onTap: () => onBack(),
              child: ThemedText(
                "Continue",
                weight: FontWeight.w600,
                color: TextColor.inverse,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
