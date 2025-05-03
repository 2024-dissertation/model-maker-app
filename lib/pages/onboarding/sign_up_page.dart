import 'package:flutter/cupertino.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/auth/repository/auth_repository.dart';
import 'package:frontend/pages/login_page.dart';
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
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(
                Buttons.email,
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
                          height: 319,
                          child: LoginPage(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SignInButton(
                Buttons.appleDark,
                onPressed: () => _authRepository.signInWithApple(),
              ),
              // SignInButton(
              //   Buttons.googleDark,
              //   onPressed: () => _authRepository.signInWithGoogle(),
              // ),
            ],
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CupertinoButton.filled(
              onPressed: () => onBack(),
              child: ThemedText("Back"),
            ),
          ),
        ),
      ],
    );
  }
}
